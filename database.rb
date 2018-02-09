require "sqlite3"

# Open a database
db = SQLite3::Database.new("test.db")

table = db.execute("CREATE TABLE Access (
    time text,
    id text,
    level text,
    method text,
    uri text,
    reqtime real
  );
")

puts "Database created"





