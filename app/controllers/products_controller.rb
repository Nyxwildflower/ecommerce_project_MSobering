class ProductsController < ApplicationController
  def index
    @products = Product.all.page(params[:page])
  end

  def show
    @product = Product.find(params[:id])
  end

  # Allow for searching for products via keyword with
  # option to narrow search down by category.
  def search
    # Get the keyword from the search form input.
    @query = params[:q]

    if @query.strip == ""
      redirect_to root_path
    elsif params[:category_filter].blank?
      # Search for keyword in Product names or descriptions.
      @products = Product.where('name LIKE ?', "%#{@query}%").or(Product.where('description LIKE ?', "%#{@query}%")).page(params[:page])

      # Count all of the products found.
      @count = @products.total_count
    else
      @category_filter = params[:category_filter]

      # Search products with a category filter.
      @products = Product.where('products.name LIKE ?', "%#{@query}%").or(Product.where('products.description LIKE ?', "%#{@query}%")).includes(:categories).where('categories.name = ?', @category_filter).references(:categories).page(params[:page])

      # Count all of the products found.
      @count = @products.total_count
    end
  end

  def change_quantity
    id = params[:id].to_i
    quantity = params[:quantity].to_i

    if quantity >= 1
      # Find and return the whole array that contains the id.
      find_array = session[:cart].find { |el| el[0] == id}

      # Then search for the index of that array in the cart.
      array_index = session[:cart].find_index(find_array)

      session[:cart][array_index][1] = quantity
    end

    redirect_to cart_path
  end

  def add_to_cart
    # Get the id param from the link and set the quantity to one by default.
    id = params[:id].to_i
    quantity = 1

    session[:cart] << [id, quantity] unless session[:cart].find { |el| el[0] == id}
    redirect_to root_path
  end

  def remove_from_cart
    id = params[:id].to_i
    # Find the index of the array that contains the specified id.
    delete_array = session[:cart].find { |el| el[0] == id}

    session[:cart].delete(delete_array)
    redirect_to root_path
  end
end
