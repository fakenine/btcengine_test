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
      matched_order = find_match(order, @queued_orders)

      if matched_order
        @queued_orders = @queued_orders - [order, matched_order]
        change_statuses(order, matched_order)
        update_balances(order, matched_order)
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

  def change_statuses(order, matched_order)
    order.executed!
    matched_order.executed!
  end

  def update_balances(order, matched_order)
    order_user = @users.find { |user| user.id == order.user_id }
    matched_order_user = @users.find { |user| user.id == matched_order.user_id }

    process_btc_balance(order_user, order.direction, order.btc_amount)
    process_btc_balance(matched_order_user, matched_order.direction, matched_order.btc_amount)

    process_eur_balance(order_user, order.direction, order.btc_amount, order.price)
    process_eur_balance(matched_order_user, matched_order.direction, matched_order.btc_amount, matched_order.price)
  end

  def process_btc_balance(user, direction, btc_amount)
    direction == 'sell' ? user.decrease_btc_balance(btc_amount) : user.increase_btc_balance(btc_amount)
  end

  def process_eur_balance(user, direction, btc_amount, price)
    direction == 'sell' ? user.decrease_eur_balance(price, btc_amount) : user.increase_eur_balance(price, btc_amount)
  end
end
