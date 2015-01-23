require 'rubygems'
require 'active_record'
require 'sinatra'
require "sinatra/reloader" if development?
require 'pp'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'shouter.sqlite'
)
#I18n.enforce_available_locales = false 

set :port, 3000
enable :sessions


class User < ActiveRecord::Base
	attr_reader(:user, :handle)
  # your stuff h
end

class Shout < ActiveRecord::Base
  # your stuff here
end

get('/') do
@user = User.last
session[:user] = @user.password
   	erb(:shouter)
 end

post('/') do 
	@user = User.create(name: params[:name], handle: params[:handle], password: (0...20).map { (65 + rand(26)).chr }.join)
 	#p user.errors.full_messages
 	redirect('/')
end

get('/login') do
	session[:user]
   	if session[:user] == params[:realpassword]
		@success = "success"
	end

   	erb(:login)
 end

post('/login') do 
		@password = params[:realpassword]
 	redirect('/')
end


