# Request Helper
module Request
  # JSON Helpers
  module JsonHelpers
    def js_res
      @js_res ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  # Header Helpers
  module HeaderHelpers
    def authorization_header(user_token, user_email)
      request.headers['Authorization'] = "Token token=#{user_token};"\
                                         " email=#{user_email}"
    end
  end
end

RSpec.configure do |config|
  config.include Request::JsonHelpers, type: :controller
  config.include Request::HeaderHelpers, type: :controller
end
