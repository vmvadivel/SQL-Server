/*
--Query to display Minutes as HH:MM Format
*/

CREATE TABLE #tblTime
(
    timespent VARCHAR(25)
);

INSERT INTO #tblTime VALUES (78);
INSERT INTO #tblTime VALUES (60);
INSERT INTO #tblTime VALUES (1100);


SELECT 
    CAST(TimeSpent/ 60 AS VARCHAR(10)) + ':' + 
    RIGHT('0' + CAST(TimeSpent % 60 AS VARCHAR(2)), 2) AS [HH:MM] 
FROM 
    #tblTime;

--DROP TABLE #tblTime