use student_analysis;

-- How many total students ? 
select count(*) as total_students from student_performance;

-- Grade distribution
select G3, count(*) as num_students from student_performance group by G3 order by G3;

-- checking null values
select sum(case when G3 is null then 1 else 0 end) as null_G3,
	sum(case when absences is null then 1 else 0 end) as null_absences,
    sum(case when studytime is null then 1 else 0 end) as null_studytime
from student_performance;

-- basic stats on final grade
select 
	min(G3) as min_grade,
	max(G3) as max_grade,
	round(avg(G3), 2) as avg_grade,
	round(stddev(G3), 2) as stddev_grade
from student_performance;

-- gender split
select sex, count(*) as count
from student_performance
group by sex;

-- urban vs rural
select address, count(*) as count
from student_performance
group by address;

-- school split
select school, count(*) as count
from student_performance
group by school;