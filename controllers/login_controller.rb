require 'sinatra/base'
require_relative 'application_controller'

class LoginScreen < Sinatra::Base
  set :views, "./views"
  set :public_folder, "./public"

  use Rack::Session::Pool, :expire_after => 2592000
  use Rack::Protection::RemoteToken
  use Rack::Protection::SessionHijacking

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
      session.delete('validate_error')
      erb :login
    end
  end

  post('/login') do
    @user = @users.find_by name: "#{params['name']}"                            #проверка наличия имени в бд
    if @user                                                                    #имя есть, идём в проверку соответствия с паролем
      if @user.password == params['password']                                   #пароль соответствует, пишем имя в сессию
        session['user_name'] = @user.name
        redirect '/welcome'
      else                                                                      #пароль не соответствует, предупреждение и ссылка назад
        session['validate_error'] = ['wrong password']
        erb :login
      end
    else                                                                        #юзер не найден в бд по имени, тогда
      @user = User.create(name: params['name'], password: params['password'])   #запускаем создание нового юзера
      if @user.errors.full_messages.any?                                        #отображаем проваленную валидацию
        session['validate_error'] = @user.errors.full_messages
        erb :login
      else
        session['user_name'] = @user.name
        redirect '/welcome'
      end
    end
  end

  not_found do
    redirect '/login'
  end

end
