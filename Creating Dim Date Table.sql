CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,                   -- YYYYMMDD format (Gregorian calendar)
    [Full Date] DATE,                             -- Standard Gregorian calendar date
    DayNameOfWeek NVARCHAR(20),                -- Name of the day (e.g., Monday, Tuesday)
    NoOfTheDayPerWeek TINYINT,                 -- Day of the week number (1-7)
    IsWorkingDay BIT,                          -- 0 for working day, 1 for holiday
    [DayNo] TINYINT,                     -- Gregorian day of the month
    LastDayMonth TINYINT,                     -- Indicator for the last day of the Gregorian month
    DayPerWeek TINYINT,                       -- Gregorian day number within the week
    [DayOfYear] INT,                            -- Day number within the Gregorian year
    [WeekNo] TINYINT,                    -- Gregorian week number
	YearMonthweekKey INT,					-- Year, month and week in Gregorian calendar (e.g., YYYYMMWW)
    WeekOfYear TINYINT,                       -- Week number within the Gregorian year
    MonthNo TINYINT,                   -- Gregorian month number
    [MonthName] NVARCHAR(20),                   -- Gregorian month name
    YearNo INT,                        -- Gregorian year number
    YearMonthKey INT,                         -- Year and month in Gregorian calendar (YYYYMM)
    YearMonthDayKey INT,                       -- Year, month, and day in Gregorian calendar (YYYYMMDD)
    QuarterPerYear TINYINT                    -- Gregorian quarter (1-4)
);


    DECLARE @DateFirstParam INT = 6
    IF @DateFirstParam IS NOT NULL
      SET DATEFIRST @DateFirstParam

; WITH DateRange AS (
    SELECT CAST('2010-01-01' AS DATE) AS FullDate  -- Start date
    UNION ALL
    SELECT DATEADD(DAY, 1, FullDate)               -- Add 1 day to the date
    FROM DateRange
    WHERE FullDate < '2030-12-31'                  -- End date
) 
, DateDimension AS (
SELECT
 Z.DateKey
,Z.FullDate
,Z.NoOfTheDayPerWeek
,Z.IsWorkingDay
,DATENAME(DW,Z.FullDate) AS DayNameOfWeek
,Z.[Day Style 2]
,CASE 
	WHEN Z.[Day Style 2] = 1 THEN 0
	WHEN MONTH(Z.FullDate) = MONTH(DATEADD(D, 1, Z.FullDate)) THEN 2
    ELSE 1 END AS LastDayMonth2
,ROW_NUMBER() OVER (PARTITION BY Z.[Year Style 2],Z.[Month Style 2],Z.[Week Style 2] ORDER BY Z.[Year Style 2],Z.[Month Style 2],Z.[Week Style 2]) AS DayPerWeek2
,Z.DayOfYear2
,Z.[Week Style 2] 
,(Z.YearMonthKey2 * 100) + Z.[Week Style 2] AS YearMonthWeekKey2
,DENSE_RANK() OVER(PARTITION BY Z.[Year Style 2] ORDER BY (Z.YearMonthKey2 * 100) + Z.[Week Style 2]) AS WeekOfYear2
,Z.[Month Style 2]
,DATENAME(MM,Z.FullDate) AS MonthName2 
,Z.[Year Style 2]
,Z.FullDate AS FullDate2
,Z.YearMonthKey2
,Z.YearMontDayKey2
,Z.QuarterPerYear2
FROM
(
SELECT
 Y.DateKey
,Y.NoOfTheDayPerWeek
,Y.IsWorkingDay
,Y.[Day Style 2] 
,DATENAME(DY, Y.FullDate) AS DayOfYear2
,CASE
    WHEN (Y.[Day Style 2] - 1) / 7 + 1 = 5 AND Y.[Day Style 2] % 7 != 0 THEN 4
    ELSE (Y.[Day Style 2] - 1) / 7 + 1
END AS [Week Style 2]
,Y.[Month Style 2]
,Y.[Year Style 2]
,Y.FullDate
,Y.YearMonthKey2
,Y.YearMontDayKey2
,DATENAME(QQ,Y.FullDate) QuarterPerYear2
FROM
(
SELECT
 X.FullDate
,X.DateKey
,X.NoOfTheDayPerWeek
,X.IsWorkingDay
,X.[Day Style 2]
,X.[Month Style 2]
,X.[Year Style 2]
,CAST(X.[Year Style 2] AS CHAR(4)) + RIGHT('00' + RTRIM(CAST(X.[Month Style 2] AS CHAR(2))),2) AS YearMonthKey2
,CAST(X.[Year Style 2] AS CHAR(4)) + RIGHT('00' + RTRIM(CAST(X.[Month Style 2] AS CHAR(2))),2) + RIGHT('00' + RTRIM(CAST(X.[Day Style 2] AS CHAR(2))),2)AS YearMontDayKey2
FROM
(
SELECT 
M.FullDate
,(YEAR(M.FullDate) * 10000 ) + (MONTH(M.FullDate) * 100) + (DAY(M.FullDate)) AS DateKey
,DATEPART(WEEKDAY,M.FullDate) NoOfTheDayPerWeek,
CASE 
    WHEN DATEPART(WEEKDAY,M.FullDate) = 7 THEN 1 -- الجمعة إجازة (7 = الجمعة)
    ELSE 0 -- باقي الأيام هي أيام عمل
END AS [IsWorkingDay]
 ,DAY(M.FullDate) AS [Day Style 2]
 ,MONTH(M.FullDate) AS [Month Style 2]
 ,YEAR(M.FullDate) AS [Year Style 2]
 FROM
 DateRange M
 ) X
 ) Y
 ) Z
 )

INSERT INTO DimDate
SELECT
 D.DateKey
,D.FullDate
,D.DayNameOfWeek
,D.NoOfTheDayPerWeek
,D.IsWorkingDay
,D.[Day Style 2]
,D.LastDayMonth2
,D.DayPerWeek2
,D.DayOfYear2
,D.[Week Style 2]
,D.YearMonthWeekKey2
,D.WeekOfYear2
,D.[Month Style 2]
,D.MonthName2
,D.[Year Style 2]
,D.YearMonthKey2
,D.YearMontDayKey2
,D.QuarterPerYear2
FROM
DateDimension D

OPTION (MAXRECURSION 0);
