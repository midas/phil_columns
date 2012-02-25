# Phil Columns

Importing is hard.  Building repeatable and automated import scripts is harder.  Don't Get Me
Started! I have been waiting on a toolset to come to my aid for All of My Life.  Unfotunately,
one has not and I just keep spending Another Day in Paradise.  So today I say, "Enough."  Against
All Odds, I will solve the problem.

If you Can't Turn Back the Tears, then Come With Me and maybe you will find a Groovy Kind of Love
with phil_columns.

## Features

## Installation

## Examples

    # in config/import/angelinatx-cc/commisioners_court_minutes.rb

    convert_files do
      like /^\d+_\d+_\d{4}.tif$/ do |filename|
        into File.dirname( "#{File.basename filename, '.tif'}.pdf" )
      end
    end

    move_files do
      like /^\d+_\d+_\d{4}.tif$/
      to "originals"
    end

    split_pdfs do
      like /^\d+_\d+_\d{4}.pdf$/
      to "$1/$1_#{page_number}.pdf"
    end

    remove_files do
      like /^\d+_\d+_\d{4}.pdf$/
    end

    split_text_files do
      like /^\d+_\d+_\d{4}.txt$/
      at "\f"
      to "$1/$1_#{page_number}.txt"
      guard :has_english_words, :at_least => 5
    end

    move_files do
      like /^\d+_\d+_\d{4}.txt$/
      to "originals"
    end

    import do
      from :directory_structure
      like "**/*.pdf"
      exclude "originals"

      each_directory do
        let /(\d+_\d+_\d{4})_\d+.pdf/, :be => :unformatted_date
        # create CCM

        each_file do
          let :unformatted_date, /(\d+_\d+_\d{4})_\d+.pdf/
          let :page_number,      /\d+_\d+_\d{4}_(\d+).pdf/
          # let /(\d+_\d+_\d{4})_(\d+).pdf/, :be => [:unformatted_date, :page_number]
          expect_equal :file_unformatted_date, :directory_unformatted_date
          parse Date, :unformatted_date, :as => :date, :with => "%m_%d_%Y"
          # create page with attachment
        end
      end
    end

## Known issues

## Contributing

Your patches are welcome, and you will receive attribution here for good stuff.

