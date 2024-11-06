require_relative 'alet/config'

module Alet
  def self.config
    @config ||= Config.new
  end

  def self.rest_client
    @rest_client
  end

  def self.rest_client=(client)
    @rest_client = client
  end

  def self.describe_global
    @describe_global ||= rest_client.describe_global
  end

  def self.describe(object_type)
    rest_client.describe object_type
  end
end
