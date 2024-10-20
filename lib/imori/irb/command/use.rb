class UseOrg < IRB::Command::Base
  category "Imori"
  description "Initialize the connection with Salesforce"
  help_message <<~HELP
    Usage: use alias

    alias - Username or alias of the target org.
  HELP

  def execute(target_org)
    conn = sf.org.display target_org: target_org

    Imori.config.connection = conn

    Yamori.connect(
      :rest,
      instance_url: conn.instance_url,
      access_token: conn.access_token,
      api_version:  conn.api_version
    )

    unless conn.connected?
      sf.org.login_web target_org: target_org, instance_url: config.instance_url
    end 

    true
  end
end
