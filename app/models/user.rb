class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  def stock_already_added?(ticker_symbol)
  	stock = Stock.find_by_ticker(ticker_symbol)
  	#don't need to look this up from the web because the user would've had to have tracked this stock already
  	return false unless stock
  	#if there's no ticker then return false because there's no stock
  	user_stocks.where(stock_id: stock.id).exists?
  	#if there is a stock then look up the stock by id and see if it exists

  end

  def under_stock_limit?
  	(user_stocks.count < 10)
  end 

  def can_add_stock?(ticker_symbol)
  	under_stock_limit? && !stock_already_added?(ticker_symbol)
  end

  def full_name
  	return "#{first_name} #{last_name}".strip if (first_name || last_name)
  	"Anonymous"
  end

end
