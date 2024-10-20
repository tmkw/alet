module IRBUtils
  refine IRB do
    def IRB.start(ap_path, argv)
      STDOUT.sync = true
      $0 = File::basename(ap_path, ".rb") if ap_path

      setup(ap_path, argv: argv)

      if @CONF[:SCRIPT]
        irb = ::IRB::Irb.new(nil, @CONF[:SCRIPT])
      else
        irb = ::IRB::Irb.new
      end
      irb.run(@CONF)
    end
  end
end
