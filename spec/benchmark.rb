# frozen_string_literal: true
# Benchmark performance by looking up every available language's country and
# language translations multiple times.

require 'benchmark'
require 'i18n_data'

types = [:countries, :languages]

type_codes = {}
types.each do |type|
  type_codes[type] = []
  Dir.glob("./cache/file_data_provider/#{type}-*.txt").map do |filename|
    type_codes[type] << /-(.+)\.txt\z/.match(filename)[1]
  end
end

bm = Benchmark.measure do
  10.times do
    type_codes.each_pair do |type, codes|
      codes.each do |code|
        I18nData.send(type, code).each_key do |key|
          I18nData.send(type, code)[key]
        end
      rescue I18nData::NoTranslationAvailable
      end
    end
  end
end

puts bm
