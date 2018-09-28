require 'sinatra'
require_relative 'models'

set :sessions, true
use Rack::MethodOverride

# this will ensure this will only be used locally
# configure :development do
#   set :database, "postgresql:[name of database]"
# end

# # this will ensure this will only be used on production
# configure :production do
#   # this environment variable is auto generated/set by heroku
#   #   check Settings > Reveal Config Vars on your heroku app admin panel
#   set :database, ENV["DATABASE_URL"]
# end

# sets current user to current session
def current_user
  if session[:user_id]
    return User.find(session[:user_id])
  end
end

# establishes index page route
get '/' do
  if session[:user_id]
    erb :user_profile, locals: { current_user: current_user }
  else
    erb :index
  end
end

# establishes signup page route
get '/signup' do
  erb :signup
end

# establishes sign up page post route
post '/signup' do
  # creates new user
  user = User.create(
    username: params[:username],
    password: params[:password]
  )

  # logs user in
  session[:user_id] = user.id

  # redirects to content page
  redirect '/complete-profile'
end

# establishes complete profile route
get '/complete-profile' do
  erb :complete_profile
end

# establishes complete profile post route and create user in database
post '/complete-profile' do
  Profile.create(
    first_name: params[:first_name],
    last_name: params[:last_name],
    gender: params[:gender],
    birthday: params[:birthday],
    email: params[:email],
    phone: params[:phone],
    user_id: current_user.id
  )

  redirect '/user-profile'
end

# establishes sign in route
get '/signin' do
  erb :signin
end

# establishes sign in post route and checks if info matches database record
post '/signin' do
  user = User.find_by(username: params[:username])

  if user && user.password == params[:password]
    session[:user_id] = user.id

    redirect '/user-profile'
  else
    redirect '/signin'
  end
end

# establishes user profile route
get '/user-profile' do
  erb :user_profile
end

# establishes sign out route
get '/signout' do
  session[:user_id] = nil

  redirect '/'
end

# establishes new post route
get '/posts/new' do
  erb :new_post
end

# establishes posts route
get '/posts' do
  output = ''
  # output += erb :new_post
  output += erb :posts, locals: { posts: Post.order(:created_at).last(20) }
  output
end

# establishes posts post route and adds new post to database
post '/posts' do
  Post.create(
    title: params[:title],
    content: params[:content],
    user_id: current_user.id
  )

  redirect '/posts'
end

# establishes user delete route and removes user's record, profile and posts from the database
post '/delete' do
  # current_user
  current_user.destroy
  session[:user_id] = nil

  redirect '/'
end

# establishes all users route
get '/users' do
  @users = User.all
  erb :users
end

# establishes current users posts route
get '/my-posts' do
    erb :my_posts
end