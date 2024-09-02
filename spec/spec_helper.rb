# frozen_string_literal: true
$LOAD_PATH << 'lib'
require 'i18n_data'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
end
