--
--	This query will give a list of departments and percentage of patient were seen within the target of 75 days of that department.

--
--	If this is the first query to run, we need to use the correct Database with this command.
--	USE SysmexReferralDB;

--	Creating temprory table here:
SELECT
	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS depName
,	DATEDIFF(day, refDate, FSA) AS waitedTime
INTO #Temp_Average_Time
FROM Referral m
WHERE eligible = 1
GO
--
--	Drawing a list
SELECT
	m.depName
,	CONCAT(CAST((CAST(m.testOne AS FLOAT) / CAST(s.testTwo AS FLOAT) * 100) AS DECIMAL(4,1)), '%') AS 'Target met by (patients)'
FROM
	(SELECT depName, COUNT(waitedTime) AS testOne FROM #Temp_Average_Time WHERE waitedTime <= 75 GROUP BY depName) m
LEFT JOIN
	(SELECT depName, COUNT(*) AS testTwo FROM #Temp_Average_Time GROUP BY depName) s
ON m.depName = s.depName
--
--	Deleting temprory table
DROP TABLE #Temp_Average_Time;