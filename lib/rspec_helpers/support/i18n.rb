# I18n
module I18nHelperMethods
  def t(*args)
    I18n.t(*args)
  end

  def locale(locale)
    request.headers['HTTP_ACCEPT_LANGUAGE'] = locale
  end
end

RSpec.configure do |config|
  config.include I18nHelperMethods
end
