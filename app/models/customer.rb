class Customer < ActiveRecord::Base
  after_create :create_order
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :ratings
  has_many :orders
  has_many :credit_cards
  validates :password, length: { in: 8..15 }

  def current_order
    orders.find_by status: "shopping_cart"
  end

  private

  def create_order
    Order.create(customer_id: self.id, status: "shopping_cart", state: 'in_progress')
  end
end