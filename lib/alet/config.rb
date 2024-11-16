module Alet
  class Config
    def org
      @org
    end

    def org=(org)
      @org = org
    end

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
