require 'emporium'
require 'yaml'


if File.exists?('./spec/config.yml')
  CONFIG = YAML.load_file('./spec/config.yml')
else
  CONFIG = YAML.load_file('./spec/config_sample.yml')
end

AMAZON = CONFIG["amazon"]
GOOGLE = CONFIG["google"]

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures"
  config.hook_into :webmock
  config.filter_sensitive_data('<access_key>') { AMAZON["access_key"] }
  config.filter_sensitive_data('<associate_tag>') { AMAZON["associate_tag"] }
  config.filter_sensitive_data('<secret>') { AMAZON["secret"] }
  config.filter_sensitive_data('<access_key>') { GOOGLE["access_key"] }
  config.filter_sensitive_data('<cse>') { GOOGLE["cse"] }
  config.default_cassette_options = {
    :match_requests_on => [:method, VCR.request_matchers.uri_without_params(:Timestamp, :Signature, :AssociateTag, :key)]
  }
end
