--
--	This query will give two lists, the first one is a list of average time taken to see a surgeon in days and the second one is a the same list but by department.

--
--	If this is the first query to run, we need to use the correct Database with this command.
--	USE SysmexReferralDB;

SELECT
	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
,	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
,	AVG(DATEDIFF(day, refDate, FSA)) AS 'Avarage Time Taken'
FROM Referral m
WHERE eligible = 1
GROUP BY surgID;

--	In this solution I made a temprory table called #Temp_Average_Time and inserted needed Data into it, which is
--	only a Department name and Days taken to see a patient by surgeon on each referral.
--
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
	depName AS 'Department'
,	AVG(waitedTime) AS 'Avarage Time Taken'
FROM #Temp_Average_Time
GROUP BY depName
--
--	Deleting temprory table
DROP TABLE #Temp_Average_Time