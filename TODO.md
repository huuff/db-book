# Tasks
* At [the official page](https://www.db-book.com/university-lab-dir/sample_tables-dir/index.html), they offer the java program they use to generate random data. Crazy idea: Instead of putting the large dataset they provide:
  * Use nix to generate a `tableGen.java` using a multiplicative coefficient for every max to create larger datasets
  * Compile it
  * It uses some files with lists of names of buildings, departments and people to fill the database, use something like [this](https://github.com/lolPants/markov) to generate these randomly from some basic ones I download or write.
  * Then feed these into the DB
  * Arguably a lot of work but I really want to test performance of different queries and I fear the given dataset is not big enough
* Use my `mkInitModule` because the whole systemd unit is too verbose
