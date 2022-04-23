SELECT
--	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
,	DATEDIFF(day, refDate, FSA) AS 'Days Waited'
FROM Referral m
--WHERE eligible = 1
WHERE COUNT(DATEDIFF(day, refDate, FSA)) = 75
--GROUP BY surgID
