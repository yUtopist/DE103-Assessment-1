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
SELECT m.depName, CAST(m.testOne AS FLOAT) / CAST(s.testTwo AS FLOAT) * 100 AS 'testing'
FROM
	(SELECT depName, COUNT(waitedTime) AS testOne FROM #Temp_Average_Time WHERE waitedTime <= 75 GROUP BY depName) m
LEFT JOIN
	(SELECT depName, COUNT(*) AS testTwo FROM #Temp_Average_Time GROUP BY depName) s
ON m.depName = s.depName

--
--	Deleting temprory table
DROP TABLE #Temp_Average_Time;