class ApplicationController < ActionController::Base
    before_action :categories
    before_action :initialize_session
    helper_method :cart

    def categories
        category_names = ['Clothing', 'Furniture', 'Home & Kitchen', 'Computers', 'Beauty and Personal Care', 'Sports & Fitness']
        @categories = Category.where(name: category_names)
    end

    def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate_password(params[:password])
            session[:user] = user
            redirect_to root_path
        end
    end

    def update
        user = User.find_by(email: params[:email])
        if user
            if user.update(user_params)
                redirect_to root_path
            end
        end
    end

    def logout
        session[:user] = nil
        session.delete(:shopping_cart)
        redirect_to root_path
    end

    def register
        user = User.new(user_params)
        if user.save
            redirect_to root_path
        end
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

    def user_params
        params.permit(:email, :password, :first_name, :last_name, :address, :province_id)
    end
end