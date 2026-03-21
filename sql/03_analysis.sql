USE student_analysis;

-- ── PASS / FAIL OVERVIEW ──────────────────────────────────────

SELECT
    CASE WHEN G3 >= 10 THEN 'Pass' ELSE 'Fail' END AS result,
    COUNT(*) AS students,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM student_performance), 1) AS percentage
FROM student_performance
GROUP BY result;
-- 130 failed (32.9%), 265 passed (67.1%)
-- almost 1 in 3 students is failing -- that's a significant number


-- ── STUDY TIME ANALYSIS ───────────────────────────────────────

SELECT
    studytime,
    COUNT(*) AS students,
    ROUND(AVG(G3), 2) AS avg_final_grade,
    ROUND(AVG(G1), 2) AS avg_g1,
    ROUND(AVG(G2), 2) AS avg_g2
FROM student_performance
GROUP BY studytime
ORDER BY studytime;
-- most students (198) study only 2-5 hrs/week
-- grades do improve with more study time but not dramatically
-- interestingly studytime 4 (>10hrs) scores slightly less than studytime 3
-- possibly burnout or the weakest students trying hardest to compensate

SELECT
    studytime,
    COUNT(*) AS total,
    SUM(CASE WHEN G3 >= 10 THEN 1 ELSE 0 END) AS passed,
    ROUND(SUM(CASE WHEN G3 >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pass_rate_pct
FROM student_performance
GROUP BY studytime
ORDER BY studytime;
-- pass rate goes from 64.8% at studytime 1 to 75.4% at studytime 3
-- roughly 11% better chance of passing if you study 5-10hrs vs less than 2hrs


-- ── ABSENCES ANALYSIS ─────────────────────────────────────────

SELECT
    CASE WHEN G3 >= 10 THEN 'Pass' ELSE 'Fail' END AS result,
    ROUND(AVG(absences), 2) AS avg_absences,
    MAX(absences) AS max_absences
FROM student_performance
GROUP BY result;
-- failing students average 6.76 absences, passing students average 5.19
-- the max absences for failing students is 75 -- extreme outlier
-- absences alone is not a huge differentiator but combined with other factors it matters

SELECT school, sex, age, absences, failures, G1, G2, G3
FROM student_performance
WHERE absences > 10 AND G3 < 10
ORDER BY absences DESC;
-- these are the highest risk students -- already failing and missing a lot of school
-- G1 and G2 for most of these were already low, so the warning signs were there early


-- ── PARENTAL EDUCATION IMPACT ─────────────────────────────────

-- Medu: 0=none, 1=primary, 2=middle school, 3=secondary, 4=higher education
SELECT
    Medu AS mothers_education,
    COUNT(*) AS students,
    ROUND(AVG(G3), 2) AS avg_grade,
    ROUND(SUM(CASE WHEN G3 >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pass_rate_pct
FROM student_performance
GROUP BY Medu
ORDER BY Medu;
-- clear trend: higher mother's education = higher student grades
-- Medu 1 (primary): 57.6% pass rate vs Medu 4 (higher ed): 74.8%
-- 17% gap in pass rate purely based on mother's education level
-- Medu 0 only has 3 students so ignoring that


-- ── FAILURES IMPACT ───────────────────────────────────────────

SELECT
    failures AS past_failures,
    COUNT(*) AS students,
    ROUND(AVG(G3), 2) AS avg_grade,
    ROUND(SUM(CASE WHEN G3 >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pass_rate_pct
FROM student_performance
GROUP BY failures
ORDER BY failures;
-- this is probably the most striking finding in the whole dataset
-- 0 failures: 75% pass rate, 1 failure: 48%, 2 failures: 17.6%, 3 failures: 25%
-- just one past failure drops the pass rate by almost half
-- if a student has 2+ failures their chances of passing are very slim
-- this variable alone could flag most at-risk students


-- ── ASPIRATION MATTERS ────────────────────────────────────────

SELECT
    higher AS wants_higher_education,
    COUNT(*) AS students,
    ROUND(AVG(G3), 2) AS avg_grade,
    ROUND(SUM(CASE WHEN G3 >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pass_rate_pct
FROM student_performance
GROUP BY higher;
-- students who want higher education: 68.8% pass rate
-- students who don't: only 35% pass rate
-- nearly double the failure rate for students with no academic ambition
-- sample is small (only 20 said no) but the difference is too big to ignore


-- ── INTERNET ACCESS ───────────────────────────────────────────

SELECT
    internet AS has_internet,
    COUNT(*) AS students,
    ROUND(AVG(G3), 2) AS avg_grade
FROM student_performance
GROUP BY internet;
-- students with internet access score 1.2 points higher on average (10.62 vs 9.41)
-- not a huge gap but worth noting -- likely linked to urban/rural divide
-- 66 students have no internet access, mostly rural


-- ── TOP & BOTTOM STUDENTS ─────────────────────────────────────

SELECT age, sex, studytime, absences, failures, G1, G2, G3
FROM student_performance
ORDER BY G3 DESC
LIMIT 10;
-- top students: low absences, 0 past failures, strong G1 and G2
-- no real surprises here -- consistent performers throughout the year

SELECT age, sex, studytime, absences, failures, G1, G2, G3
FROM student_performance
WHERE G3 > 0
ORDER BY G3 ASC
LIMIT 10;
-- bottom students already had weak G1 and G2 scores
-- most have 1 or more past failures and higher absences
-- the decline was visible before the final -- early flagging would have helped

SELECT COUNT(*) AS zero_scorers
FROM student_performance
WHERE G3 = 0;
-- 38 students scored 0 on the final exam -- that's 9.6% of the class
-- likely complete disengagement, not just poor performance
-- these are the most urgent cases for any intervention system