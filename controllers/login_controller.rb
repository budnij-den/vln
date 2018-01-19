require 'sinatra/base'
require_relative 'application_controller'

class LoginScreen < Sinatra::Base
  set :views, "./views"
  set :public_folder, "./public"
  enable :sessions
  enable :static

  before do
    @users=User.all
  end

  get '/' do
    redirect '/login'
  end

  get '/login' do
    if session['user_name']
      redirect '/welcome'
    else
      erb :login
    end
  end

  post('/login') do
    @user = @users.find_by name: "#{params['name']}"
    if @user
      if @user.name == params['name'] && @user.password == params['password']
        session['user_name'] = @user.name
        redirect '/welcome'
      else
        erb :layout do
          "<h2 style=\"color:grey;\">wrong or blank enter</h2><br><a href=\"/login\">back</a>"
        end
      end
    else
      erb :layout do
        "<h2 style=\"color:grey;\">wrong or blank enter</h2><br><a href=\"/login\">back</a>"
      end
    end
  end

  not_found do
    redirect '/login'
  end

end

# class MyApp < Sinatra::Base
#   set :views, "./views"
#   # middleware will run before filters
#   use LoginScreen

#   before do
#     unless session['user_name']
#       halt erb :layout do
#         "<h2 style=\"color:grey;\">Access denied, please <a href='/'>login</a>.</h2>"
#       end
#     end
#   end

#   not_found do
#     redirect '/greeting'
#   end

#   get('/greeting') do
#     erb :layout do
#       "<h2 style=\"color:grey;\">Hello #{session['user_name']}.</h2> <br><blockquote class=\"blockquote\"> #{session.inspect}</blockquote>"
#     end
#   end
# end


