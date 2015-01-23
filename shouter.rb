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
	attr_reader(:user, :handle)
end

class Shout < ActiveRecord::Base
end

get('/') do
   	erb(:shouter)
 end

post('/') do 
	@user = User.create(name: params[:name], handle: params[:handle], password: (0...20).map { (65 + rand(26)).chr }.join)
 	session[:userpassword] = @user.password
 	session[:userid] = @user.id
 	redirect('/showpassword')
end

get('/loginpage') do
	@user = User.last
   	if session[:userpassword] == session[:realpassword]
   		redirect('/mainpage')
	end
   	erb(:login)
 end

post('/loginpage') do 
 		session[:realpassword] = params[:realpassword]
  	redirect('/loginpage')
end

get('/showpassword') do
	@password = session[:userpassword]
   	erb(:showpassword)
   	sleep(2)
	redirect('/loginpage')
 end




# get('/mainpage') do
# 	@user = User.last
#    	if session[:user] == session[:realpassword]
# 		@loginresult = "success"
# 	else
# 		@loginresult = "wrong password"
# 	end
#    	erb(:login)
#  end

# post('/mainpage') do 
# 		session[:realpassword] = params[:realpassword]
#  	redirect('/login')
# end

