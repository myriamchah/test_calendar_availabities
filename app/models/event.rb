class Event < ActiveRecord::Base

   def self.availabilities(date)
    arr = [{date: date, slots: []}]
  end
end
