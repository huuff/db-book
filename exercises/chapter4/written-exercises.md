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

## 4.5
### a)
The specification of the query asked to retrieve the courses each instructor taught.

One example could be

#### Instructor
id|name|dept_name|salary
--|----|---------|------
1 |mike|History  |1

#### Course
course_id|title|dept_name|credits
---------|-----|---------|-------
1        |C1   |History  |1
2        |C2   |Robotics |1

#### Teaches
id|course_id|sec_id|semester|year
--|---------|------|--------|----
1 |1        |1     |'Spring'|2021
1 |2        |1     |'Spring'|2021

#### The join
id|name|dept_name|salary|course_id|title|credits|sec_id|semester|year
--|----|---------|------|---------|-----|-------|------|--------|----
1 |mike|History  |1     |1        |C1   |1      |1     |'Spring'|2021

Thus, the query doesn't show that Mike also teaches Robotics because it isn't a course from his department

### b)
I guess it's so that we can test that outer joins work correctly. If there is a row in `takes` for every course and student,

```sql
SELECT * FROM student
  JOIN takes ON takes.id = student.id
  JOIN course ON takes.course_id = course.course_id
```

Gives the same result as 

```sql
SELECT * FROM student
  LEFT OUTER JOIN takes ON takes.id = student.id
  JOIN course ON takes.course_id = course.course_id
```

Or

```sql
SELECT * FROM student
  JOIN takes ON takes.id = student.id
  RIGHT OUTER JOIN course ON takes.course_id = course.course_id
```

Se we have no way to test that our queries that retrieve all students with the courses they take (and still show the students that take no courses) work.

### c)
Isn't this literaly the exact same question as in the previous one?

## 4.9
When deleting a tuple, the tuple that references it is removed also, and also those that reference it, and thus until there are no more tuples in the chain. Just like the `REVOKE` example.
