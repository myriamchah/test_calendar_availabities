class Event < ActiveRecord::Base
  def self.availabilities(date)
    arr = [{ date: date, slots: [] }]
    i = 0
    6.times do
      i += 1
      arr << { date: date.next_day(i), slots: openings_at(date.next_day(i)) }
    end
    arr
  end

  def opening?
    kind == 'opening'
  end

  def appointment?
    kind == 'appointment'
  end

  def self.openings_at(date)
    events = Event.where("events.starts_at >= ? AND  ? <= events.ends_at", date, date).select{ |e| e.opening? }
    slots = []
    if !events.empty?
      events.each do |d|
        current_slot = d.starts_at
        until current_slot == d.ends_at
          slots << current_slot.strftime("%l:%M").strip
          current_slot += 30.minutes
        end
      end
    else
      slots << 'empty'
    end
    slots
  end
end
