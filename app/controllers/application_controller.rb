class ApplicationController < ActionController::Base
  before_action :initialize_cart
  before_action :load_cart

  private

  def initialize_cart
    session[:cart] ||= []
  end

  def load_cart
    @cart_total = 0
    @cart = Product.find(session[:cart])

    # Calculate the subtotal with sales prices. Items without sales subtract 0.
    @cart.each do |add|
      @cart_total += add.price - add.price * add.sale_percentage
    end
  end
end
