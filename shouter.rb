require 'rubygems'
require 'active_record'
require 'sinatra'
require "sinatra/reloader" if development?
require 'pp'
require 'digest'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'shouter.sqlite'
)
I18n.enforce_available_locales = false 

set :port, 3000
enable :sessions


class User < ActiveRecord::Base
	has_many :shouts
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
	if User.where(:handle => "#{params[:handle]}").size > 0
		@@user = User.find_by(:handle => "#{params[:handle]}")
 		session[:user_id] = @@user.id
 			if @@user.password == "#{params[:realpassword]}"
 			session[:loginanswer] = ""
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
	@shouts = Shout.all.reverse
	@title = "Here are all shouts"
	@users = User.all
    erb(:mainpage)
end

post('/mainpage') do
	@shout = @@user.shouts.create(user_id: session[:user_id], message: params[:message], created_at: Time.now, likes: 0)
redirect('/mainpage')
end

get("/likes/:shout_id") do
	shout = Shout.find(params[:shout_id])
	shout.update(likes: shout.likes + 1)
redirect('/mainpage')
end

get("/best") do
	@title = "Here are the top 5 shouts"
	@shouts = Shout.all.order('likes desc').limit(5)
	@users = User.all
	erb(:mainpage)
end

get("/:handle") do
	@title = "Here are all posts from #{params[:handle]}"
	@users = User.all
	@shouts = Shout.where(user_id: @users.find_by(handle: "#{params[:handle]}").id)
	erb(:mainpage)
end










