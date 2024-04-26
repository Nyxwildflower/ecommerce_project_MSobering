class ProductsController < ApplicationController
  def index
    @products = Product.all.includes(:categories)
  end

  def show
    @product = Product.find(params[:id])
  end
end
