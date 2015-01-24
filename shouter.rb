require 'rubygems'
require 'active_record'
require 'sinatra'
require "sinatra/reloader" if development?
require 'pp'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'shouter.sqlite'
)
I18n.enforce_available_locales = false 

set :port, 3000
enable :sessions


class User < ActiveRecord::Base
	has_many :shouts

	def add_shout
	 shout = Shout.new(user_id: session[:user], message: params[message], created_at: Time.now)
	 shout.save
	end

end

class Shout < ActiveRecord::Base
	belongs_to :user

end




get('/') do
   	erb(:shouter)
 end

post('/') do 
	user = User.create(name: params[:name], handle: params[:handle], password: (0...20).map { (65 + rand(26)).chr }.join)
 	session[:userpassword] = user.password
 	redirect('/showpassword')
end

get('/showpassword') do
	@password = session[:userpassword]   	
   	erb(:showpassword)
end

get('/loginpage') do
	@answer = session[:loginanswer]
   	erb(:loginpage)
 end

post('/loginpage') do 
	if User.where(:handle => "#{params[:handle]}").size >= 1
		user = User.find_by(:handle => "#{params[:handle]}")
 		session[:user_id].id
 		if user.password == "#{params[:realpassword]}"
 		redirect('/mainpage')
 		else
 		session[:loginanswer] = "wrong password"
  		redirect('/loginpage')
  		end
  	else
   	session[:loginanswer] = "wrong user"
  	redirect('/loginpage')
  	end
end



get('/mainpage') do

    erb(:mainpage)
end

post('/mainpage') do 
add_shout

end


