class ApplicationController < ActionController::Base
    before_action :categories
    before_action :initialize_session
    helper_method :cart

    def categories
        category_names = ['Clothing', 'Furniture', 'Home & Kitchen', 'Computers', 'Beauty and Personal Care', 'Sports & Fitness']
        @categories = Category.where(name: category_names)
    end

    private

    def initialize_session
        session[:shopping_cart] ||= {}
    end

    def cart
        if session[:shopping_cart].is_a?(Hash)
            product_ids = session[:shopping_cart].keys
            Product.where(id: product_ids)
        else
            []
        end
    end
end