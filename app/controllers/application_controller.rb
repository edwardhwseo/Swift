class ApplicationController < ActionController::Base
    before_action :categories

    def categories
        category_names = ['Clothing', 'Furniture', 'Home & Kitchen', 'Computers', 'Beauty and Personal Care', 'Sports & Fitness']
        @categories = Category.where(name: category_names)
    end
end
