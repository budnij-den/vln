require 'sinatra/base'
require "sinatra/activerecord"
#require 'sinatra/reloader'
require_relative './login_controller'
require_relative '../models/model_Line'
require_relative '../models/model_User'


class Vidi_app < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  set :database_file, "../config/database.yml" #всё, что касается сервера, требует '../'' в начале адреса
  set :public_folder, "./public"               #а все, что касается view, требует './' . И это совершенно непонятная хурма
  set :views, "./views"

  use LoginScreen

  def line_invalid?
    !!session['validate_error'] && session['validate_error'].any?
  end

  before do
    unless session['user_name']
    halt 401, {'Content-Type' => 'text/html'}, "<h2 style=\"color:grey;\">Access denied, please <a href='/login'>login</a>.</h2>"
    #halt erb :error
    end
  end

  before do
    @users = User.all
    @user = @users.find_by name: "#{session['user_name']}"
    @lines = Line.all.where(creator: @user.name)
  end

  # get '/' do
  #   redirect '/welcome'
  # end

  get '/welcome' do
    erb :header do
      erb :overlook
    end
  end

  get '/books' do
    @entity_name = 'books'
    @lines_jsoned = @lines.where(character: @entity_name.singularize).to_json
    erb :header do
      erb :items do
        erb :list
      end
    end
  end

  get '/movies' do
    @entity_name = 'movies'
    @lines_jsoned = @lines.where(character: @entity_name.singularize).to_json
    erb :header do
      erb :items do
        erb :list
      end
    end
  end

  post '/adding' do
    @entity_name = params[:entity_name]

    whole_name = params[:whole_name].gsub(/'|"/) { |match| "`" }.split ('.')    #парсим смысловые блоки по точкам
    author = whole_name[0]                          #на этом поле валидация (только), предусмотреть div/popup/alert с предупреждением
    title = whole_name[1]
    year = whole_name[2]
    comment = params[:comment].gsub(/'|"/) { |match| "`" } if params[:comment]
    tags = params[:tags].gsub(/'|"/) { |match| "`" }
    spent_bul = !params[:spent].nil?                #вычисляем булин просмотренности

    @line = Line.create do |l|                         #это быстрее, чем подменять пары в params
      l.author = author
      l.title = title
      l.year = year
      l.comment = comment
      l.character = @entity_name.singularize
      l.tags = tags
      l.spent_bul = spent_bul
      l.creator = @user.name
    end

    session['validate_error'] = @line.errors.full_messages
    redirect "#{@entity_name.pluralize}"
  end

  #заглушка на случай тыков в адресную строку
  get '/adding' do
    redirect back
  end

  get '/list/:id/edit' do
    id = params[:id]
    @line_for_edit = @lines.find(id)
    @entity_name = @line_for_edit.character.pluralize
    erb :header do
      erb :edit
    end
  end

  post '/edit_success/:id' do
    id = params[:id]                          #идентификатор для записи для редактирования
    @line_for_edit = @lines.find(id)          #заносим в переменную запись для редактирования
    spent_bul = !params[:edited][:spent].nil? #вычисляем булин, просмотрен фильм или нет
    params[:edited][:spent_bul] = spent_bul   #заносим результат в парамс
    params[:edited].delete(:spent)            #удалим пришедшее значение чекбокса перед занесением в БД
    @line_for_edit.update params[:edited]     #update
    redirect to "/#{@line_for_edit.character.pluralize}"
  end

  get '/:id/remove' do
    id = params[:id]
    @line_for_remove = @lines.find(id)
    entity_name = @line_for_remove.character #иначе к моменту редиректа инф-я о сущности будет уничтожена вместе с объектом
    @line_for_remove.destroy
    redirect to "/#{entity_name.pluralize}"
   end

   get '/overlook' do
     erb :header do
      erb :overlook do
#        erb :list
      end
    end
   end

  get '/logout' do
    session.clear
    redirect '/login'
  end

  post '/change' do
    @user.update(name: params['new_user_name'], password: params['new_password'])
    if @user.errors.empty? && session['user_name'] != @user.name
      session['user_name'] = @user.name
      @lines.update(creator: @user.name)
    else
      session['validate_error'] = @user.errors.full_messages
    end
    redirect '/change'
  end

    #заглушка на случай тыков в адресную строку
  get '/change' do
     erb :header do
      erb :overlook do
#        erb :list
      end
    end
  end

  not_found do
    erb "<h2 style=\"color:grey;text-align:center;position:absolute;top:4em;left:0;right:0;font-weight:600;\">There is no such address on this site <br><br> <a href=\"/welcome\" class=\"btn btn-warning btn-lg\">Go to entrance page </a></h2>"
  end

end
