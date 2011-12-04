require 'emporium'
require 'yaml'

CONFIG = YAML.load_file('./spec/config.yml')

access_key = CONFIG["access_key"]
secret = CONFIG["secret"]
associate_tag = CONFIG["associate_tag"]

include Emporium
