class History < ActiveRecord::Base
  # store_accessor :was_changed, Array

  belongs_to :historyable, polymorphic: true

  def self.create_with_attrs(args)
    create(args)
  end
end
