module AjaxHelpers
  protected
    def handle_ajax_validation_errors(object)
      if !object.errors.empty? && request.xhr?
        set_ajax_validation_errors(object.errors.to_json)
        return true     
      end
      return false
    end

    def set_ajax_validation_errors(errors)
      response.headers['X-JSON'] = errors
      render :nothing => true, :status=>444       
    end
end