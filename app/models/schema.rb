# Schema
class Schema < ActiveRecord::Base
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true,
                                                       greater_than_or_equal_to: 0 }
  validates :x, presence: true, numericality: { only_integer: true,
                                                greater_than_or_equal_to: 0 }
  validates :y, presence: true, numericality: { only_integer: true,
                                                greater_than_or_equal_to: 0 }
  validates :constraint, presence: true, numericality: { only_integer: true,
                                                         greater_than_or_equal_to: 0 }
  has_many :seats
  default_scope { includes(:seats) }


  attr_writer :file
  attr_reader :seat_map

  before_validation :check_file
  before_create :check_file_presence
  after_find :correct_seats
  before_destroy :foreign_key_check!


  private

  def check_file
    if not @file or not @file.respond_to? :read
      return
    end

    type = case @file.content_type
    when /csv$/
      'csv'
    when /plain$/
      'csv'
    else
      'uknown'
    end

    (errors[:file] = "Does not support #{type}" && return) unless ['csv', 'pipe'].include? type

    foreign_key_check!

    parser = "::Admin::BaseHelper::" + "#{type}_parser".capitalize
    parser = parser.constantize.new(self)
    parser.parse(@file)

  end

  def check_file_presence
    unless @file && @file.respond_to?(:read)
      errors[:file] = 'please provide a file' 
      false
    end
  end

  def correct_seats
    @seat_map = Array.new(y) { Array.new(x) }
    seats.each do |seat|
      @seat_map[seat.y - 1][seat.x - 1] = seat
    end
  end

  def foreign_key_check!
    self.seats.each do |seat|
      seat.tickets.each do |ticket|
        ticket.seats.delete_all
        ticket.destroy!
      end
      seat.destroy!
    end
  end
end
