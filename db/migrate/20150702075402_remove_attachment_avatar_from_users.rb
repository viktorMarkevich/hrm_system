class RemoveAttachmentAvatarFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :avatar_file_name, :string
    remove_column :users, :avatar_content_type, :string
    remove_column :users, :avatar_file_size, :string
    remove_column :users, :avatar_updated_at, :string
  end
end
