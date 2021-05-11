# Request Helper
module Request
  # JSON Helpers
  module JsonHelpers
    def js_res
      @js_res ||= JSON.parse(response.body, symbolize_names: true)
    rescue
      {}
    end

    def data
      js_res[:data]
    end

    def data_count
      js_res[:data].count
    end

    def meta
      js_res[:meta]
    end

    def pagination
      meta[:pagination]
    end
  end

  # Header Helpers
  module HeaderHelpers
    def authorization_header(token, email = nil)
      request.headers['Authorization'] = authorization_token(token, email)
    end

    def authorization_token(token, email = nil)
      str = "Token token=#{token}"
      str += ";email=#{email}" if email
      str
    end
  end
end

RSpec.configure do |config|
  config.include Request::JsonHelpers, type: :controller
  config.include Request::HeaderHelpers, type: :controller
end
