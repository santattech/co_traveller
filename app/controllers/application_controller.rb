class ApplicationController < ActionController::Base
  
  def admin_user_logged_in
    unless current_admin_user
      redirect_to new_admin_user_session_path, notice: "Please login"
    end
  end

  def render_json_error(status, options = {})
    if options[:code].present? && options[:message].present?
      # dont do anything here
    elsif options[:code].present?
      language = "en"
      options[:message] = I18n.t("error_code.#{options[:code]}", locale: language)
    end

    render status: status, json: { errors: ErrorSerializer.serialize(status, options) }
  end

  def not_found!
    render_json_error(:not_found, code: "E004") # "Record not found"
  end

  # when use fastjson
  def json_api_serializer_response(resource, options = {})
    serializer_key = options[:serializer] || compute_collection_type(resource)
    serializer = compute_serializer_name(serializer_key)
    serializer.new(resource, options).serialized_json
  end

  private

  def compute_serializer_name(serializer_key)
    return serializer_key unless serializer_key.is_a? Symbol

    serializer_name = serializer_key.to_s.classify + "Serializer"
    serializer_name.constantize
  end

  def compute_collection_type(collection)
    if collection.is_a?(ActiveRecord::Relation)
      collection_class = collection.klass
    # Assume members of array are of the same Model
    elsif collection.is_a?(Array)
      collection_class = collection.first.class
    else
      collection_class = collection.class
    end

    collection_class.base_class.name.to_sym
  end
end
