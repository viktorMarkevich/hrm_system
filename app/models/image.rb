class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :candidate

  has_attached_file :avatar, styles: { medium: '246x300>', thumb: '100x100>' }, default_url: 'default_:style.png'

end
