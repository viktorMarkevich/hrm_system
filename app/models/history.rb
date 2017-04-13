class History < ActiveRecord::Base

  store_accessor :responsible

  def self.create_with_attrs(args)
    create(args)
  end
end
