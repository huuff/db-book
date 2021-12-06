# Written exercises for Chapter 5

## 5.1
Prints all `mnames` that are in a tuple with an `ename` of `dog`

## 5.4
I guess in the case I needed to write a really hard query, maybe needed to get any extra possible performance out of it. Doing it in a programming language would be unsuitable due to the costs of communicating with the server.

## 5.10
If
```sql
  group by rollup(item_name, color, clothes_size)i;
```

Does `{ (item_name, color, clothes_size), (color, clothes_size), (clothes_size), () }`

Then an `UNION` with a `group by rollup(clothes_size, color, item_name)` does

`{ (item_name, color, clothes_size), (color, clothes_size), (clothes_size),  (item_name), () }`

Add `group by rollup(color, item_name, clothes_size)` to get

`{ (item_name, color, clothes_size), (color, clothes_size), (clothes_size),  (item_name), 
  (item_name, clothes_size), 
() }`

And so on and so forth for every possible combination.
