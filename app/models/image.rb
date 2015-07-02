class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :candidate

  has_attached_file :avatar, styles: { medium: '246x300>', thumb: '100x100>' }, default_url: 'missing_:style.png'
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

end
