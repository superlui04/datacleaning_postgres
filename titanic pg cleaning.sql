--create passenger table db
CREATE TABLE passengers (
    PassengerId INTEGER PRIMARY KEY,
    Survived INTEGER,
    Pclass INTEGER,
    Name VARCHAR(255),
    Sex VARCHAR(10),
    Age INTEGER,
    SibSp INTEGER,
    Parch INTEGER,
    Ticket VARCHAR(255),
    Fare NUMERIC(10,2),
    Cabin VARCHAR(255),
    Embarked VARCHAR(10)
);

--change age dtype to float
ALTER TABLE passengers ALTER COLUMN Age TYPE FLOAT;

--import values from csv

COPY passengers (PassengerId, Survived, Pclass, Name, Sex, Age, SibSp, Parch, Ticket, Fare, Cabin, Embarked)
FROM '/Users/ang_k/OneDrive/Desktop/sparta 2023/wk 4 task/titanic.csv'
DELIMITER ','
CSV HEADER;



CREATE TABLE passenger_cleaned AS
SELECT
    PassengerId,
    Survived,
    Pclass,
    Name,
    Sex,
    Age,
    SibSp,
    Parch,
    Ticket,
    Fare,
    Cabin,
    Embarked,
    COALESCE(Age, 29.7) AS AgeCleaned,
    COALESCE(Cabin, 'Not Specified') AS CabinCleaned,
    CASE
        WHEN Sex IN ('f', 'female', 'Female') THEN 'Female'
        WHEN Sex IN ('male', 'm', ' Male ') THEN 'Male'
        ELSE TRIM(Sex)
    END AS genderCleaned,
    TRIM(BOTH ' ' FROM SUBSTRING(Name, 1, CASE WHEN POSITION(',' IN Name) > 0 THEN POSITION(',' IN Name) - 1 ELSE LENGTH(Name) END)) AS Last_Name,
    CASE
        WHEN POSITION('Mr.' IN Name) > 0 THEN 'Mr.'
        WHEN POSITION('Mrs.' IN Name) > 0 THEN 'Mrs.'
        WHEN POSITION('Miss.' IN Name) > 0 THEN 'Miss.'
        WHEN POSITION('Mme.' IN Name) > 0 THEN 'Mme.'
        WHEN POSITION('Cap.' IN Name) > 0 THEN 'Cap.'
        WHEN POSITION('Rev.' IN Name) > 0 THEN 'Rev.'
        WHEN POSITION('Major' IN Name) > 0 THEN 'Major'
        WHEN POSITION('Countess.' IN Name) > 0 THEN 'Countess.'
        WHEN POSITION('Mlle.' IN Name) > 0 THEN 'Mlle.'
        WHEN POSITION('Col.' IN Name) > 0 THEN 'Col.'
        WHEN POSITION('Master.' IN Name) > 0 THEN 'Master.'
        WHEN POSITION('Dr.' IN Name) > 0 THEN 'Dr.'
        WHEN POSITION('Don.' IN Name) > 0 THEN 'Don.'
        ELSE ''
    END AS Title,
    CASE
        WHEN POSITION('.' IN Name) > 0 THEN SUBSTRING(Name, POSITION('.' IN Name) + 1, LENGTH(Name))
        ELSE Name
    END AS First_Name
FROM passengers;

