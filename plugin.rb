# name: discourse-linkify-google-sheets
# about: A plugin that brings the linkify data via a google sheet
# version: 0.1
# authors: Faizaan Gagan
# url: https://github.com/paviliondev/discourse-linkify-google-sheet

gem 'httpclient', '2.8.3', require: false
gem 'signet', '0.14.0', require: false
gem 'os', '1.1.0', require: false
gem 'memoist', '0.16.2', require: false
gem 'googleauth', '0.13.0', require: false
gem 'retriable', '3.1.2', require: false
gem 'declarative-option', "0.1.0", require: false
gem 'declarative', "0.0.10", require: false
gem 'uber', "0.1.0", require: false
gem 'representable', "3.0.4", require: false
gem 'google-api-client', "0.41.1", require: false

module ::LinkifyGoogle
  PLUGIN_NAME = 'linkify_google'.freeze
end

after_initialize do
  require File.expand_path('../app/jobs/scheduled/update_links.rb', __FILE__)

  add_to_serializer(:site, :linkify_data, false) do 
    PluginStoreRow.where(plugin_name: ::LinkifyGoogle::PLUGIN_NAME).pluck(:key, :value)
  end
end