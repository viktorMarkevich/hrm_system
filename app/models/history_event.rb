class HistoryEvent < ActiveRecord::Base

  belongs_to :history_eventable, polymorphic: true
  belongs_to :user

end
