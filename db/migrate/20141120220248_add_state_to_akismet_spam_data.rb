class AddStateToAkismetSpamData < ActiveRecord::Migration
  def up
    add_column(:akismet_spam_data, :state, :string)
  end

  def down
    remove_column(:akismet_spam_data, :state)
  end
end
