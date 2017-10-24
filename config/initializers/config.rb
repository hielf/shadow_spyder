# APP_CONFIG = YAML.load_file(Rails.root.join('/config/config.yml'))[Rails.env]
config = Rails.application.config_for(:config)
APP_CONFIG = OpenStruct.new(config)
