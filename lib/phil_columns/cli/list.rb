require 'thor'

module PhilColumns
  class Cli
    class List < Thor

      def self.banner( command, namespace=nil, subcommand=false )
        return "#{basename} list help [SUBCOMMAND]" if command.name == 'help'
        "#{basename} #{command.usage}"
      end

      def self.env_option
        option :env, type: :string, aliases: '-e', desc: "The environment to execute in", default: 'development'
      end

      def self.operation_option
        option :operation, type: :string, aliases: '-o', desc: "The operation: all or any", default: 'any'
      end

      desc "list tagged-with TAGS", "List all seeds tagged with tag(s)"
      long_desc <<-LONGDESC
        List all seeds tagged with tag(s) within specified environment.

        With --env[-e] option, the environment is overridden. Default: development.

        With --operation[-o] option, the tag filtering operation is overridden. Default: any.
      LONGDESC
      env_option
      operation_option
      def tagged_with( *tags )
        PhilColumns::Command::List::TaggedWith.new( options.merge( tags: tags )).execute
      end

      desc "list tags", "List all tags from all seeds."
      long_desc <<-LONGDESC
        List all tags from all seeds within specified environment.

        With --env[-e] option, the environment is overridden. Default: development.
      LONGDESC
      env_option
      def tags
        PhilColumns::Command::List::Tags.new( options ).execute
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
        $stdout.puts "Incorrect usage of list subcommand: #{command.name}"
        $stdout.puts "  #{error.message}", ''
        $stdout.puts "For correct usage:"
        $stdout.puts "  phil_columns list help #{command.name}"
      end

      def self.handle_no_command_error( name )
        $stdout.puts "Unrecognized command: #{name}"
      end

    end
  end
end
