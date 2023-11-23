class CheckoutController < ApplicationController
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
    @total = @subtotal + @gst
  end

    def create
      if(params[:product_id].present?)
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
      else
        product_ids = session[:shopping_cart].keys
        products = Product.where(id: product_ids)
        line_items = []

        products.each do |product|
          product_id = product.id.to_s

          if product.sale_price < product.price
              price_cents = (product.sale_price * 100).to_i
          else
              price_cents = (product.price * 100).to_i
          end

          line_items << {
            price_data: {
              currency: 'cad',
              product_data: {
                name: product.name,
                description: product.description
              },
              
              unit_amount: price_cents
            },
            quantity: session[:shopping_cart][product_id].to_i
          }
        end

        line_items << {
          price_data: {
            currency: 'cad',
            product_data: {
              name: 'GST',
              description: 'Goods and Services Tax'
            },

            unit_amount: (line_items.sum { |item| item[:price_data][:unit_amount] * item[:quantity] } * 0.05).to_i
          },

          quantity: 1
        }

        @session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          mode: 'payment',
          success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
          cancel_url: checkout_cancel_url,
          line_items: line_items
        )
      end

        # Setting up a Stripe Session for payment

        # respond_to do |format|
        #     format.js # Render create.js.erb
        # end
        
        redirect_to @session.url, allow_other_host: true
    end

    def success
      @session = Stripe::Checkout::Session.retrieve(params[:session_id])
      @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
      session.delete(:shopping_cart)
    end

    def cancel

    end
end