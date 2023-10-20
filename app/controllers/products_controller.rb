class ProductsController < ApplicationController
  def index
    @products = Product.order(:id).page params[:page]
  end

  def show
  end

  def edit
  end

  def new
  end
end
