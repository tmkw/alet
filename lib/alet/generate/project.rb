require 'sf_cli'

module Alet
  module Project
    def self.generate(project_name, params)
      base_dir        = Dir.pwd
      target_org      = params[:"target-org"]
      retrieve_source = params[:retrieve]
      editor          = params[:"editor-open"]

      sf.project.generate project_name, manifest: true

      Dir.chdir project_name

      sf.project.generate_manifest from_org: target_org, output_dir: 'manifest' if target_org
      sf.project.retrieve_start manifest: 'manifest/package.xml', target_org: target_org if retrieve_source
      system 'code .' if editor
    ensure
      Dir.chdir base_dir
    end
  end
end
