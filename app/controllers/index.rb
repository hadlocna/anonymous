enable :sessions

get '/' do
  erb :login
end

post '/login' do
  user = User.find_by_email(params[:email])
  if user != nil && user.password == params[:password]
    session[:id] = user.id
    session[:login] = false
    p session[:id]
    erb :index
  else
  session[:login] = true
  erb :login
  end
end

get '/logout' do
  session[:id] = 0
 erb :login
end


get '/create_account' do
  erb :create_account
end

get '/create_account_submit' do
  user = User.create(email: params[:email], password: params[:password])
  session[:id] = user.id
  session[:login] = false
  erb :index
end


get '/ep' do
  if session[:id] != 0
    erb :enter_post
  else
    erb :login
  end
end

post '/new_post' do
  if session[:id] != 0
  post = Post.create(title: params[:title], content: params[:content], user_id: session[:id])
  params[:tags].split(',').each do |tag|
    if Tag.find_by_name(tag.strip) == nil
      tag = Tag.create(name:  tag.strip)
      PostsTag.create(post_id: post.id, tag_id: tag.id )
    else
      PostsTag.create(post_id: post.id, tag_id: Tag.find_by_name(tag.strip).id)
    end
  end
 tags = params[:tags].split(',')
 erb :index
  else
    erb :login
  end
end

get '/tag/*' do
  if session[:id] != 0
  erb :post
  else
  erb :login
  end
end

get '/home' do
  if session[:id] != 0
  erb :index
  else
  erb :login
  end
end

get '/delete/:post' do
  if session[:id] !=
  post = Post.find_by_title(params[:post])
  tags = post.tags
  post.destroy
  tags.each do |tag|
    if tag.posts.empty?
      tag.destroy
    end
  end

  erb :index
  else
  erb :login
  end
end