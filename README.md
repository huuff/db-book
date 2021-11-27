# `db-book`
## Starting the DB
Create the container with

```
sudo nixos-container create db-book --flake .
```

Start it with

```
sudo nixos-container start db-book
```

It'll timeout the first time (has to load the whole dataset), but wait for a while and then you can SSH into it

```
sudo nixos-container root-login db-book
```
