require 'helper'

class TestTimeExtensions < Test::Unit::TestCase
  
  should "know what a weekend day is" do
    assert( Time.weekday?(Time.parse("April 9, 2010 10:30am")))
    assert(!Time.weekday?(Time.parse("April 10, 2010 10:30am")))
    assert(!Time.weekday?(Time.parse("April 11, 2010 10:30am")))
    assert( Time.weekday?(Time.parse("April 12, 2010 10:30am")))
  end
  
  should "know a weekend day is not a workday" do
    assert( Time.workday?(Time.parse("April 9, 2010 10:45 am")))
    assert(!Time.workday?(Time.parse("April 10, 2010 10:45 am")))
    assert(!Time.workday?(Time.parse("April 11, 2010 10:45 am")))
    assert( Time.workday?(Time.parse("April 12, 2010 10:45 am")))
  end
  
  should "know a holiday is not a workday" do
    BusinessTime::Config.reset
    
    BusinessTime::Config.holidays << Date.parse("July 4, 2010")
    BusinessTime::Config.holidays << Date.parse("July 5, 2010")
    
    assert(!Time.workday?(Time.parse("July 4th, 2010 1:15 pm")))
    assert(!Time.workday?(Time.parse("July 5th, 2010 2:37 pm")))
  end
  
  context "with make_up_for_weekend_holidays set" do
    
    setup do
      BusinessTime::Config.reset
      BusinessTime::Config.make_up_for_weekend_holidays = true
    end
    
    should "know the friday before a saturday holiday is not a workday" do
      friday_afternoon_before_christmas = Time.parse("December 24th, 2010 1:15 pm")
      assert Time.workday?(friday_afternoon_before_christmas)
      BusinessTime::Config.holidays << Date.parse("December 25th, 2010") # a saturday
      assert !Time.workday?(friday_afternoon_before_christmas)
    end
    
    should "know the monday after a sunday holiday is not a workday" do
      monday_afternoon_after_christmas = Time.parse("December 26th, 2011 1:15 pm")
      assert Time.workday?(monday_afternoon_after_christmas)
      BusinessTime::Config.holidays << Date.parse("December 25th, 2011") # a sunday
      assert !Time.workday?(monday_afternoon_after_christmas)
    end
  end
  
  should "know the beginning of the day for an instance" do
    first = Time.parse("August 17th, 2010, 11:50 am")
    expecting = Time.parse("August 17th, 2010, 9:00 am")
    assert_equal expecting, Time.beginning_of_workday(first)
  end
  
  should "know the end of the day for an instance" do
    first = Time.parse("August 17th, 2010, 11:50 am")
    expecting = Time.parse("August 17th, 2010, 5:00 pm")
    assert_equal expecting, Time.end_of_workday(first)
  end
  
end
