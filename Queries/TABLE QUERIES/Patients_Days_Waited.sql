--
--	This query will give a list of all the patients, that have been seen by the surgeon and the time it took for waiting, sorted by surgeon.
SELECT
	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
,	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
,	(SELECT patName FROM Patient t WHERE t.patNHI = m.patNHI) AS 'Patient Name'
,	DATEDIFF(day, refDate, FSA) AS 'Days Waited'
FROM Referral m
WHERE DATEDIFF(day, refDate, FSA) IS NOT NULL
AND eligible = 1
ORDER BY surgID

--
--	This query will give a list of all the patients, that are still waiting to be seen by surgeon time they have been waiting, sorted by surgeon.
SELECT
	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
,	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
,	(SELECT patName FROM Patient t WHERE t.patNHI = m.patNHI) AS 'Patient Name'
,	FORMAT(refDate, 'dd/MM/yyyy') AS 'Referral Date'
,	DATEDIFF(day, refDate, CAST( GETDATE() AS Date )) AS 'Days Been Waiting'
FROM Referral m
WHERE DATEDIFF(day, refDate, FSA) IS NULL
AND eligible = 1
ORDER BY surgID