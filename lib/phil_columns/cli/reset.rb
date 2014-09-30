require 'thor'

module PhilColumns
  class Cli
    class Reset < Thor

      def self.banner( command, namespace=nil, subcommand=false )
        return "#{basename} reset help [SUBCOMMAND]" if command.name == 'help'
        "#{basename} #{command.usage}"
      end

      def self.default_tags_explanation
        %(If default_tags are specified in the config file and no tags are provided as parameters to the command, the default tags are applied
          as the tags.  However, if tags are provided as parameters they override the defult tags.)
      end

      def self.env_option
        option :env, type: :string, aliases: '-e', desc: "The environment to execute in", default: 'development'
      end

      def self.env_option_description
        %(When --env[-e] option, override the environment.  Default: development.)
      end

      def self.operation_option
        option :operation, type: :string, aliases: '-o', desc: "The operation: all or any", default: 'any'
      end

      def self.operation_option_description
        %(When --operation[-o] option, override the operation to one of any or all.  Default: any.)
      end

      def self.skip_option
        option :skip, type: :boolean, desc: "When true, skip tables listed in config", default: true
      end

      def self.skip_on_purge_description
        %(When --no-skip, override the skip_tables_on_purge configuration.  Otherwise, the tables specified in the skip_tables_on_purge configuration
          will be skipped.)
      end

      def self.version_option
        option :version, type: :string, aliases: '-v', desc: "The version to execute to", default: 'all'
      end

      def self.version_option_description
        %(When --version[-v] option, override the version.  Default: all.  Provide the timestamp from the beginning of the seed file name
        as the version parameter.  When seeding up, the specified version is included in the seed set.  When seeding down the specified
        version is not included in the set.)
      end

      desc "reset data [TAGS]", "Reset the data in the database"
      long_desc <<-LONGDESC
        Reset the data in the database.  Empties the tables and then executes seeds.

        #{default_tags_explanation}

        #{env_option_description}

        #{operation_option_description}

        #{skip_on_purge_description}

        #{version_option_description}
      LONGDESC
      env_option
      operation_option
      skip_option
      version_option
      def data( *tags )
        PhilColumns::Command::Reset::Data.new( options.merge( tags: tags )).execute
      end

      desc "reset schema", "Reset the database schema"
      long_desc <<-LONGDESC
        Reset the database schema.  Drops the tables and loads the schema using migrations.

        This operation is useful when the structure of the database has change and a load operation will not
        pick up the changes.
      LONGDESC
      def schema( *tags )
        PhilColumns::Command::Reset::Schema.new( options ).execute
      end

      def self.handle_argument_error( command, error, _, __ )
        method = "handle_argument_error_for_#{command.name}"

        if respond_to?( method )
          send( method, command, error )
        else
          handle_argument_error_default( command, error )
        end
      end

      def self.handle_argument_error_default( command, error )
        $stdout.puts "Incorrect usage of generate subcommand: #{command.name}"
        $stdout.puts "  #{error.message}", ''
        $stdout.puts "For correct usage:"
        $stdout.puts "  phil_columns generate help #{command.name}"
      end

      def self.handle_no_command_error( name )
        $stdout.puts "Unrecognized command: #{name}"
      end

    end
  end
end
