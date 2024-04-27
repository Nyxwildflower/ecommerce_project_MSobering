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

  def add_to_cart
    id = params[:id].to_i
    session[:cart] << id unless session[:cart].include?(id)
    redirect_to root_path
  end

  def remove_from_cart

  end
end
