require 'emporium'
require 'yaml'

CONFIG = YAML.load_file('./spec/config.yml')
AMAZON = CONFIG["amazon"]
GOOGLE = CONFIG["google"]