ActiveAdmin.register AdminUser do
    menu parent: "Users", label: "AdminUser", priority: 1

  config.batch_actions = false
  permit_params :email, :password, :password_confirmation

  controller do
    def scoped_collection
      super.where.not(email: ['admin@example.com', 'santattech@gmail.com'])
    end

    actions :all, except: [:destroy, :new, :create]
  end

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
