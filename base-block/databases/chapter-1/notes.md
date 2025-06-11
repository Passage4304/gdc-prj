#### PSQL
```sql
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    name VARCHAR(50),
    age INTEGER,
    group_id INTEGER references groups(group_id)
);

CREATE TABLE groups (
    group_id INTEGER PRIMARY KEY,
    group_name VARCHAR(20)
);
```
```sql
create user myuser with password 'password';
create database mydb owner myuser;
create index idx_students_name on students(name);
EXPLAIN SELECT * FROM students WHERE name = 'Alice';
\timing  -- включает отображение времени
SELECT * FROM students WHERE name = 'Alice';
select students.student_id, students.name, students.age, COALESCE(groups.group_name, 'Без группы') AS group_name from students left join groups on students.group_id = groups.group_id;
```