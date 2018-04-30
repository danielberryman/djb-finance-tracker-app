class Stock < ActiveRecord::Base
	has_many :user_stocks
	has_many :users, through: :user_stocks


	#Here we are making a method at the class level (using .self)
	#We're creating and passing in the ticker_symbol variable 
	#In the method we are looking up the stock based on the ticker symbol
	#Then we're setting that process to a variabel 'looked_up_stock'
	#We only want to get the same attributes that are in our stock table
	#Create a new stock object (we can do this because we are within the stock model file)
	#**new() is the same as Stock.new

	def self.new_from_lookup(ticker_symbol)
		begin
			looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
			new(name: looked_up_stock.company_name, ticker: looked_up_stock.symbol, last_price: looked_up_stock.latest_price)
		rescue Exception => e
			return nil
		end
	end

end
