require './user'
require './order'

class BtcEngine
  attr_reader :users
  attr_accessor :queued_orders, :orders

  def initialize(data)
    @users = data['users'].map do |user|
      User.new(id: user['id'], btc_balance: user['btc_balance'], eur_balance: user['eur_balance'])
    end

    @queued_orders = data['queued_orders'].map do |order|
      Order.new(id: order['id'], user_id: order['user_id'], direction: order['direction'], price: order['price'])
    end

    @orders = []
  end

  def process!
    @queued_orders.each do |order|
      if find_match(order, @queued_orders)
        puts "YES"
      end
    end
  end

  private

  def find_match(order, orders_to_match)
    orders_to_match.find { |order_to_match| matches?(order, order_to_match) }
  end

  def matches?(order, order_to_match)
    order_to_match.id != order.id &&
      order_to_match.user_id != order.id &&
      order_to_match.direction != order.direction &&
      order_to_match.price == order.price
  end
end
