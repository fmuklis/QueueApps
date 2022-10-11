-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[generate_roman]
(
	-- Add the parameters for the function here
	@number int
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	-- Add the T-SQL statements to compute the return value here
	-- Return the result of the function
	RETURN REPLICATE('M', @number/1000)
            + REPLACE(REPLACE(REPLACE(
                  Replicate('C', @number%1000/100),
                  Replicate('C', 9), 'CM'),
                  Replicate('C', 5), 'D'),
                  Replicate('C', 4), 'CD')
             + REPLACE(REPLACE(REPLACE(
                  Replicate('X', @number%100 / 10),
                  Replicate('X', 9),'XC'),
                  Replicate('X', 5), 'L'),
                  Replicate('X', 4), 'XL')
             + REPLACE(REPLACE(REPLACE(
                  Replicate('I', @number%10),
                  Replicate('I', 9),'IX'),
                  Replicate('I', 5), 'V'),
                  Replicate('I', 4),'IV')
END