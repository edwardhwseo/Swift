class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.order(:id).page params[:page]
  end

  # def deal
  #   @deals = Product.where(:discounted_price < :retail_price)
  # end
end
