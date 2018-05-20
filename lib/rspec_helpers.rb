require 'rspec_helpers/version'
Dir[
  File.join(__dir__, 'rspec_helpers', 'examples', '*.rb'),
  File.join(__dir__, 'rspec_helpers', 'support', '*.rb')
].each do |file|
  require file
end

module RspecHelpers
  def self.devise_attrs
    %w[
      encrypted_password reset_password_token reset_password_sent_at
      remember_created_at sign_in_count current_sign_in_at last_sign_in_at
      current_sign_in_ip last_sign_in_ip failed_attempts unlock_token
      locked_at auth_token confirmation_token confirmed_at confirmation_sent_at
      unconfirmed_email
    ]
  end

  def self.attach_columns
    %w[_content_type _file_size _updated_at]
  end
end
