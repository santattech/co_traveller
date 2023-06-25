class LoginSerializer < ResourceSerializer
  set_type :admin_user
  attributes :email, :updated_at
end
