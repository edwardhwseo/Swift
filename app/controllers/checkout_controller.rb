class CheckoutController < ApplicationController
    def create
        product = Product.find(params[:product_id])

        if product.nil?
          redirect_to root_path
          return
        end
        
        if product.sale_price < product.price
            price_cents = (product.sale_price * 100).to_i
        else
            price_cents = (product.price * 100).to_i
        end

        @session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          mode: 'payment',
          success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
          cancel_url: checkout_cancel_url,
          line_items: [
            {
              price_data: {
                currency: 'cad',
                product_data: {
                  name: product.name,
                  description: product.description
                },
                unit_amount: price_cents
              },
              quantity: 1
            },
            {
              price_data: {
                currency: 'cad',
                product_data: {
                  name: 'GST',
                  description: 'Goods and Services Tax'
                },
                unit_amount: (price_cents * 0.05).to_i
              },
              quantity: 1
            }
          ]
        )

        # Setting up a Stripe Session for payment

        # respond_to do |format|
        #     format.js # Render create.js.erb
        # end
        
        redirect_to @session.url, allow_other_host: true
    end

    def success

    end

    def cancel

    end
end