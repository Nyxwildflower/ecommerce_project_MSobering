class OrdersController < ApplicationController
  before_action :authenticate_customer!

  # This does absolutely nothing with the payment info.
  # There is no payment processing, just order creation.
  def create_order
    # Find customer
    customer = Customer.find(current_customer[:id])
    session[:order_message]

    pst = customer.province.pst
    gst = customer.province.gst
    hst = customer.province.hst

    total_price = 0

    # Create order through the customer using the minimum price that'll pass
    # validations. It will be changed when all the products have been summed.
    order = customer.orders.create!(total_price: 0.01)

    # Create order_items using product on cart and assign order id from previous create, add tax rates through the customer
    session[:cart].each do |item|
      product = Product.find(item[0])
      subtotal = BigDecimal(product.price - product.price * product.sale_percentage, 2) * BigDecimal(item[1], 2)

      ordered_item = product.order_items.create!(order_id: order.id,
                                                 product_id: product.id,
                                                 name: product.name,
                                                 price: subtotal,
                                                 quantity: item[1],
                                                 pst: pst,
                                                 gst: gst,
                                                 hst: hst)

      total_price += subtotal
    end

    total_price = BigDecimal(total_price, 2) + BigDecimal(total_price * pst, 2) + BigDecimal(total_price * gst, 2) + BigDecimal(total_price * hst, 2)

    order.total_price = total_price
    order.save!

    # delete cart
    session[:cart] = []

    # redirect
    redirect_to root_path, notice: "Order processed successfully!"
  end

  def invoice
  end

  def payment_information
  end
end
