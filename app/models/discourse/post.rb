class ::Post
  include Rakismet::Model

  rakismet_attrs author:       proc {user.name},
                 author_email: "",
                 comment_type: "forum-post",
                 content:      :raw,
                 permalink:    proc { Discourse.base_url + url},
                 user_ip:      proc {akismet_spam_data.ip_address},
                 user_agent:   proc {akismet_spam_data.user_agent},
                 referrer:     proc {akismet_spam_data.referrer}

  def akismet_spam_data
    @akismet_spam_data ||= Akismet::AkismetSpamData.where(post_id: self.id).first
  end

  def has_akismet_data?
    akismet_spam_data.present?
  end

  def serialized_data
    {
      id:          id,
      raw:         raw,
      url:         Discourse.base_url + url,
      topic_title: topic.title,
      user_url:    Discourse.base_url + "/admin/users/#{user.username}",
      username:    user.username,
      user_id:     user.id
    }
  end
  
end