module Imori
  def self.config
    @config ||= Config.new
  end

  class Config
    def connection
      @connection
    end

    def connection=(conn)
      @connection = conn
    end
  end
end
