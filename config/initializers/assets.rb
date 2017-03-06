# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css.less, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(events.js stickers.js charCount.js vacancies.js stickers.css events.css
                                                 form-validator/jquery.form-validator.js candidates/candidates_form.js.coffee
                                                 candidates/candidates_form.css candidates/candidates.css candidates/candidates.js)
