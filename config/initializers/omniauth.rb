Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']

    on_failure { |env| AuthenticationsController.action(:failure).call(env) }
end