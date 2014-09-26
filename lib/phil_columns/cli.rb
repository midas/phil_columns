require 'thor'

module PhilColumns
  class Cli < Thor

    autoload :Generate, 'phil_columns/cli/generate'

    include Thor::Actions

    def self.dry_run_option
      option :dry_run, type: :boolean, desc: "When true, output steps but does not execute protected blocks"
    end

    def self.env_option
      option :env, type: :string, aliases: '-e', desc: "The environemnt to execute in", default: 'development'
    end

    def self.operation_option
      option :operation, type: :string, aliases: '-o', desc: "The operation: all or any", default: 'any'
    end

    desc 'generate TYPE', "Generates different phil_columns assets"
    subcommand "generate", PhilColumns::Cli::Generate

    desc "install PATH", "Install phil_columns within a project"
    option :rails, type: :boolean, aliases: '-r', desc: "When true, install with defaults for Rails"
    option :seeds_path, type: :string, aliases: '-p', desc: "The path of the project to install within", default: './seeds'
    def install( path='.' )
      execute PhilColumns::Command::Install, path: path
    end

    desc "seed [TAGS]", "Run the seeds"
    option :down, type: :boolean, aliases: '-d', desc: "When true, executes down seeding"
    dry_run_option
    env_option
    operation_option
    option :version, type: :string, aliases: '-v', desc: "The version to execute to", default: 'all'
    def seed( *tags )
      execute PhilColumns::Command::Seed, tags: tags
    end

    desc "mulligan [TAGS]", "Drop all tables, migrate up and run the seeds"
    env_option
    operation_option
    def mulligan( *tags )
      execute PhilColumns::Command::Mulligan, tags: tags
    end

    no_commands do

      def execute( klass, additional_options={} )
        klass.new( options.merge( additional_options )).execute
      rescue PhilColumns::Error => e
        handle_error( e )
        exit 1
      end

      def handle_error( e )
        say "Error: #{e.message}", :red
      end

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
      $stdout.puts "Incorrect usage of command: #{command.name}"
      $stdout.puts "  #{error.message}", ''
      $stdout.puts "For correct usage:"
      $stdout.puts "  phil_columns help #{command.name}"
    end

    def self.handle_no_command_error( name )
      $stdout.puts "Unrecognized command: #{name}"
    end

  end
end
