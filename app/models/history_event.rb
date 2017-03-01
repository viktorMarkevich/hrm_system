class HistoryEvent < ActiveRecord::Base
  serialize :body
end
