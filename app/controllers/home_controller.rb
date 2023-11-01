class HomeController < ApplicationController
  def index
    @products = Product.select("*, ((sale_price - price) / price * 100) AS price_difference").order("price_difference DESC").page params[:page]
  end
end
