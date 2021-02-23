class Order
  attr_reader :id, :user_id, :direction, :btc_amount, :price
  attr_accessor :state

  def initialize(id:, user_id:, direction:, price:)
    @id = id
    @user_id = user_id
    @direction = direction
    @btc_amount = 1
    @price = price
    @state = 'queued'

    validate!
  end

  private

  def validate!
    raise ArgumentError.new, 'id must be a valid ID' unless positive_integer?(@id)
    raise ArgumentError.new, 'user_id must be a valid ID' unless positive_integer?(@user_id)
    raise ArgumentError.new, 'direction must either be "buy" or "sell"' unless %w[buy sell].include?(@direction)
    raise ArgumentError.new, 'price must be an Integer' unless positive_integer?(@price)
  end

  def positive_integer?(data)
    data.is_a?(Integer) && data.positive?
  end
end
