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

def current_user
  if session[:user_id]
    return User.find(session[:user_id])
  end
end

get '/' do
  if session[:user_id]
    erb :user_profile, locals: { current_user: current_user }
  else
    erb :index
  end
end

get '/signup' do
  erb :signup
end

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

get '/complete-profile' do
  erb :complete_profile
end

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

get '/signin' do
  erb :signin
end

post '/signin' do
  user = User.find_by(username: params[:username])

  if user && user.password == params[:password]
    session[:user_id] = user.id
    # flash[:info] = 'You have been signed in'

    redirect '/user-profile'
  else
    # flash[:error] = 'There was a problem with your signin, sucka!'
    redirect '/signin'
  end
end

get '/user-profile' do
  erb :user_profile
  # erb :posts
end

# post '/signin' do
#   user = User.find_by(username: params[:username])

#   if user && user.password == params[:password]
#     session[:user_id] = user.id
#     flash[:info] = 'You have been signed in'

#     redirect '/users'
#   else
#     flash[:error] = 'There was a problem with your signin, sucka!'
#     redirect '/signup'
#   end
# end

get '/signout' do
  session[:user_id] = nil

  redirect '/'
end

get '/posts/new' do
  erb :new_post
end

get '/posts' do
  output = ''
  # output += erb :new_post
  output += erb :posts, locals: { posts: Post.order(:created_at).last(20) }
  output
end

post '/posts' do
  Post.create(
    title: params[:title],
    content: params[:content],
    user_id: current_user.id
  )

  redirect '/posts'
end

# get '/content' do
#   erb :content, locals: { users: User.all }
# end

post '/delete' do
  # current_user
  current_user.destroy
  session[:user_id] = nil

  redirect '/'
end

get '/users' do
  erb :users, locals: { users: User.all }
end

get '/my-posts' do
  # if current.user.post.nil?
  #   redirect '/posts/new'
  # else
    erb :my_posts
  # end
end