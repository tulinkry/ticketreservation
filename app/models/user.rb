# User
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tickets
  belongs_to :role

  validates :email, :encrypted_password, presence: true

  before_create :set_default_role
  after_create :send_email

  def admin?
    role.name == 'admin'
  end

  def user?
    role.name == 'user'
  end

  def granted?(role_name)
    role.name == role_name
  end

  def seats
    Seat.joins(:tickets).where('tickets.user_id = ?', id)
  end

  def orders
    User.select(['`schemas`.*',
                 'COUNT(`schemas`.id) as total',
                 'SUM(seats.price) as price',
                 'tickets.id as ticket_id'])
      .joins(tickets: { seats: :schema })
      .where('users.id = ?', id)
      .group(:schema)
  end

  private

  def send_email
    UserMailer.welcome_email(self).deliver
  end

  def set_default_role
    self.role ||= Role.find_by_name('user')
  end
end
