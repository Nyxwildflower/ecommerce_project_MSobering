class ApplicationController < ActionController::Base
  before_action :initialize_cart
  before_action :load_cart

  private

  # Create the cart session variable.
  def initialize_cart
    session[:cart] ||= []
  end

  # Load the cart as an array of hashes containing the product and quantity.
  def load_cart
    @cart_total = 0
    @cart = []

    # Loop through each array in the session cart array to find id and quantities.
    session[:cart].each do |item|
      find_product = Product.find(item[0])
      item_details = { :quantity => item[1], :subtotal => 0, :product => find_product }
      @cart.push(item_details)

      subtotal = BigDecimal((find_product.price - find_product.price * find_product.sale_percentage) * item_details[:quantity], 2)
      item_details[:subtotal] = subtotal

      # Add up total price including sales and quantities.
      @cart_total += subtotal
    end
  end
end
