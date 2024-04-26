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
      redirect_to "/"
    else
      # Search for keyword in Product names or descriptions.
      @products = Product.where('name LIKE ?', "%#{@query}%").or(Product.where('description LIKE ?', "%#{@query}%")).page(params[:page])

      # Count all of the products found.
      @count = @products.total_count
    end
  end
end
