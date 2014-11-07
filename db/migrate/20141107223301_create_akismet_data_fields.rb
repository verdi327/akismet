class CreateAkismetDataFields < ActiveRecord::Migration
  def change
    create_table :akismet_data_fields do |t|
      t.integer :post_id, null: false
      t.string  :ip_address, null: false
      t.string  :user_agent, null: false
      t.string  :referrer, null: false

      t.timestamps
    end

    add_index :akismet_data_fields, [:post_id], unique: true
  end
end
