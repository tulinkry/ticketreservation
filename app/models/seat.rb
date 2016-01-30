# Seat
class Seat < ActiveRecord::Base
  AVAILABLE = 0
  RESERVED = 1
  WALL = 2

  has_and_belongs_to_many :tickets

  belongs_to :schema
  validates :x, presence: true, numericality: { only_integer: true,
                                                greater_than_or_equal_to: 0 }
  validates :y, presence: true, numericality: { only_integer: true,
                                                greater_than_or_equal_to: 0 }
  validates :state, presence: true, inclusion: { in: [AVAILABLE, RESERVED, WALL] }
  validates :price, presence: true, numericality: { only_integer: true,
                                                    greater_than_or_equal_to: 0 }

  before_create :defaults

  def reserved?
    state == RESERVED
  end

  def wall?
    state == WALL
  end

  def available?
    state == AVAILABLE
  end

  def reserved!
    self.state = RESERVED
  end

  def wall!
    self.state = WALL
  end

  def available!
    self.state = AVAILABLE
  end

  private

  def defaults
    self.price ||= 0
  end
end
