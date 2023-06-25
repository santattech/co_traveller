class AdminUserSerializer < ResourceSerializer
  include ApplicationHelper
  attributes :email, :last_sign_in_ip, :updated_at, :current_sign_in_at

  attribute :last_sign_in_at do |object, params|
    params[:context].dist_of_time_in_words(object.last_sign_in_at)
  end

  attribute :current_sign_in_at do |object, params|
    params[:context].dist_of_time_in_words(object.current_sign_in_at)
  end

  attribute :updated_at do |object, params|
    params[:context].dist_of_time_in_words(object.updated_at)
  end
end
