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
