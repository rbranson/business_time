# Add workday and weekday concepts to the Date class
class Date
  SUNDAY    = 0
  MONDAY    = 1
  TUESDAY   = 2
  WEDNESDAY = 3
  THURSDAY  = 4
  FRIDAY    = 5
  SATURDAY  = 6
  
  WEEKDAYS  = [ MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY ]
  
  def workday?
    self.weekday? && !self.actual_holiday? && !self.make_up_day?
  end
  
  def weekday?
    WEEKDAYS.include? self.wday
  end
  
  def business_days_until(to_date)
    (self...to_date).select{ |day| day.workday? }.size
  end
  
  def actual_holiday?
    BusinessTime::Config.holidays.include?(self)
  end
  
  def make_up_day?
    BusinessTime::Config.make_up_for_weekend_holidays && (
      (self.wday == MONDAY && (self - 1).actual_holiday?) ||  # sunday was an actual holiday
      (self.wday == FRIDAY && (self + 1).actual_holiday?)     # saturday was an actual holiday
    )
  end
  
end
