class CartsController < ApplicationController
    def index
        product_ids = session[:shopping_cart].keys
        @products = Product.where(id: product_ids).order(:id).page params[:page]

        @subtotal = 0
        @products.each do |p|
            product_id = p.id.to_s
  
            if p.sale_price < p.price
                price = p.sale_price
            else
                price = p.price
            end

            @subtotal += price * session[:shopping_cart][product_id]
        end

        @gst = sprintf('%.2f', @subtotal * 0.05).to_f
        @pstOrHst = sprintf('%.2f', @subtotal * Province.find(session[:user]['province_id']).PST)
        @total = @subtotal + @gst
    end

    #POST /carts
    def create
        id = params[:id].to_i
        quantity = params[:quantity].to_i

        if session[:shopping_cart].key?(id)
            session[:shopping_cart][id] += quantity
        else
            session[:shopping_cart][id] = quantity
        end
        
        product = Product.find(id)
        flash[:notice] = "*#{product.name} added to cart"
        session[:return_to] = product_path(product)
        redirect_to session[:return_to]
    end

    # DELETE /carts/:id
    def destroy
        id = params[:id]
        product = Product.find(id)
        session[:shopping_cart].delete(id)
        # flash[:notice] = "*#{product.name} removed from cart"
        redirect_to carts_path
    end
end