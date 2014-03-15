module I18nData
  module FileDataProvider
    DATA_SEPARATOR = ";;"
    extend self

    def codes(type, language_code)
      unless data = read_from_file(cache_file_for(type, language_code))
        raise NoTranslationAvailable, "#{type}-#{language_code}"
      end
      data
    end

    def get_progress_bar(max_count)
      return nil unless $stderr.tty?
      require 'ruby-progressbar'
      ProgressBar.create(:format => '%t %E: |%w|',
                         :title => 'writing translation cache data',
                         :total => max_count)
    rescue LoadError
      $stderr.puts ':: i18n_data file write cache update ::'
      $stderr.puts
      $stderr.puts 'for fancier estimated progress, run:'
      $stderr.puts '   gem install ruby-progressbar'
      $stderr.puts
      $stderr.puts ' or with Bundler, add this to the Gemfile:'
      $stderr.puts "   gem 'ruby-progressbar'"
      $stderr.puts
    end

    def write_cache(provider)
      languages = provider.codes(:languages, 'EN').keys + ['zh_CN', 'zh_TW', 'zh_HK','bn_IN','pt_BR']
      progress_bar = get_progress_bar(languages.count)
      unless progress_bar
        $stderr.puts 'i18n_data: Updating file cache, will take about 8 minutes...'
      end

      languages.map do |language_code|
        [:languages, :countries].each do |type|
          begin
            data = provider.send(:codes, type, language_code)
            write_to_file(data, cache_file_for(type, language_code))
          rescue NoTranslationAvailable
            $stderr.puts "No translation available for #{type} #{language_code}" if $DEBUG
          rescue AccessDenied
            $stderr.puts "Access denied for #{type} #{language_code}"
          end
        end
        progress_bar.increment if progress_bar
      end
    end

  private

    def read_from_file(file)
      return nil unless File.exist?(file)
      data = {}
      File.readlines(file).each do |line|
        code, translation = line.strip.split(DATA_SEPARATOR, 2)
        data[code] = translation
      end
      data
    end

    def write_to_file(data, file)
      return if data.empty?
      FileUtils.mkdir_p File.dirname(file)
      File.open(file,'w') do |f|
        f.write data.map{|code, translation| "#{code}#{DATA_SEPARATOR}#{translation}" } * "\n"
      end
    end

    def cache_file_for(type,language_code)
      file = "#{type}-#{language_code.upcase}"
      File.join(File.dirname(__FILE__), '..', '..', 'cache', 'file_data_provider', "#{file}.txt")
    end
  end
end
