get '/' do

  erb :index
end

get '/ep' do
  erb :enter_post
end

post '/new_post' do
  post = Post.create(title: params[:title], content: params[:content])
  params[:tags].split(',').each do |tag|
    if Tag.find_by_name(tag.strip) == nil
      tag = Tag.create(name:  tag.strip)
      PostsTag.create(post_id: post.id, tag_id: tag.id)
    else
      PostsTag.create(post_id: post.id, tag_id: Tag.find_by_name(tag.strip).id)
    end
  end
 tags = params[:tags].split(',')
 redirect '/'
end

get '/tag/*' do
  erb :post
end

get '/delete/:post' do

  post = Post.find_by_title(params[:post])
  tags = post.tags

  post.destroy
  tags.each do |tag|
    if tag.posts.empty?
      tag.delete
    end
  end

  erb :index
end