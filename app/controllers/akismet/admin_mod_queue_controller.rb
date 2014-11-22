module Akismet
  class AdminModQueueController < Admin::AdminController 
    def index
      post_ids = AkismetSpamData.needs_review.map(&:post_id)
      posts = Post.with_deleted.where(id: post_ids)
      render json: posts.map(&:serialized_data).to_json
    end

    def confirm_spam
      post = Post.with_deleted.find(params[:post_id])
      post.akismet_spam_data.mark_as_spam!
      render json: {msg: "Post successfully confirmed as spam"}.to_json
    end

    def allow
      post = Post.with_deleted.find(params[:post_id])
      PostDestroyer.new(current_user, post).recover
      post.akismet_spam_data.mark_as_ham!
      post.ham!
      render json: {msg: "Thanks for making Akismet smarter. Post marked as NOT spam and has been undeleted"}.to_json
    end

    def delete_user
      post = Post.with_deleted.find(params[:post_id])
      post.akismet_spam_data.mark_as_spam!
      user = User.find(params[:user_id])
      UserDestroyer.new(current_user).destroy(user, user_deletion_opts)
      render json: {msg: "Poof! All traces of #{user.username} have been removed"}.to_json
    end

    private

    def user_deletion_opts
      base = {
        context:           "determined by #{current_user} to be a spammer",
        delete_posts:      true,
        delete_as_spammer: true
      }

      if Rails.env.production?
        base.merge({block_urls: true, block_email: true, block_ip: true})
      end
    end
  end
end