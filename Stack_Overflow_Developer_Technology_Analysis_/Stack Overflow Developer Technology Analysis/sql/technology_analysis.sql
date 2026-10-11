/*
Stack Overflow Developer Technology Trends Analysis
SQL Server-oriented analytical queries

Assumed normalized tables:
  LanguageTechnology(ResponseId, Technology, Period)
  DatabaseTechnology(ResponseId, Technology, Period)
  PlatformTechnology(ResponseId, Technology, Period)
  WebFrameTechnology(ResponseId, Technology, Period)
  SurveyRespondents(ResponseId, Country, Age, EdLevel, MainBranch)

Period = 'Current' or 'Future'.
Technology rows are created by splitting the survey's semicolon-separated multi-select fields.
*/

-- 1. Top current-use languages
SELECT TOP (10)
    Technology,
    COUNT(*) AS selections
FROM LanguageTechnology
WHERE Period = 'Current'
GROUP BY Technology
ORDER BY selections DESC;

-- 2. Top future-interest languages
SELECT TOP (10)
    Technology,
    COUNT(*) AS selections
FROM LanguageTechnology
WHERE Period = 'Future'
GROUP BY Technology
ORDER BY selections DESC;

-- 3. Current vs future language interest
WITH CurrentUse AS (
    SELECT Technology, COUNT(*) AS CurrentSelections
    FROM LanguageTechnology
    WHERE Period = 'Current'
    GROUP BY Technology
),
FutureInterest AS (
    SELECT Technology, COUNT(*) AS FutureSelections
    FROM LanguageTechnology
    WHERE Period = 'Future'
    GROUP BY Technology
)
SELECT
    COALESCE(c.Technology, f.Technology) AS Technology,
    COALESCE(c.CurrentSelections, 0) AS CurrentSelections,
    COALESCE(f.FutureSelections, 0) AS FutureSelections,
    COALESCE(f.FutureSelections, 0) - COALESCE(c.CurrentSelections, 0) AS ChangeInSelections
FROM CurrentUse AS c
FULL OUTER JOIN FutureInterest AS f
    ON c.Technology = f.Technology
ORDER BY ChangeInSelections DESC;

-- 4. Top databases in current use and future interest
SELECT TOP (10)
    Technology,
    SUM(CASE WHEN Period = 'Current' THEN 1 ELSE 0 END) AS CurrentSelections,
    SUM(CASE WHEN Period = 'Future' THEN 1 ELSE 0 END) AS FutureSelections
FROM DatabaseTechnology
GROUP BY Technology
ORDER BY CurrentSelections DESC;

-- 5. Top platforms by current and future selections
SELECT TOP (10)
    Technology,
    SUM(CASE WHEN Period = 'Current' THEN 1 ELSE 0 END) AS CurrentSelections,
    SUM(CASE WHEN Period = 'Future' THEN 1 ELSE 0 END) AS FutureSelections
FROM PlatformTechnology
GROUP BY Technology
ORDER BY CurrentSelections DESC;

-- 6. Top web frameworks by current and future selections
SELECT TOP (10)
    Technology,
    SUM(CASE WHEN Period = 'Current' THEN 1 ELSE 0 END) AS CurrentSelections,
    SUM(CASE WHEN Period = 'Future' THEN 1 ELSE 0 END) AS FutureSelections
FROM WebFrameTechnology
GROUP BY Technology
ORDER BY CurrentSelections DESC;

-- 7. Respondent distribution by country
SELECT
    Country,
    COUNT(*) AS Respondents
FROM SurveyRespondents
WHERE Country IS NOT NULL
GROUP BY Country
ORDER BY Respondents DESC;

-- 8. Respondent distribution by age group
SELECT
    Age,
    COUNT(*) AS Respondents
FROM SurveyRespondents
WHERE Age IS NOT NULL
GROUP BY Age
ORDER BY Respondents DESC;

-- 9. Respondent distribution by education level
SELECT
    EdLevel,
    COUNT(*) AS Respondents
FROM SurveyRespondents
WHERE EdLevel IS NOT NULL
GROUP BY EdLevel
ORDER BY Respondents DESC;

-- 10. SQL Server: normalize a raw language multi-select column
-- Use this pattern when the raw survey is loaded into SurveyRaw.
-- STRING_SPLIT converts 'JavaScript;Python;SQL' into separate rows.
SELECT
    r.ResponseId,
    LTRIM(RTRIM(s.value)) AS Technology,
    'Current' AS Period
FROM SurveyRaw AS r
CROSS APPLY STRING_SPLIT(r.LanguageHaveWorkedWith, ';') AS s
WHERE r.LanguageHaveWorkedWith IS NOT NULL
  AND LTRIM(RTRIM(s.value)) <> '';

-- 11. Same pattern for future language interest
SELECT
    r.ResponseId,
    LTRIM(RTRIM(s.value)) AS Technology,
    'Future' AS Period
FROM SurveyRaw AS r
CROSS APPLY STRING_SPLIT(r.LanguageWantToWorkWith, ';') AS s
WHERE r.LanguageWantToWorkWith IS NOT NULL
  AND LTRIM(RTRIM(s.value)) <> '';

-- 12. Example analytical query: technologies with the largest increase
-- after normalized Current/Future rows have been loaded.
WITH TechnologyChange AS (
    SELECT
        Technology,
        SUM(CASE WHEN Period = 'Current' THEN 1 ELSE 0 END) AS CurrentSelections,
        SUM(CASE WHEN Period = 'Future' THEN 1 ELSE 0 END) AS FutureSelections
    FROM LanguageTechnology
    GROUP BY Technology
)
SELECT
    Technology,
    CurrentSelections,
    FutureSelections,
    FutureSelections - CurrentSelections AS Increase
FROM TechnologyChange
ORDER BY Increase DESC;
