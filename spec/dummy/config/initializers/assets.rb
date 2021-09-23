# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Fixes a bug with sprockets v4
# https://github.com/rails/sprockets/issues/581#issuecomment-486984663
Rails.application.config.assets.configure do |env|
  env.export_concurrent = false
end
