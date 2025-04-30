-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <30-Apr-2025>
-- Description:	<How to create a function, Standard Template for building a function>
-- =============================================
CREATE FUNCTION GregorianToPersian
(
	-- Add the parameters for the function here
	@dateValue DATETIME	
)
RETURNS NVARCHAR(25)
AS
BEGIN
	-- Declare the return variable here
	DECLARE  @Date_P NVARCHAR(25)

	-- Add the T-SQL statements to compute the return value here

	DECLARE @Year_G SMALLINT = 0;
	DECLARE @Month_G SMALLINT = 0;
	DECLARE @Day_G SMALLINT = 0;
	DECLARE @Week_G SMALLINT = 0;
	DECLARE @Year_P SMALLINT = 0;
	DECLARE @Month_P SMALLINT = 0;
	DECLARE @Day_P SMALLINT = 0;

	DECLARE @Sum_G SMALLINT = 0; -- Total days of the Gregorian months since the beginning of the year
	DECLARE @Sum_P SMALLINT = 0; -- Total days of the Jalali months since the beginning of the year

	DECLARE @b SMALLINT = 0;

	SET @dateValue = GETDATE();
	SET @Year_G = YEAR(@dateValue);
	SET @Month_G = MONTH(@dateValue);
	SET @Day_G = DAY(@dateValue);	

	DECLARE @i SMALLINT = 0;
	DECLARE @ND SMALLINT;
	WHILE (@i < @Month_G - 1)
	BEGIN  
	   SET @ND = (CASE 
				  WHEN @i = 0 OR @i = 2 OR @i = 4 OR @i = 6 OR @i = 7 OR @i = 9 OR @i = 11 THEN 31
				  WHEN @i = 3 OR @i = 5 OR @i = 8 OR @i = 10 THEN 30
				  WHEN @i = 1 THEN  28
				  END);
	   SET @Sum_G = @Sum_G + @ND;
	   SET @i = @i + 1;
	END

	IF ((@Year_G % 4) = 0 AND @Sum_G >= 59) 
	        SET  @Sum_G = @Sum_G + @Day_G + 1;
	ELSE    SET  @Sum_G = @Sum_G + @Day_G;
	
	SET @Sum_P = @Sum_G - 79;

	IF ((@Year_G - 1) % 4 = 0 AND @Sum_P = 0) SET @b = 1;

	IF ((@Year_G - 1) % 4 = 0 AND @Sum_P < 0) SET @Sum_P = @Sum_P + 1;

	IF (@Sum_P <= 0)  SET @Year_P = @Year_G - 622;
			  ELSE    SET @Year_P = @Year_G - 621;

	IF (@Sum_P <= 0) SET @Sum_P = @Sum_P + 365;

	IF (@b = 1) SET @Sum_P = @Sum_P + 1;

	IF (@Sum_P <= 186)
	BEGIN
	   SET @Month_P = FLOOR(@Sum_P / 31);
	   SET @Day_P = @Sum_P % 31;
		IF (@Day_P = 0) SET @Day_P = 31;
			ELSE        SET @Month_P = @Month_P + 1;
	END
	ELSE
	BEGIN
		SET @Sum_P = @Sum_P - 186;
		SET @Month_P = FLOOR(@Sum_P / 30);
        SET @Day_P = @Sum_P % 30;

        IF (@Day_P = 0) SET @Day_P = 30;        
        ELSE            SET  @Month_P = @Month_P+1;
        
        SET @Sum_P = @Sum_P - 186;
        SET @Month_P = @Month_P + 6;
	END

    SET @Date_P = CAST(@Year_P AS VARCHAR)+'/'+CAST (@Month_P AS VARCHAR)+'/'+CAST (@Day_P AS VARCHAR);

	-- Return the result of the function
	RETURN  @Date_P

END
GO

