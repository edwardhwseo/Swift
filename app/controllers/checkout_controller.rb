class CheckoutController < ApplicationController
  def index
    product_ids = session[:shopping_cart].keys
    @products = Product.where(id: product_ids).order(:id).page params[:page]

    @subtotal = 0
    @products.each do |p|
        product_id = p.id.to_s

        if p.sale_price < p.price
            price = p.sale_price / 10
        else
            price = p.price / 10
        end

        @subtotal += price * session[:shopping_cart][product_id]
    end

    @gst = sprintf('%.2f', @subtotal * 0.05).to_f
    @pstOrHst = sprintf('%.2f', @subtotal * Province.find(session[:user]['province_id']).PST).to_f
    @taxes = sprintf('%.2f', @gst + @pstOrHst).to_f
    @total = @subtotal + @taxes

    session[:taxes] = @taxes
  end

    def create
      if(params[:product_id].present?)
        product = Product.find(params[:product_id])

        if product.nil?
          redirect_to root_path
          return
        end
  
        if product.sale_price < product.price
            price_cents = (product.sale_price * 10).to_i
        else
            price_cents = (product.price * 10).to_i
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
        session[:address] = params[:address]
        product_ids = session[:shopping_cart].keys
        products = Product.where(id: product_ids)
        line_items = []

        products.each do |product|
          product_id = product.id.to_s

          if product.sale_price < product.price
              price_cents = (product.sale_price * 10).to_i
          else
              price_cents = (product.price * 10).to_i
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

        pst = Province.find(session[:user]['province_id']).PST

        line_items << {
          price_data: {
            currency: 'cad',
            product_data: {
              name: 'PST/HST',
              description: 'Provincial/Harmonized Sales Tax'
            },

            unit_amount: (line_items.sum { |item| item[:price_data][:unit_amount] * item[:quantity] } * pst).to_i
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

      amount_total = @session.amount_total / 100

      @order = Order.create(user_id: session[:user]['id'], tax: session[:taxes], total: amount_total)

      session[:shopping_cart].each do |product|
        OrderItem.find_or_create_by(order_id: @order.id, product_id: product[0], quantity: product[1])
      end

      user = User.find(session[:user]['id'])
      user.address = session[:address]
      user.save

      session.delete(:shopping_cart)
    end

    def cancel

    end
end