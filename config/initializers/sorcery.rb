Rails.application.config.sorcery.submodules = [:remember_me, :external]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  config.external_providers = [:github]


  config.github.key = "#{Rails.application.secrets.sorcery_github_key}"
  config.github.secret = "#{Rails.application.secrets.sorcery_github_secret}"
  config.github.callback_url = "#{Rails.application.secrets.sorcery_github_callback_url}"
  config.github.user_info_mapping = { email: "name" }

  config.user_config do |user|
    user.authentications_class = Authentication
  end

  config.user_class = 'User'
end
