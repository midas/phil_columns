![PhilColumns: No Fixtures Required](https://raw.githubusercontent.com/midas/phil_columns/master/readme/PhilColumns.png)

# PhilColumns

A utility for seeding databases for development and production (works in Rails and non-Rails Ruby projects).


## Installation

Add this line to your application's Gemfile:

    gem 'phil_columns'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phil_columns

To use all features of phil_columns you will need a database adapter. 

    gem 'phil_columns-activerecord'

Or

    $ gem install phil_columns-activerecord


## Usage

### Installation into a project

Installing phil_columns into a Ruby project.

    $ phil-columns install some/path

Installing phil_columns into a Rails project.

    $ phil-columns install --rails

The installation process puts in place the seeds directory and a configuration file: .phil_columns.  The --rails switch
simply overrides some configurations to allow phil_columns to work in a Rails project.


### Seeding Quick Start

Use the generator to create a seed.

    $ phil-columns generate seed add_things

The generator puts a file in place.  Add your seeding logic to the #up and #down methods using any valid Ruby code.

    # 20140513111454_add_things.rb.

    class AddThings < PhilColumns::Seed
      envs :development

      def up
        # seed logic ...
      end

      def down
        # seed logic ...
      end
    end

Execute the seed(s).

    $ phil-columns seed


### The Command Line Interface

Get a summary of commands.

    $ phil-columns help

Get help with a command.

    $ phil-columns help COMMAND
    $ phil-columns help seed

Some commands have sub-commands.  Get help witha sub-command.

    $ phil-columns COMMAND help SUBCOMMAND
    $ phil-columns generate help seed


### The Seed Command

The simplest usage of the seed command defaults the environment to 'development' and the version to 'all.'

    $ phil-columns seed

The environment can be overridden using the command line.  The environment is used to select only seeds that have been specified for the
specified environment.

    $ phil-columns seed --env production
    $ phil-columns seed -e production

The version can be overridden using the command line.  When a version is specified the seeding occurs up to the specified version.  When
the seeding direction is up the version specified is included in the seeding set.  When seeding direction is down the specified version is 
not included in the seed set.

    $ phil-columns seed --version 20140513111454
    $ phil-columns seed -v 20140513111454

The direction of the seeding can be altered to down using the down switch.

    $ phil-columns seed --down
    $ phil-columns seed -d

Finally, a dry run can be invoked using the dry-run switch.

    $ phil-columns seed --dry-run


### The Mulligan Command

The mulligan command is a complete reset of the database.  The tables are removed and rebuilt and the data is seeded.  The strategy used to
unload and load the schema is controlled by the configuration file attributes schema_unload\_strategy and schema\_load_strategy.  The mulligan 
term is borrowed from golf where a mulligan is a do-over.

The simplest usage of the mulligan command defaults the environment to 'development' and the version to 'all.'

    $ phil-columns mulligan

The environment can be overridden using the command line.  The environment is used to select only seeds that have been specified for the
specified environment.

    $ phil-columns mulligan --env production
    $ phil-columns mulligan -e production

The version can be overridden using the command line.  When a version is specified the seeding occurs up to the specified version.  When
the seeding direction is up the version specified is included in the seeding set.  When seeding direction is down the specified version is 
not included in the seed set.

    $ phil-columns mulligan --version 20140513111454
    $ phil-columns mulligan -v 20140513111454


### The Purge Command

The purge command purges the data from all tables (excluding the schema\_migrations table in a Rails project).  If skip_tables_on_purge configuration
is specified, those tables are also skipped unless the --skip option is applied to the command.

The simplest usage of the purge command.

    $ phil-columns purge


### Additional Commands

For documentation on additional commands/sub-commands use the command line interface's  built in help features.

    $ phil-columns help
    $ phil-columns help COMMAND
    $ phil-columns COMMAND help
    $ phil-columns COMMAND help SUBCOMMAND


### Tags and Environments

Tags and environments can be applied to seeds and filtered in command usage.  The seed generator adds the development environment by default and
no tags.  This feature enables efficiency and adaptability in development seeding and the possibility to use phil_columns seeding in production 
(see Production Seeding section below).

Specifying environment(s) for a seed is accomplished with the ::envs class method.

    class AddThings < PhilColumns::Seed
      envs :development
      ...
    end

To change the environment use the env switch.  When not specified the env defaults to development

    $ phil-columns seed -e production

Similary, applying tag(s) is accomplished using the ::tags class method.

    class AddThings < PhilColumns::Seed
      envs :development
      tags :default
      ...
    end

To change the tag(s) provide them after the command command line.  When not specified the tag(s) default to those provided in the default_tags 
configuration attribute.

    $ phil-columns seed defaults settings etc

### Dependencies

A seeds dependence on one more more other seeds to execute before it can be specified.  To do so you must pass the version string(s) to the ::depends_on 
method.

    class AddThings < PhilColumns::Seed
      envs :development

      depends_on 20140523170555
      ...
    end

The version string(s) can be cpecified as Fixnum, String or Symbol.  For instance.

    class AddThings < PhilColumns::Seed
      envs :development

      depends_on 20140523170555
      depends_on '20120528182320' 
      depends_on %w(20120705124536 20120717203851)
      ...
    end

When the currently executing seed's dependencies are not satisfied an error is raised and seeding is abandoned, outputting a helpful message to the console.


#### Advanced Filtering

Currently, filtering is applied with the any operation, which is the default.  In the future development the all operation will be added and negation
of tags.  For example:

    $ phil-columns seed defaults ~settings --all



### Production Seeding

Systems often have system level data that must be seeded on initial startup and as new features or rolled out.  Some examples are settings, configurations,
roles, licenses, etc.

Phil_columns provides the ability to apply these system data seedings and commit them with features, analgous to a Rails migration.  The production seed file
can be specified to run only in production, or in production and development if the data makes sense for both.

To specify a seed for production, simply add production to the specified environments.

    class AddThings < PhilColumns::Seed
      envs :development, :production
      ...
    end


### The Configuration File

The configuration file is in YAML format.

    ---
    default_tags:
    - default
    env_files:
    - config/environment
    schema_load_strategy: load
    schema_unload_strategy: drop
    seeds_path: db/seeds

#### Configuration Attributes

##### default_tags

[Array] A list of tags to apply when no tags are supplied to the command.  When empty, no tags are applied as default.  When not empty,
one or more tags are applied as default.

##### env_files

[Array] A list of environment files to require.  Helps to set up environment before certain commands are executed.  You can provide your own, or utilize
the environment file(s) from a framework, such as Rails.

##### schema_load_strategy

[String] The load strategy to use in commands that load the schema (ie. mulligan).  One of load or migrate.

##### schema_unload_strategy

[String] The unload strategy to use in commands that unload the schema (ie. mulligan).  One of drop or migrate.

##### seeds_path

[String] The relative path to the seeds directory.


## Adapters and Extensions

* [phil_columns-activerecord](https://github.com/midas/phil_columns-activerecord)
* [phil_columns-factory_girl](https://github.com/midas/phil_columns-factory_girl)


## Contributors

* Nils Jonsson [njonsson](https://github.com/njonsson)
