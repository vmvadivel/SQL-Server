/*

The best product I have seen so far for generating random test records within a SQL Server database is Red Gate's Data Generator software. 
Its feature list is really impressive. It's not a free software but one can get a 14 days trial version to try it out.

If you are looking for a simple script to generate records for a standalone table may be try out the below scripts.

*/

--This view is just a work around to make use of RAND function within a UDF
CREATE VIEW [dbo].[vw_Rand]
AS 
SELECT RAND() AS rnd 
GO

--UDF for Random string Generation

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vadivel Mohanakrishnan
-- URL:		http://vadivel.blogspot.com
-- Create date: Oct 8th, 2011
-- Description:	Function to return random string. 
-- =============================================
CREATE FUNCTION udf_StringGenerator
(
   -- A = only Alphabets,  	
   -- AN = alpha numeric,  	
   -- P = AN + special characters
 	@Type VARCHAR(2),  	
    @MaxLength INT
)
--If @MaxLength > 500 then change the size here as well
RETURNS VARCHAR(500)
AS
BEGIN

    --If @MaxLength > 500 then change the size here as well
	DECLARE @randomString VARCHAR(500)
	
       DECLARE @counter SMALLINT
	DECLARE @Length INT
	DECLARE @strPattern VARCHAR(150)
	DECLARE @isType VARCHAR(2)
	DECLARE @rand REAL

	SET @isType = UPPER(@Type)

	SELECT
	   @strPattern = CASE
		WHEN @isType = 'A' THEN 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
		WHEN @isType = 'P' THEN 'ABCDEFGHIJKLMNOPQRST UVWXYZabcdefghijklmnopqrstuvwxyz0123456789 -=+&$'
		WHEN @isType = 'AN' THEN 'ABCDEFGHIJKLMNOPQRST UVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
	   END

	SET @Length = LEN(@strPattern)
	SET @randomString = ''
	SET @counter = 1

	WHILE @counter <= @MaxLength
	BEGIN
			SET @rand = (SELECT rnd FROM [dbo].[vw_Rand]) 
			SET @randomString = @randomString + SUBSTRING(@strPattern, CONVERT(TINYINT, ((@Length - 1) * @rand + 1)), 1)
			SET @counter = @counter + 1
	END

	RETURN @randomString
END
GO
