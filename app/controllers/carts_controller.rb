class CartsController < ApplicationController
    #POST /carts
    def create
        # log product id to the terminal logger
        #logger.debug("Adding #{params[:id]} to cart")
        id = params[:id].to_i
        session[:shopping_cart] << id unless session[:shopping_cart].include?(id) # Pushes id onto the end of array
        product = Product.find(id)
        flash[:notice] = "*#{product.name} added to cart"
        session[:return_to] = product_path(product)
        redirect_to session[:return_to]
    end

    # DELETE /carts/:id
    def destroy
        #logger.debug("removing #{params[:id]} from cart.")
        id = params[:id].to_i
        session[:shopping_cart].delete(id)
        product = Product.find(id)
        flash[:notice] = "*#{product.name} removed from cart"
        session[:return] = product_path(product)
        redirect_to session[:return]
    end
end