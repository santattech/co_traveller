class AdminUserSerializer < ResourceSerializer
  attributes :email, :last_sign_in_at, :last_sign_in_ip
end
