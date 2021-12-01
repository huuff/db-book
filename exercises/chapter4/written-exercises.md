# Written exercises for chapter 4

## 4.1
It also joins on `instructor.dept_name = course.dept_name`, therefore it only shows courses for each instructor where the course is of the same department as the instructor.

## 4.4
### a)
r|A|B
-|-|-
 |1|1
 |2|2

s|B|C
-|-|-
 |3|7
 |8|4

t|B|D
-|-|-
 |1|1
 |2|2

 `r natural left outer join s`|A|B|C
 -----------------------------|-|-|-
                              |1|1|X
                              |2|2|X

 `(r natural left outer join s) natural left outer join t`|A|B|C|D
 ---------------------------------------------------------|-|-|-|-
                                                          |1|1|X|1
                                                          |2|2|X|2

### b)
Since it's a `left outer join`, the innermost join ALWAYS has a value for `C` because it's on the left side. This value will get carried over to any subsequent join (if there are matches).  

In the given case, if there are no matches, then `C` and `D` are null. Therefore the only possibilities are:

* `C` nonnull
* Both `C` and `D` null

So no, it's not possible.
