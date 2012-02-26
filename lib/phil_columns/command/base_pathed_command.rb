module PhilColumns::Command::BasePathedCommand

  def self.included( base )
    base.class_eval do
      attr_reader :base_path
    end
  end

end
