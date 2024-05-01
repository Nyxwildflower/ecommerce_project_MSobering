ActiveAdmin.register Order do
  permit_params :total_price, :customer_id, order_items_attributes: [:id, :name, :price, :quantity, :gst, :pst, :hst]

  index do |order|
    selectable_column
    column :total_price
    column :customer
    column :order_items do |order|
      order.order_items.map { |item| item.name }.join(", ").html_safe
    end

    actions
  end

  show do |order|
    attributes_table do
      row :total_price
      row :customer
      attributes_table_for order.order_items do
        row :name
        row :price
        row :quantity
        row :pst
        row :gst
        row :hst
      end
    end

  end
end
