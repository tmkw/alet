def show_org_settings
  info = sf.org.display target_org: Alet.config.org.alias

  table =
    TTY::Table.new(rows: [
      [:id, info.id],
      [:alias, info.alias],
      [:user_name, info.user_name],
      [:status, info.status],
      [:instance_url, info.instance_url],
      [:api_version, info.api_version],
      [:access_token, info.access_token]
    ])
  puts table.render :unicode
rescue => e
  pastel = Pastel.new
  puts pastel.red(e.message.sub("See more help with --help", ''))
end

def show_rest_client_settings
  table =
    TTY::Table.new(rows: [
      [:instance_url, Alet.rest_client.instance_url],
      [:access_token, Alet.rest_client.access_token],
      [:api_version, Alet.rest_client.api_version],
    ])
  puts table.render :unicode
end

def reset_connection
  org = sf.org.display target_org: Alet.config.cli_options[:"target-org"]

  unless org.connected?
    sf.org.login_web target_org: org.alias, instance_url: org.instance_url
    org = sf.org.display target_org: Alet.config.cli_options[:"target-org"]
  end

  Alet.config.org = org

  reset_rest_client
  reset_sobject_model_adapter
end

def reset_rest_client
  rest_client = SObjectModel::Rest::Client.new(
                  instance_url: Alet.config.org.instance_url,
                  access_token: Alet.config.org.access_token,
                  api_version: Alet.config.org.api_version)

  Alet.rest_client = rest_client
end

def reset_sobject_model_adapter
  adapter = SObjectModel::Adapter::Rest.new(Alet.rest_client)
  SObjectModel.connection = adapter
end
