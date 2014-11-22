module Jobs
  class CheckForSpamPosts < ::Jobs::Scheduled
    every 10.minutes

    def execute(args)
      Logster.logger.info("[akismet] beginning job")
      system_user = User.find_by_username "system"
      posts = Post.where("created_at >= ?", 12.minutes.ago)
      if posts.any?
        spam_count = 0
        posts.each do |post|
          # check if the post is spam by Akismet
          # if yes, update it's state so it gets moved into the mod queue
          # trust Akismet and preemptively delete the post
          if post.has_akismet_data? && post.akismet_spam_data.new? && post.spam?
            Logster.logger.info("[akismet] found possible spam post: ID##{post.id} - #{post.raw[0...100]} ")
            spam_count += 1
            post.akismet_spam_data.mark_for_review!
            PostDestroyer.new(system_user, post).destroy
          end
        end
        if spam_count > 0 && Rails.env.production? && ENV['NOTIFY_HIPCHAT']
          post_to_hipchat(spam_count)
        end
      end
    end

    def hipchat_client
      @client ||= HipChat::Client.new(ENV['HIPCHAT_TOKEN'], :api_version => 'v2')
    end

    def post_to_hipchat(count)
      room_id = ENV['HIPCHAT_ROOM_ID']
      hipchat_client[room_id].send('Forum Bot', hipchat_message(count), :notify => true, color: ENV['HIPCHAT_MSG_COLOR'])
    end

    def hipchat_message(count)
      "<p> #{count} new posts suspected of spam <a href='/akismet/admin'>Go To Queue</a></p>"
    end

  end
end
