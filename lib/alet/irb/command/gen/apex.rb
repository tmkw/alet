def gen_apex(argv, params)
  return if argv.empty?

  name = argv.first

  base_dir = Dir.pwd
  dx_dir = 'force-app/main/default'
  dir = if FileTest.exist?(%|#{base_dir}/#{dx_dir}|)
          %|#{base_dir}/#{dx_dir}/#{params[:trigger] ? 'triggers' : 'classes'}|
        else
          base_dir
        end

  if FileTest.exist?(%|#{dir}/#{name}#{params[:trigger] ? '.trigger' : '.cls'}|)
    pastel = Pastel.new
    puts pastel.red(t('gen.error.file_duplicated'))
    return
  end

  if params[:trigger]
    event_map = {
      'bi' => 'before insert',
      'bu' => 'before update',
      'bd' => 'before delete',
      'ai' => 'after insert',
      'au' => 'after update',
      'ad' => 'after delete',
      'aud' => 'after undelete',
    }
    events = params[:event]&.split(',')&.map{|e| event_map[e]}&.compact
    sf.apex.generate_trigger name, output_dir: dir, sobject: params[:sobject], event: events
  else
    sf.apex.generate_class name, output_dir: dir
    sf.apex.generate_class %|#{name}Test|, output_dir: dir, template: :ApexUnitTest
  end
end
