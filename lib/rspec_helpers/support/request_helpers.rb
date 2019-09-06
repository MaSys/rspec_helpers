# Request Helper
module Request
  # JSON Helpers
  module JsonHelpers
    def js_res
      @js_res ||= JSON.parse(response.body, symbolize_names: true)
    rescue
      {}
    end
  end

  # Header Helpers
  module HeaderHelpers
    def authorization_header(token, email = nil)
      str = "Token token=#{token}"
      str += ";email=#{email}" if email
      request.headers['Authorization'] = str
    end
  end
end

RSpec.configure do |config|
  config.include Request::JsonHelpers, type: :controller
  config.include Request::HeaderHelpers, type: :controller
end
