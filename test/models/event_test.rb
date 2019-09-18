require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "one simple test example" do
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "Should return availabilities for the whole week" do
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-10 09:30"), ends_at: DateTime.parse("2014-08-10 12:30")
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-12 09:30"), ends_at: DateTime.parse("2014-08-12 12:30")
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-13 09:30"), ends_at: DateTime.parse("2014-08-13 12:30")
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-14 09:30"), ends_at: DateTime.parse("2014-08-14 12:30")
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-15 09:30"), ends_at: DateTime.parse("2014-08-15 12:30")
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-16 09:30"), ends_at: DateTime.parse("2014-08-16 12:30")

    expected_result = [
      { date: Date.new(2014, 8, 10), slots: ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00"] },
      { date: Date.new(2014, 8, 11), slots: ["9:30", "10:00", "11:30", "12:00"] },
      { date: Date.new(2014, 8, 12), slots: ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00"] },
      { date: Date.new(2014, 8, 13), slots: ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00"] },
      { date: Date.new(2014, 8, 14), slots: ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00"] },
      { date: Date.new(2014, 8, 15), slots: ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00"] },
      { date: Date.new(2014, 8, 16), slots: ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00"] },
    ]

    assert_equal expected_result, Event.availabilities(DateTime.parse("2014-08-10"))
  end

  test "Should validate kind of an event" do
    event = Event.create kind: 'none', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true

    assert_equal false, event.valid?
  end

  test "Should validate starts_at <= ends_at or switch them before creation of an event" do
    event = Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-10 12:30"), ends_at: DateTime.parse("2014-08-10 09:30")
    assert_equal DateTime.parse("2014-08-10 09:30"), event.starts_at
    assert_equal DateTime.parse("2014-08-10 12:30"), event.ends_at

    event = Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-10 09:30"), ends_at: DateTime.parse("2014-08-10 12:30")
    assert_equal DateTime.parse("2014-08-10 09:30"), event.starts_at
    assert_equal DateTime.parse("2014-08-10 12:30"), event.ends_at
  end

    test "Should handle overlapping openings" do
    event = Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 10:30"), ends_at: DateTime.parse("2014-08-04 16:30"), weekly_recurring: true
    event = Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-11 09:30"), ends_at: DateTime.parse("2014-08-11 12:30")

    availabilities = Event.availabilities DateTime.parse("2014-08-11")
    assert_equal ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00"], availabilities[0][:slots]
    assert_equal 7, availabilities.length
  end
end
