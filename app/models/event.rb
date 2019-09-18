class Event < ActiveRecord::Base

  before_create :duration_valid?

  validates :kind, :starts_at, :ends_at, presence: true
  validates :kind, inclusion: { in: %w(opening appointment) }

  def self.availabilities(date)
    arr = [{ date: date, slots: compute_slots_at(date) }]
    i = 0
    6.times do
      i += 1
      arr << { date: date.next_day(i), slots: compute_slots_at(date.next_day(i)) }
    end
    arr
  end

  def self.compute_slots_at(date)
    slots = list(sort_kinds('opening', date)) - list(sort_kinds('appointment', date))
  end

  def self.list(slots)
    listed_slots = []

    slots.each do |slot|
        current_slot = slot.starts_at
        until current_slot == slot.ends_at
          listed_slots << current_slot.strftime('%k:%M').strip
          current_slot += 30.minutes
        end
      end
    listed_slots
  end

  def self.sort_kinds(kind, date)
    Event.where("(starts_at >= ? OR weekly_recurring = ?) AND kind = '#{kind}' ", date, true).select { |e| e.starts_at.wday == date.wday }
  end

  private

  def duration_valid?
    if ends_at < starts_at
      temp = ends_at
      self[:ends_at] = starts_at
      self[:starts_at] = temp
    end
    true
  end
end
