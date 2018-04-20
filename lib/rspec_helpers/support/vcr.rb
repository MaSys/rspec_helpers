begin
  require 'vcr'

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    c.hook_into :webmock
    c.configure_rspec_metadata!
    c.ignore_localhost = true
    c.default_cassette_options = {
      match_requests_on: [:method, VCR.request_matchers.uri_without_param(:url)]
    }
  end
rescue LoadError
end
