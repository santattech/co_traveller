class AdminUserSerializer < ResourceSerializer
  attributes :email, :last_sign_in_at, :last_sign_in_ip, :updated_at, :current_sign_in_at
end
