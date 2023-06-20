module ErrorSerializer
  def self.serialize(status, options = {})
    if options[:message]
      [
        {
          status: status,
          code: options[:code],
          detail: options[:message]
        }
      ]
    elsif (objects = options[:objects])
      error = []
      objects.each do |object|
        error.push(
          { object_attributes: object.attributes },
          object.errors.messages.map do |field, errors|
            errors.map do |error_message|
              {
                status: status,
                source: { pointer: field.to_s },
                detail: error_message
              }
            end
          end.flatten
        )
      end

      error
    else
      options[:object].errors.messages.map do |field, errors|
        errors.map do |error_message|
          {
            status: status,
            source: { pointer: field.to_s.titleize },
            detail: error_message
          }
        end
      end.flatten
    end
  end
end
