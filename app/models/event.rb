class Event < ActiveRecord::Base
  def self.availabilities(date)
    arr = [{ date: date, slots: [] }]
    i = 0
    6.times do
      i += 1
      arr << { date: date.next_day(i), slots: openings_at(date.next_day(i)) - appointments_at(date.next_day(i))}
    end
    arr
  end

  def opening?
    kind == 'opening'
  end

  def appointment?
    kind == 'appointment'
  end

#I assume that all starts_at and ends_at occur on the same day
  def self.openings_at(date)
    recurring = Event.where(weekly_recurring: true).select { |d| d.opening? && (d.starts_at.wday == date.wday) }
    one_shot = Event.where("events.starts_at >= ? AND  ? <= events.ends_at", date, date).select { |e| e.opening? }
    total = recurring + one_shot
    slots = []
    if !total.empty?
      total.uniq.each do |d|
        current_slot = d.starts_at
        until current_slot == d.ends_at
          slots << current_slot.strftime('%l:%M').strip
          current_slot += 30.minutes
        end
      end
    else
      slots << 'No availabilities found'
    end
    slots
  end

#I assume that all starts_at and ends_at occur on the same day
  def self.appointments_at(date)
    recurring = Event.where(weekly_recurring: true).select{|d| d.appointment? && (d.starts_at.wday == date.wday)}
    one_shot = Event.where("events.starts_at >= ? AND  ? <= events.ends_at", date, date).select{|s| s.appointment?}
    total = recurring + one_shot
    slots = []
    if !total.empty?
      total.uniq.each do |d|
        current_slot = d.starts_at
        until current_slot == d.ends_at
          slots << current_slot.strftime('%l:%M').strip
          current_slot = current_slot + 30.minutes
        end
      end
    else
      slots << 'No appointments found'
    end
    slots
  end
end
