class ProductsController < ApplicationController
  def index
    @products = Product.all.limit(20)
  end

  def show
  end

  def edit
  end

  def new
  end
end
