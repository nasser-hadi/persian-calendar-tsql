
DECLARE @dateValue VARCHAR(50);
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
--SET @Week_G =
PRINT (@dateValue)

-- This line is JS code.
-- const ND = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
--SET @ND = 31; -- Number of days in January , The first month of the Gregorian calendar.

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

  IF ((@Year_G % 4) = 0 
     AND @Sum_G >= 59) SET  @Sum_G = @Sum_G + @Day_G + 1;
              ELSE     SET  @Sum_G = @Sum_G + @Day_G;
    
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
        IF (@Day_P = 0) 
            SET @Day_P = 30;
        
        ELSE 
           SET  @Month_P = @Month_P+1;
        
        SET @Sum_P = @Sum_P - 186;
        SET @Month_P = @Month_P + 6;
    END

  PRINT (CAST(@Year_P AS VARCHAR)+'/'+CAST (@Month_P AS VARCHAR)+'/'+CAST (@Day_P AS VARCHAR));
