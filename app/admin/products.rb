ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
 permit_params :name, :category_id, :brand_id, :description, :price, :sale_price, :img

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute
    f.inputs do
      f.input :img, as: :file
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  show do
    attributes_table do
      row :name
      row :category_id
      row :brand_id
      row :description
      row :price
      row :sale_price
      row :img do |product|
        image_tag(product.img, width: '100px') if product.img.present?
      end
    end
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :category_id, :brand_id, :description, :price, :sale_price, :image]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
