class HomeController < ApplicationController
  def index
    @products = Product.select("*, ((price - sale_price) / price * 100) AS price_difference").order("price_difference DESC").page params[:page]
    @products = @products.per(10) if request.path == root_path
  end
end
