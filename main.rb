require "sqlite3"
require "zlib"

# Add all log files in log dir to the database Access
# e.g. “logs/access-20171101.log.gz”
# If you don't have a database, run: `require './database.rb'` first
def add_logs_to_database 

  # Find all paths of files in logs/
  log_paths = Dir["logs/*.log.gz"]

  # Add each log file to database
  log_paths.each do |log_path|

    puts "Adding records for #{log_path}..."

    # Count how many records will be added
    count = 0

    begin
      # Open database
      db = SQLite3::Database.open("test.db")
      db.transaction

      # Unzip and open the file, reading line by line
      Zlib::GzipReader.open(log_path).each do |line|

        # Add a record to count
        count += 1

        # LTSV => TSV, Remove labels from values
        line.gsub!("reqtime:","")
        line.gsub!("id:","")
        line.gsub!("level:","")
        line.gsub!("method:","")
        line.gsub!("uri:","")
        line.gsub!("time:","")

        # Make an array for database columns
        row = line.split("\t")

        # Insert the row into the database
        db.execute("INSERT INTO Access VALUES (?, ?, ?, ?, ?, ?)", row)
      end
      db.commit

    rescue SQLite3::Exception => e    
      puts "Exception occurred"
      puts e
      db.rollback

    ensure
      db.close if db
    end

    puts "#{count} records added."
  end

end

# Get the count of each uri for all dates in the db
# Results returned in the hash results
def get_uri_counts

  # Open database
  db = SQLite3::Database.open("test.db")

  # Find all unique dates in database
  dates = find_dates(db)

  # Store results in hash
  results = {}
  
  # Iterate through each date to find count
  dates.each do |date|

    # Prepre a nested hash
    results["#{date}"] = {}

    # Header for terminal
    puts "On #{date}..."

    # All uri's
    uris = %w[messages people textdata].map {|i| "/api/v1/#{i}"}

    # Find the count of each uri
    uris.each do |uri|
      db.execute("SELECT COUNT(*) FROM Access WHERE uri = \"#{uri}\" AND time LIKE \"#{date} __:__:__\"") do |result|
        results["#{date}"]["#{uri}"] = result[0]
        puts "Total entries with uri = #{uri}: #{result}"
      end
    end
    puts "\n"
  end

  results
end


# Find the top 10 longest reqtimes for every date in the db
# Results returned in the hash results
def get_top_10_reqtime
  # Open database
  db = SQLite3::Database.open("test.db")

  # Find all unique dates in database
  dates = find_dates(db)

  # Store results in hash
  results = {}
  
  # Iterate through each date to find count
  dates.each do |date|

    # Prepre a nested hash
    results["#{date}"] = []

    # Header for terminal
    puts "Top 10 requtimes on #{date}..."

    # Find the top 10 longest reqtimes
    result = db.execute("SELECT * FROM Access WHERE time LIKE \"#{date} __:__:__\" ORDER BY reqtime DESC LIMIT 10")

    # Save to results and print
    result.each_with_index do |array, i|
      results["#{date}"][i] = array[5]
      puts array[5]
    end

    puts "\n"
  end

  results
end


def find_dates(db)
  # Find all unique dates in database
  dates = []
  db.execute("SELECT DISTINCT date(time) FROM Access") do |result|
    dates << result[0]
  end

  dates 
end


