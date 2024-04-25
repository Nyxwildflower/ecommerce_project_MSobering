class ProductsController < ApplicationController
  def index
    @products = Product.all.includes(:categories)
  end
end
