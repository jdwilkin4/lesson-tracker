OmniAuth.config.on_failure = proc do |env|
    OmniauthCallbacksController.action(:failure).call(env)
end
  