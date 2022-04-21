--
--	If this is the first query to run, we need to use the correct Database with this command
--	USE SysmexReferralDB;

SELECT
	--	Date information
	FORMAT(refDate, 'dd/MM/yyyy') AS 'Referral Date'
,	FORMAT(refDate, 'yyyy-M') AS 'Year-Month'
	--	Referrer information
,	(SELECT refName FROM Referrer t WHERE t.refID = m.refID) AS 'Referred By'
,	(SELECT refType FROM Referrer t WHERE t.refID = m.refID) AS 'Referred From'
	--	Patient information
,	patNHI AS 'NHI'
,	(SELECT patName FROM Patient t WHERE t.patNHI = m.patNHI) AS 'Patient Name'
,	CASE
		WHEN (SELECT patGender FROM Patient t WHERE t.patNHI = m.patNHI) = 'M' THEN 'Male'
		WHEN (SELECT patGender FROM Patient t WHERE t.patNHI = m.patNHI) = 'F' THEN 'Female'
		WHEN (SELECT patGender FROM Patient t WHERE t.patNHI = m.patNHI) = 'O' THEN 'Other'	END AS 'Gender'
,	FORMAT((SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI), 'dd/MM/yyyy') AS 'DOB'
,	DATEDIFF(year, (SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI), refDate) AS 'Age at Referral'
	--	Surgeon information
,	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
,	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
	--	Technicalities
,	FORMAT(waitListDate, 'dd/MM/yyyy') AS 'Added to Waitlist Date'
,	FORMAT(FSA, 'dd/MM/yyyy') AS 'FSA Date'
,	DATEDIFF(day, refDate, FSA) AS 'Days Waited'
,	CASE
		WHEN eligible = '1' THEN 'Yes'
		WHEN eligible = '0' THEN 'No' END AS 'Health Target Eligible'
FROM Referral m
ORDER BY surgID;

/*
--
--	Checking if all of the patients have acceptable DOB values with the next ORDER BY command
ORDER BY (SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI)

--	Patient Graeme Fenemore with NHI MFO6152 had DOB year set to 1756
--	My best assumption that the year is supposed to be 1956 but in the same time surgeon, assigned to this refarral
--	is from Paediatric Surgery, and patient has to be under age of 18 to be assigned to that department, so there is
--	probably a mistake made there too. In this case I am going to leave Department and Surgeon as they were and
--	change year to 1956, but I also add this patient entry to a error list, to make someone look it up and update the
--	information on this patient.
UPDATE Patient
SET patDOB = '1956-07-06'
WHERE patNHI = 'MFO6152';
GO

--	Patient Karen Reid with NHI YBB1095 had DOB year set to one year ahead from the day of referral
--	My assumption is that instead of 2016, year of birth should be 2006, which i am going to change too but also
--	going to add this entry to an error list.
UPDATE Patient
SET patDOB = '2006-01-06'
WHERE patNHI = 'YBB1095';
GO

--	Patient Wandis Clipson with NHI BAK4481 had DOB year set twelve years ahead from the day of referral
--	My assumption is that instead of 2017, year of birth should be 2007, which i am going to change too but also
--	going to add this entry to an error list.
UPDATE Patient
SET patDOB = '2007-12-10'
WHERE patNHI = 'BAK4481';
GO
*/

/*
--
--	Checking if all of the patients under 18 are assigned to paediatric surgeon
--	Since we can not just give those patients a random paediatric sergeon, we just going to create a query for all of
--	them to have a list, and then have someone to go through and reasign patients.
--
--	This Query is saved in a separate query file '!Underage-patients-to-reassign'
WHERE DATEDIFF(year, (SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI), refDate) < 18
AND (SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) != 'Paediatric Surgery'
ORDER BY 'Age at Referral';
*/
