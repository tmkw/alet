require 'nokogiri'

def gen_lwc(argv, params)
  target_map = {
    'app' => 'lightning__AppPage',
    'flow' => 'lightning__FlowScreen',
    'home' => 'lightning__HomePage',
    'action' => 'lightning__RecordAction',
    'record' => 'lightning__RecordPage',
    'tab' => 'lightning__Tab',
    'bar' => 'lightning__UtilityBar',
  }

  return if argv.empty?

  pastel   = Pastel.new
  name     = argv.first
  name[0]  = name[0].downcase
  base_dir = Dir.pwd
  dx_dir   = 'force-app/main/default'
  dir = if FileTest.exist?(%|#{base_dir}/#{dx_dir}|)
          %|#{base_dir}/#{dx_dir}/lwc|
        else
          base_dir
        end
  metafile = %|#{dir}/#{name}/#{name}.js-meta.xml|
  meta_changed = false

  if FileTest.exist?(%|#{dir}/#{name}|)
    puts pastel.red(t('gen.error.file_duplicated'))
    return
  end

  sf.lightning.generate_component name, type: :lwc, output_dir: dir, api_version: Alet.config.org.api_version

  doc = Nokogiri::XML(File.open(metafile), nil, 'UTF-8', Nokogiri::XML::ParseOptions::NOBLANKS)

  if params[:label]
    node = doc.at_css('LightningComponentBundle')
    label = Nokogiri::XML::Node.new("masterLabel", node)
    label.content = params[:label]
    node.add_child label
    meta_changed = true
  end

  if params[:description]
    node = doc.at_css('LightningComponentBundle')
    desc = Nokogiri::XML::Node.new("description", node)
    desc.content = params[:description]
    node.add_child desc
    meta_changed = true
  end

  if params[:exposed]
    node = doc.at_css('isExposed')
    node.content = true
    meta_changed = true
  end

  if params[:target]
    node = doc.at_css('LightningComponentBundle')
    targets_node = Nokogiri::XML::Node.new("targets", node)

    targets = params[:target].split(',').map{|t| target_map[t]}
    targets.each do |target|
      target_node = Nokogiri::XML::Node.new("target", targets_node){|n| n.content = target}
      targets_node.add_child target_node 
    end
    node.add_child targets_node

    if targets.include?('lightning__RecordAction') || targets.include?('lightning__RecordPage')
      target_configs = Nokogiri::XML::Node.new('targetConfigs', node)
      action_config  = Nokogiri::XML::Node.new('targetConfig', target_configs){|n| n.set_attribute('targets', 'lightning__RecordAction') }
      record_config  = Nokogiri::XML::Node.new('targetConfig', target_configs){|n| n.set_attribute('targets', 'lightning__RecordPage') }

      if targets.include?('lightning__RecordAction')
        action_type = Nokogiri::XML::Node.new('actionType', action_config)
        action_type.content = 'ScreenAction'
        action_config.add_child action_type
        target_configs.add_child action_config
      end

      if targets.include?('lightning__RecordAction') && params[:object]
        objects = Nokogiri::XML::Node.new('objects', record_config)
        params[:object].split(',').each do |object_name|
          object = Nokogiri::XML::Node.new('object', objects)
          object.content = object_name
          objects.add_child object
        end
        record_config.add_child objects
        target_configs.add_child record_config
      end
      node.add_child target_configs
    end
    meta_changed = true
  end

  File.open(metafile, 'w') {|f| f.write(doc.to_xml indent: 4)} if meta_changed
end
