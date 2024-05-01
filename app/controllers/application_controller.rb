class ApplicationController < ActionController::Base
  before_action :configure_sign_up_params, if: :devise_controller?
  before_action :configure_account_update_params, if: :devise_controller?
  before_action :initialize_cart
  before_action :load_cart
  before_action :site_location

  def site_location
    if (request.path != "/customers/sign_in" && !current_customer)
      session[:previous_url] = request.fullpath
    end
  end

  protected

  def after_sign_in_path_for(resource)
    previous_path = session[:previous_url]
    session[:previous_url] = nil
    previous_path || public_root_path
  end

  def configure_sign_up_params
    attributes = [:name, :username, :email, :password, :password_confirmation, :address, :province_id]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :username, :email, :password, :password_confirmation, :address, :province_id])
  end

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

      subtotal = BigDecimal(find_product.price - find_product.price * find_product.sale_percentage, 2) * BigDecimal(item_details[:quantity], 2)
      item_details[:subtotal] = subtotal

      # Add up total price including sales and quantities.
      @cart_total += subtotal
    end

    if customer_signed_in?
      province = Province.find(current_customer[:province_id])
      @taxes = {pst: BigDecimal(@cart_total * province.pst.to_f, 2),
                gst: BigDecimal(@cart_total * province.gst.to_f, 2),
                hst: BigDecimal(@cart_total * province.hst.to_f, 2)}
    end
  end
end
