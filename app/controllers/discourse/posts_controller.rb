::PostsController

class ::PostsController
  before_filter :record_request_params, only: :create
  after_filter :create_akismet_spam_data_entry, only: :create


  def record_request_params
    @ip_address   = request.remote_ip
    @user_agent   = request.user_agent
    @referrer     = request.env["HTTP_REFERER"]
    @post_content = params[:raw][0...20]
  end

  def create_akismet_spam_data_entry
    post = Post.last
    return if post.nil?
    unless post.raw[0...20] != @post_content
      Akismet::AkismetSpamData.create(ip_address: @ip_address,
                                      user_agent: @user_agent,
                                      referrer:   @referrer,
                                      post_id:    post.id,
                                      state:      "new")
    end

  end
end