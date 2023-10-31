class ProductsController < ApplicationController
  def index
    @products = Product.order(:id).page params[:page]
  end

  def show
    @product = Product.find(params[:id])
    @category = Category.find(@product.category_id)
  end

  def edit
  end

  def new
  end
end
