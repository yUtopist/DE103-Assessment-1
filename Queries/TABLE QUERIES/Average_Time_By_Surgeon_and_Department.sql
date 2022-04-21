SELECT
	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
,	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
,	AVG(DATEDIFF(day, refDate, FSA)) AS 'Avarage Time Taken'
FROM Referral m
GROUP BY surgID;

--
-- 
SELECT
	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS depName
,	DATEDIFF(day, refDate, FSA) AS waitedTime
INTO #Temp_Average_Time
FROM Referral m

SELECT
	depName AS 'Department'
,	AVG(waitedTime) AS 'Avarage Time Taken'
FROM #Temp_Average_Time
GROUP BY depName

DROP TABLE #Temp_Average_Time
	

/*
SELECT
	(SELECT depID FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Dep ID'
,	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
,	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
--,	AVG(DATEDIFF(day, refDate, FSA)) AS 'Avarage Time Taken'
FROM Referral m
--GROUP BY depID;
*/

