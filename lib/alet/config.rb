module Alet
  def self.config
    @config ||= Config.new
  end

  class Config
    def connection
      @connection
    end
    alias conn connection

    def connection=(conn)
      @connection = conn
    end
    alias conn= connection=

    def cli_options
      @cli_options ||= {}
    end

    def i18n
      @i18n ||= I18nConfig.new
    end

    class I18nConfig
      def load_path
        Dir[File.expand_path("../config/locales", __FILE__) + "/*.yml"]
      end
    end
  end
end
