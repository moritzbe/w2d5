require 'rubygems'
require 'active_record'
require 'sinatra'
require "sinatra/reloader" if development?
require 'pp'
require "pry"

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'shouter.sqlite'
)
I18n.enforce_available_locales = false 

set :port, 3000



class User < ActiveRecord::Base
	# attr_reader(:name, :handle)
	def shouter
		return "shout"
	end
  # your stuff h
end

class Shout < ActiveRecord::Base
  # your stuff here
end


# get('/') do
#   	@user = User.all
#   	erb(:shouter)
# end