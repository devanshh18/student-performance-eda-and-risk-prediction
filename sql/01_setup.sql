create database if not exists student_analysis;
use student_analysis;

CREATE TABLE student_performance (
    school          VARCHAR(5),
    sex             VARCHAR(1),
    age             INT,
    address         VARCHAR(1),
    famsize         VARCHAR(5),
    Pstatus         VARCHAR(1),
    Medu            INT,
    Fedu            INT,
    Mjob            VARCHAR(20),
    Fjob            VARCHAR(20),
    reason          VARCHAR(20),
    guardian        VARCHAR(10),
    traveltime      INT,
    studytime       INT,
    failures        INT,
    schoolsup       VARCHAR(3),
    famsup          VARCHAR(3),
    paid            VARCHAR(3),
    activities      VARCHAR(3),
    nursery         VARCHAR(3),
    higher          VARCHAR(3),
    internet        VARCHAR(3),
    romantic        VARCHAR(3),
    famrel          INT,
    freetime        INT,
    goout           INT,
    Dalc            INT,
    Walc            INT,
    health          INT,
    absences        INT,
    G1              INT,
    G2              INT,
    G3              INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/student-mat.csv'
INTO TABLE student_performance
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM student_performance;