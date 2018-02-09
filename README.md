### Language: Ruby  
### Database software: SQLite3

### How to run:

1. Run a) `gem install sqlite3` OR b) `bundle install`
2. Run `irb -r "./main.rb"`
3. If you don't have a database, run `require "./database.rb"`. This creates a database called `test.rb`.
4. Run `add_logs_to_database` to add all log files in the log directory.
5. Run `get_uri_counts` to get the counts of each uri for all dates. Results returned in hash and printed.
6. Run `get_top_10_reqtime` to get the top 10 reqtimes for all dates. Results returned in hash and printed.


### Considerations

- I started the transaction with `db.transaction` and committed with `db.commit` manually as this speeds up the process dramatically [link](http://www.sqlite.org/faq.html#q19)[link 2](https://medium.com/@JasonWyatt/squeezing-performance-from-sqlite-insertions-971aff98eef2). Basically the 1-2 mb (~25000 records) files are added almost instantly, while the 10 mb files take less than 10 seconds (~300,000 records).

- Data is printed neatly to the screen so the user can easily read it.

- Since the data will likely be used later, `get_uri_counts` returns a hash in the following form:  
```
{
  "2017-11-02"=>
    {
      "/api/v1/messages"=>13575, 
      "/api/v1/people"=>13494, 
      "/api/v1/textdata"=>13554
    }, 
  "2017-11-01"=>
    {
      "/api/v1/messages"=>7151, 
      "/api/v1/people"=>7116,
      "/api/v1/textdata"=>7211}, 
  ....
} 
```

- Since the data will likely be used later, `get_top_10_reqtime` returns a hash in the following form:
```
{
  "2017-11-02"=>
    [
      5.987124,
      5.987025,
      5.983612,
      5.981602,
      5.978301,
      5.97816,
      5.976514,
      5.97638,
      5.974351,
      5.972653
     ], 
  "2017-11-01"=>
    [
      5.986523,
      5.986125,
      5.985264,
      5.98516,
      5.985034,
      5.984217,
      5.983426,
      5.980432,
      5.974682,
      5.973152
    ], 
  ....
} 
```

### Example 

```
$ irb -r "./main.rb"
2.4.0 :001 > require "./database.rb"
Database created
 => true 
2.4.0 :002 > add_logs_to_database
Adding records for logs/access-20171102.log.gz...
40623 records added.
Adding records for logs/access-20171101.log.gz...
21478 records added.
Adding records for logs/access-20171105.log.gz...
283135 records added.
Adding records for logs/access-20171104.log.gz...
152251 records added.
Adding records for logs/access-20171103.log.gz...
77833 records added.
 => ["logs/access-20171102.log.gz", "logs/access-20171101.log.gz", "logs/access-20171105.log.gz", "logs/access-20171104.log.gz", "logs/access-20171103.log.gz"] 
2.4.0 :003 > get_uri_counts
On 2017-11-02...
Total entries with uri = /api/v1/messages: [13575]
Total entries with uri = /api/v1/people: [13494]
Total entries with uri = /api/v1/textdata: [13554]

On 2017-11-01...
Total entries with uri = /api/v1/messages: [7151]
Total entries with uri = /api/v1/people: [7116]
Total entries with uri = /api/v1/textdata: [7211]

On 2017-11-05...
Total entries with uri = /api/v1/messages: [94843]
Total entries with uri = /api/v1/people: [94234]
Total entries with uri = /api/v1/textdata: [94058]

On 2017-11-04...
Total entries with uri = /api/v1/messages: [51015]
Total entries with uri = /api/v1/people: [50868]
Total entries with uri = /api/v1/textdata: [50368]

On 2017-11-03...
Total entries with uri = /api/v1/messages: [26163]
Total entries with uri = /api/v1/people: [25836]
Total entries with uri = /api/v1/textdata: [25834]

 => {"2017-11-02"=>{"/api/v1/messages"=>13575, "/api/v1/people"=>13494, "/api/v1/textdata"=>13554}, "2017-11-01"=>{"/api/v1/messages"=>7151, "/api/v1/people"=>7116, "/api/v1/textdata"=>7211}, "2017-11-05"=>{"/api/v1/messages"=>94843, "/api/v1/people"=>94234, "/api/v1/textdata"=>94058}, "2017-11-04"=>{"/api/v1/messages"=>51015, "/api/v1/people"=>50868, "/api/v1/textdata"=>50368}, "2017-11-03"=>{"/api/v1/messages"=>26163, "/api/v1/people"=>25836, "/api/v1/textdata"=>25834}} 
2.4.0 :004 > get_top_10_reqtime
Top 10 requtimes on 2017-11-02...
5.987124
5.987025
5.983612
5.981602
5.978301
5.97816
5.976514
5.97638
5.974351
5.972653

Top 10 requtimes on 2017-11-01...
5.986523
5.986125
5.985264
5.98516
5.985034
5.984217
5.983426
5.980432
5.974682
5.973152

Top 10 requtimes on 2017-11-05...
5.987456
5.987145
5.987056
5.986534
5.986453
5.986371
5.986317
5.986153
5.985742
5.985602

Top 10 requtimes on 2017-11-04...
5.98756
5.987261
5.987261
5.98715
5.986502
5.986234
5.985276
5.985124
5.984673
5.984502

Top 10 requtimes on 2017-11-03...
5.987613
5.987532
5.987342
5.987053
5.986314
5.985714
5.985412
5.985064
5.984015
5.983672

 => {"2017-11-02"=>[5.987124, 5.987025, 5.983612, 5.981602, 5.978301, 5.97816, 5.976514, 5.97638, 5.974351, 5.972653], "2017-11-01"=>[5.986523, 5.986125, 5.985264, 5.98516, 5.985034, 5.984217, 5.983426, 5.980432, 5.974682, 5.973152], "2017-11-05"=>[5.987456, 5.987145, 5.987056, 5.986534, 5.986453, 5.986371, 5.986317, 5.986153, 5.985742, 5.985602], "2017-11-04"=>[5.98756, 5.987261, 5.987261, 5.98715, 5.986502, 5.986234, 5.985276, 5.985124, 5.984673, 5.984502], "2017-11-03"=>[5.987613, 5.987532, 5.987342, 5.987053, 5.986314, 5.985714, 5.985412, 5.985064, 5.984015, 5.983672]} 
2.4.0 :005 > 
```