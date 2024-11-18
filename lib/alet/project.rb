require 'sf_cli'
require 'fileutils'

module Alet
  module Project
    def self.generate(project_name, params)
      base_dir        = Dir.pwd
      target_org      = params[:"target-org"]
      retrieve_source = params[:retrieve]
      editor          = params[:"editor-open"]

      return if project_name.nil?

      puts sf.project.generate project_name, manifest: true, raw_output: true

      Dir.chdir project_name

      puts sf.project.generate_manifest from_org: target_org, output_dir: 'manifest', raw_output: true if target_org

      sf.project.retrieve_start manifest: 'manifest/package.xml', target_org: target_org, raw_output: true if retrieve_source
      system 'code .' if editor
    ensure
      Dir.chdir base_dir
    end

    def self.update(project_name, params)
      base_dir        = Dir.pwd
      target_org      = params[:"target-org"]
      editor          = params[:"editor-open"]

      Dir.chdir project_name

      manifest = 'manifest/package.xml'

      FileUtils.rm manifest if FileTest.exist?(manifest)

      puts sf.project.generate_manifest from_org: target_org, output_dir: 'manifest', raw_output: true
      sf.project.retrieve_start manifest: 'manifest/package.xml', target_org: target_org, raw_output: true
      system 'code .' if editor
    ensure
      Dir.chdir base_dir
    end
  end
end
