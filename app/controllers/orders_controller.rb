class OrdersController < ApplicationController
  # before_action :initialize_customer

  def create_order
    # Find customer
    customer = Customer.find(current_customer[:id])
    pst = customer.province.pst
    gst = customer.province.gst
    hst = customer.province.hst

    # Create order through the customer
    order = customer.orders.new(total_price: @cart_total)

    # Create order_items using product on cart and assign order id from previous create, add tax rates through the customer
    @cart.each do |item|
      product = item[:product]

      ordered_item = product.order_items.create!(order_id: order.id,
                                                 product_id: product.id,
                                                 name: product.name,
                                                 price: item[:subtotal],
                                                 quantity: item[:quantity],
                                                 pst: pst,
                                                 gst: gst,
                                                 hst: hst)
    end

    # delete cart
    @cart = []

    # redirect
    redirect_to root_path, notice: "Order processed successfully!"
  end

  def invoice
  end

  def payment_information
  end
end
