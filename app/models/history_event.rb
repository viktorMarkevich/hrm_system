class HistoryEvent < ActiveRecord::Base
belongs_to :history_evetable, polymorphic: true

end
