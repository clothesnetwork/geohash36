
Q: Why do you have a Gemfile and a gemspec if this is a gem?
A: For local development its quite convenient to have a Gemfile and Gemfile.lock, but once done for
   publishing etc. you just need the gemspec. This kind of hybrid approach is a bit unorthodox but
   useful. Once the software is mature its ok to remove gemfile, lock file, and other pinnings since
   your gem is supposed to run everywhere.

Q: How is this different from Geohash 32?
A: Geohash 36 utilizes radix 36 format, which allows a slightly better precision then geohash 32
   radix format. Also, the entire purpose is for machine readability in urls not human readability.

