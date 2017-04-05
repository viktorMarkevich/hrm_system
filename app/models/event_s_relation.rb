class EventSRelation < ApplicationRecord
  belongs_to :event
  belongs_to :staff_relation
end
