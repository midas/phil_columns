require 'thor'

module PhilColumns
  class Cli < Thor

    autoload :Generate, 'phil_columns/cli/generate'
    autoload :List,     'phil_columns/cli/list'

    include Thor::Actions

    def self.default_tags_explanation
      %(If default_tags are specified in the config file and no tags are provided as parameters to the command, the default tags are applied
        as the tags.  However, if tags are provided as parameters they override the defult tags.)
    end

    def self.dry_run_option
      option :dry_run, type: :boolean, desc: "When true, output steps but does not execute protected blocks"
    end

    def self.env_option
      option :env, type: :string, aliases: '-e', desc: "The environment to execute in", default: 'development'
    end

    def self.env_option_description
      %(When --env[-e] option, override the environment.  Default: development.)
    end

    def self.no_skip_option
      option :skip, type: :boolean, desc: "When true, skip tables listed in config", default: true
    end

    def self.operation_option
      option :operation, type: :string, aliases: '-o', desc: "The operation: all or any", default: 'any'
    end

    def self.operation_option_description
      %(When --operation[-o] option, override the operation to one of any or all.  Default: any.)
    end

    def self.version_option
      option :version, type: :string, aliases: '-v', desc: "The version to execute to", default: 'all'
    end

    def self.version_option_description
      %(When --version[-v] option, override the version.  Default: all.  Provide the timestamp from the beginning of the seed file name
      as the version parameter.  When seeding up, the specified version is included in the seed set.  When seeding down the specified
      version is not included in the set.)
    end

    desc "empty", "Empty tables"
    long_desc <<-LONGDESC
      Empties all tables excluding any project metadata tables, ie. schema_migrations when using ActiveRecord.
    LONGDESC
    no_skip_option
    def empty( *tags )
      execute PhilColumns::Command::Empty, tags: tags
    end

    desc 'generate SUBCOMMAND', "Generates different phil_columns assets"
    subcommand "generate", PhilColumns::Cli::Generate

    desc "install PATH", "Install phil_columns within a project"
    long_desc <<-LONGDESC
      Install phil_columns within a project at path PATH.

      Installs a .phil_columns configuration file within PATH and a seeds directory at <PATH>/seeds by default.

      When --rails[-r] option, install with defaults for a Rails project.  This includes the configuring the seeds directory
      to db/seeds and adding config/enironment to the list of env_files in the configuration file.

      When --seeds-path[-p] option, configure the seeds directory specified path.  This option is not necessary if --rails
      option provided.
    LONGDESC
    option :rails, type: :boolean, aliases: '-r', desc: "When true, install with defaults for Rails"
    option :seeds_path, type: :string, aliases: '-p', desc: "The path of the project to install within", default: './seeds'
    def install( path='.' )
      execute PhilColumns::Command::Install, path: path
    end

    desc 'list SUBCOMMAND', "List different seed info"
    subcommand "list", PhilColumns::Cli::List

    desc "mulligan [TAGS]", "Unload and load the schema then execute seeds"
    long_desc <<-LONGDESC
      A complete reset of the database.  The tables are removed and rebuilt and the data is seeded.  The strategy used to
      unload and load the schema is controlled by the configuration file attributes schema_unload\_strategy and schema\_load_strategy.  The mulligan
      term is borrowed from golf where a mulligan is a do-over.

      #{default_tags_explanation}

      #{env_option_description}

      #{operation_option_description}

      When --schema-load-strategy[-l] option, override the schema load strategy to one of load or migrate.  When load is specified loads
      the schema.  When migrate specified runs the migrations.  Load is a more efficient operation.  Defaults to the value specified in
      the configuration file attribute schema_load_strategy.

      When --schema-unload-strategy[-l] option, override the schema unload strategy to one of drop or migrate.  When drop is specified drops
      the tables.  When migrate specified runs the migrations down.  Drop is a more efficient operation.  Defaults to the value specified in
      the configuration file attribute schema_unload_strategy.

      #{version_option_description}
    LONGDESC
    env_option
    operation_option
    option :schema_load_strategy, type: :string, aliases: '-l', desc: "The schema load strategy to use: load or migrate"
    option :schema_unload_strategy, type: :string, aliases: '-u', desc: "The schema unload strategy to use: drop or migrate"
    version_option
    def mulligan( *tags )
      execute PhilColumns::Command::Mulligan, tags: tags
    end

    desc "seed [TAGS]", "Execute the seeds"
    long_desc <<-LONGDESC
      Execute the seeds.

      #{default_tags_explanation}

      When --down[-d] option, execute the down seeds.

      When --dry-run option, execute the seeds as a dry run.

      #{env_option_description}

      #{operation_option_description}

      #{version_option_description}
    LONGDESC
    option :down, type: :boolean, aliases: '-d', desc: "When true, executes down seeding"
    dry_run_option
    env_option
    operation_option
    version_option
    def seed( *tags )
      execute PhilColumns::Command::Seed, tags: tags
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
