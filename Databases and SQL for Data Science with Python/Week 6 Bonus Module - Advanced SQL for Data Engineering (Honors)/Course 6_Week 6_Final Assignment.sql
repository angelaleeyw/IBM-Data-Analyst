-- Exercise 1: Using Joins
-- Question 1 
-- Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98. 
SELECT CPS.NAME_OF_SCHOOL, CD.COMMUNITY_AREA_NAME, CPS.AVERAGE_STUDENT_ATTENDANCE
FROM CHICAGO_PUBLIC_SCHOOLS AS CPS
LEFT OUTER JOIN CENSUS_DATA AS CD ON CPS.COMMUNITY_AREA_NUMBER = CD.COMMUNITY_AREA_NUMBER
WHERE CD.HARDSHIP_INDEX = '98';

-- Question 2 
-- Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.
SELECT CCD.CASE_NUMBER, CCD.PRIMARY_TYPE, CD.COMMUNITY_AREA_NAME
FROM CHICAGO_CRIME_DATA AS CCD
LEFT OUTER JOIN CENSUS_DATA AS CD ON CCD.COMMUNITY_AREA_NUMBER = CD.COMMUNITY_AREA_NUMBER
WHERE CCD.LOCATION_DESCRIPTION LIKE '%SCHOOL%';

-- Exercise 2: Creating a View
-- Question 1
-- Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in the second column.
CREATE VIEW CHICAGO_SCHOOLS (School_Name, Safety_Rating, Family_Rating, Environment_Rating, Instruction_Rating, Leaders_Rating, Teachers_Rating) AS
SELECT NAME_OF_SCHOOL, Safety_Icon, Family_Involvement_Icon, Environment_Icon, Instruction_Icon, Leaders_Icon, Teachers_Icon
FROM CHICAGO_PUBLIC_SCHOOLS;

-- Write and execute a SQL statement that returns all of the columns from the view.
SELECT * FROM CHICAGO_SCHOOLS;

-- Write and execute a SQL statement that returns just the school name and leaders rating from the view.
SELECT School_Name, Leaders_Rating
FROM CHICAGO_SCHOOLS;

-- Exercise 3: Creating a Stored Procedure 
-- Question 1 
-- Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer. Don't forget to use the #SET TERMINATOR statement to use the @ for the CREATE statement terminator. 
DROP PROCEDURE UPDATE_LEADERS_SCORE
--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE ( 
    IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)   

LANGUAGE SQL                                               
MODIFIES SQL DATA                                          

BEGIN 

-- Question 2 
-- Inside your stored procedure, write a SQL statement to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value in the in_Leader_Score parameter.
    UPDATE CHICAGO_PUBLIC_SCHOOLS
    SET LEADERS_SCORE = in_Leader_Score
    WHERE SCHOOL_ID = in_School_ID;

-- Question 3 
-- Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using the following information.
    IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN                          
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'V. weak'
        WHERE SCHOOL_ID = in_School_ID;
    
    ELSEIF in_Leader_Score < 40 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'Weak'
        WHERE SCHOOL_ID = in_School_ID;
        
    ELSEIF in_Leader_Score < 60 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'Avg'
        WHERE SCHOOL_ID = in_School_ID;
        
    ELSEIF in_Leader_Score < 80 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'Strong'
        WHERE SCHOOL_ID = in_School_ID;
        
    ELSEIF in_Leader_Score < 100 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'V. strong'
        WHERE SCHOOL_ID = in_School_ID;

    END IF;                                               
    
END
@                                                                                    

-- Question 4
-- Run your code to create the stored procedure.
-- Write a query to call the stored procedure, passing a valid school ID and a leader score of 50, to check that the procedure works as expected.
CALL UPDATE_LEADERS_SCORE(610038, 50);   

SELECT SCHOOL_ID, LEADERS_SCORE, LEADERS_ICON
FROM CHICAGO_PUBLIC_SCHOOLS
LIMIT 10;

-- Exercise 4: Using Transactions 
DROP PROCEDURE UPDATE_LEADERS_SCORE
--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE ( 
    IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)   

LANGUAGE SQL                                               
MODIFIES SQL DATA                                          

BEGIN 

    UPDATE CHICAGO_PUBLIC_SCHOOLS
    SET LEADERS_SCORE = in_Leader_Score
    WHERE SCHOOL_ID = in_School_ID;

    IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN                          
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'V. weak'
        WHERE SCHOOL_ID = in_School_ID;
    
    ELSEIF in_Leader_Score < 40 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'Weak'
        WHERE SCHOOL_ID = in_School_ID;
        
    ELSEIF in_Leader_Score < 60 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'Avg'
        WHERE SCHOOL_ID = in_School_ID;
        
    ELSEIF in_Leader_Score < 80 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'Strong'
        WHERE SCHOOL_ID = in_School_ID;
        
    ELSEIF in_Leader_Score < 100 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET LEADERS_ICON = 'V. strong'
        WHERE SCHOOL_ID = in_School_ID;

-- Question 1 
-- Update your stored procedure definition. Add a generic ELSE clause to the IF statement that rolls back the current work if the score did not fit any of the preceding categories. 
    ELSE
        ROLLBACK WORK;

    END IF;                                               

-- Question 2 
-- Update your stored procedure definition again. Add a statement to commit the current unit of work at the end of the procedure.     
    COMMIT WORK;
    
END
@                                                                                    
CALL UPDATE_LEADERS_SCORE(610038, 101);   

Select SCHOOL_ID, LEADERS_SCORE, LEADERS_ICON
from CHICAGO_PUBLIC_SCHOOLS 
limit 10;