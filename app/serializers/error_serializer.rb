class ErrorSerializer
  #This handles general error returns to be aligned with BE requirements doc

  def self.handle_exception(exception, custom_message)
    #Check if exception.message is already an array of strings; if not, make it so
    if exception.message.class != Array
      errors_array = [exception.message]
    else
      errors_array = exception.message
    end

    {
      data: {
        message: custom_message,
        errors: errors_array
      }
    }
  end

  def self.search_parameters_error(message)
    {
      data: {  
        message: "Parameter(s) error",
        errors: [message]
      }
    }
  end

  def self.no_item_matched(message)
    {
      data: {
        message: "Item not found",
        errors: [message]
      }
    }
  end

  def self.format(errors)
    {
      data: {
        message: "Validation failed",
        errors: errors.is_a?(Array) ? errors : [errors] # Ensure errors are always an array
      }
    }
  end

end