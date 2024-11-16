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
