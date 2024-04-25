ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :on_sale, categories_attributes: [:id, :name, :_destroy]

  index do |product|
    selectable_column
    column :name
    column :description
    column :price
    column :stock_quantity
    column :on_sale
    column :categories do |product|
      product.categories.map { |pr| pr.name }.join(", ").html_safe
    end
    actions
  end

  show do |product|
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :on_sale
      row :categories do |product|
        product.categories.map { |pr| pr.name }.join(", ").html_safe
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names

    f.inputs "Product" do
      f.inputs
      # THIS ISNT ALLOWING FOR ADDING EXISTING CATEGORIES
      f.has_many :categories, allow_destroy: true do |n_f|
        n_f.input :name
      end

      # f.inputs :categories, :as => :select
      # f.inputs :name, :for => :category, :name => "Category"

      # Select: yes, but weird. Update, add categories: no
      # f.input :categories, as: :select, allow_destroy: true

      # Shows select, but uses id for value and trips minimum character length validation on name
      # f.has_many :categories, allow_destroy: true do |n_f|
      #   n_f.input :name, as: :select, collection: Category.all
      # end
    end

    f.actions
  end
end
