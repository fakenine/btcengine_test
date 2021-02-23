class User
  attr_reader :id
  attr_accessor :btc_balance, :eur_balance

  def initialize(id:, btc_balance:, eur_balance:)
    @id = id
    @btc_balance = btc_balance
    @eur_balance = eur_balance

    validate!
  end

  def increase_btc_balance(btc_amount)
    @btc_balance += btc_amount
  end

  def decrease_btc_balance(btc_amount)
    @btc_balance -= btc_amount
  end

  def increase_eur_balance(price, btc_amount)
    @eur_balance += price * btc_amount
  end

  def decrease_eur_balance(price, btc_amount)
    @eur_balance -= price * btc_amount
  end

  private

  def validate!
    raise ArgumentError.new, 'id must be a valid ID' unless @id.is_a?(Integer)
    raise ArgumentError.new, 'btc_balance must be an Integer' unless @btc_balance.is_a?(Integer)
    raise ArgumentError.new, 'eur_balance must be an Integer' unless @eur_balance.is_a?(Integer)
  end
end
