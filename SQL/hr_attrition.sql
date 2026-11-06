-- Data checks

SELECT COUNT(*) AS employee_count
FROM hr_attrition_indian_dataset;

DESCRIBE hr_attrition_indian_dataset;

SELECT *
FROM hr_attrition_indian_dataset
LIMIT 10;

SELECT 
    LeftCompany, 
    COUNT(*) AS Row_Count
FROM hr_attrition_indian_dataset 
GROUP BY LeftCompany;



-- Check NULLs

SELECT
    COUNT(*) AS total_rows,
    SUM(EmployeeID IS NULL) AS missing_employee_id,
    SUM(FullName IS NULL) AS missing_full_name,
    SUM(Age IS NULL) AS missing_age,
    SUM(Gender IS NULL) AS missing_gender,
    SUM(Department IS NULL) AS missing_department,
    SUM(Designation IS NULL) AS missing_designation,
    SUM(EducationQualification IS NULL) AS missing_education,
    SUM(MonthlySalary IS NULL) AS missing_monthly_salary,
    SUM(DateOfJoining IS NULL) AS missing_joining_date,
    SUM(YearsWithCompany IS NULL) AS missing_years_with_company,
    SUM(YearsInRole IS NULL) AS missing_years_in_role,
    SUM(AppraisalRating IS NULL) AS missing_appraisal_rating,
    SUM(TrainingHours IS NULL) AS missing_training_hours,
    SUM(DoesOvertime IS NULL) AS missing_overtime,
    SUM(JobSatisfaction IS NULL) AS missing_job_satisfaction,
    SUM(WorkLifeBalance IS NULL) AS missing_work_life_balance,
    SUM(MaritalStatus IS NULL) AS missing_marital_status,
    SUM(PreviousCompanies IS NULL) AS missing_previous_companies,
    SUM(DistanceFromHome IS NULL) AS missing_distance_from_home,
    SUM(LeavesTaken IS NULL) AS missing_leaves_taken,
    SUM(City IS NULL) AS missing_city,
    SUM(LeftCompany IS NULL) AS missing_left_company
FROM hr_attrition_indian_dataset;



-- Check Duplicate EmployeeIDs

SELECT
    EmployeeID,
    COUNT(*) AS duplicate_count
FROM hr_attrition_indian_dataset
GROUP BY EmployeeID
HAVING COUNT(*) > 1;



-- Attrition by Department

SELECT 
    Department, 
    COUNT(*) AS Total_Employees,
    COUNT(
        CASE 
            WHEN LeftCompany = 'Yes'
            THEN 1 
        END
    ) AS Left_Count,
    COUNT(
        CASE
            WHEN LeftCompany = 'No'
            THEN 1 
        END
    ) AS Stayed_Count,
    ROUND(
        100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*), 2
    ) AS Attrition_Rate
FROM hr_attrition_indian_dataset
GROUP BY Department
ORDER BY Attrition_Rate DESC;



-- Attrition by Designation

SELECT 
    Designation, 
    COUNT(*) AS Total_Employees,
    COUNT(
        CASE 
            WHEN LeftCompany = 'Yes'
            THEN 1 
        END
    ) AS Left_Count,
    COUNT(
        CASE
            WHEN LeftCompany = 'No'
            THEN 1 
        END
    ) AS Stayed_Count,
    ROUND(
        100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*), 2
    ) AS Attrition_Rate
FROM hr_attrition_indian_dataset
GROUP BY Designation
ORDER BY Attrition_Rate DESC;




-- Department vs Designation

SELECT 
    Department, 
    Designation, 
    COUNT(*) AS Total_Employees,
    COUNT(
        CASE 
            WHEN LeftCompany = 'Yes'
            THEN 1 
        END
    ) AS Left_Count,
    COUNT(
        CASE
            WHEN LeftCompany = 'No'
            THEN 1 
        END
    ) AS Stayed_Count,
    ROUND(
        100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*), 2
    ) AS Attrition_Rate
FROM hr_attrition_indian_dataset
GROUP BY Department, Designation
ORDER BY Department, Attrition_Rate DESC;




-- Department vs Designation (min 10 employees)

SELECT 
    Department, 
    Designation,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No'  THEN 1 END) AS Stayed_Count,
    ROUND(100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*), 2) AS Attrition_Rate
FROM hr_attrition_indian_dataset
GROUP BY Department, Designation
HAVING COUNT(*) >= 10          
ORDER BY Attrition_Rate DESC;



-- Attrition By Age

WITH AgeGroup AS (
	SELECT
		Age,
        LeftCompany,
        CASE
			WHEN AGE BETWEEN 22 AND 30 THEN '22 - 30 Years'
            WHEN AGE BETWEEN 31 AND 40 THEN '31 - 40 Years'
            WHEN AGE BETWEEN 41 AND 50 THEN '41 - 50 Years'
            WHEN AGE BETWEEN 51 AND 60 THEN '51 - 60 Years'
            ELSE 'Other'
		END AS Age_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Age_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*), 2) AS Attrition_Rate
FROM AgeGroup
GROUP BY Age_Group
ORDER BY MIN(Age);



-- Attrition By Education

SELECT
	EducationQualification,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM hr_attrition_indian_dataset
GROUP BY EducationQualification
ORDER BY EducationQualification;



-- Attrition By Salary

WITH salary_categories AS (
	SELECT
		MonthlySalary,
		LeftCompany,
		CASE
			WHEN MonthlySalary BETWEEN 15000 AND 34999 THEN 'Entry-Level Salary'
			WHEN MonthlySalary BETWEEN 35000 AND 54999 THEN 'Lower-Mid Salary'
			WHEN MonthlySalary BETWEEN 55000 AND 74999 THEN 'Mid-Level Salary'
			WHEN MonthlySalary BETWEEN 75000 AND 94999 THEN 'Upper-Mid Salary'
			WHEN MonthlySalary BETWEEN 95000 AND 120000 THEN 'High-Level Salary'
			ELSE 'Outside Salary Range'
		END AS Salary_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Salary_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM salary_categories
GROUP BY Salary_Group
ORDER BY MIN(MonthlySalary);





-- Attrition By Previous Companies

WITH Previous_Companies_Grouped AS (
	SELECT
		LeftCompany,
		CASE
			WHEN PreviousCompanies = 0 THEN 'First-Time Employee'
			WHEN PreviousCompanies <= 2 THEN 'Limited-Prior Experience'
			WHEN PreviousCompanies <= 4 THEN 'Moderate-Prior Experience'
			WHEN PreviousCompanies <= 5 THEN 'Extensive Experience'
            ELSE 'Other'
		END AS Previous_Companies_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Previous_Companies_Group,
    COUNT(*) AS Total_employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM Previous_Companies_Grouped
GROUP BY Previous_Companies_Group
ORDER BY
    CASE Previous_Companies_Group
        WHEN 'First-Time Employee' THEN 1
        WHEN 'Limited-Prior Experience' THEN 2
        WHEN 'Moderate-Prior Experience' THEN 3
        WHEN 'Extensive Experience' THEN 4
        ELSE 5
    END;
    
    
    
-- Attrition By Years In Company
    
WITH YearsInCompanyGroup AS
(
	SELECT
		YearsWithCompany,
        LeftCompany,
			CASE
				WHEN YearsWithCompany BETWEEN 1 AND 2 THEN 'New Tenure (1 to 2 Years)'
				WHEN YearsWithCompany BETWEEN 3 AND 4 THEN 'Short Tenure (3 to 4 Years)'
				WHEN YearsWithCompany BETWEEN 5 AND 7 THEN 'Mid Tenure (5 to 7 Years)'
				WHEN YearsWithCompany BETWEEN 8 AND 10 THEN 'Long Tenure (8 to 10 Years)'
				ELSE 'Other'
			END AS Years_In_Company_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Years_In_Company_Group,
    COUNT(*) AS Total_employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM YearsInCompanyGroup
GROUP BY Years_In_Company_Group
ORDER BY MIN(YearsWithCompany);



-- Attrition By Years In Role
    
WITH YearsInRoleGroup AS
(
	SELECT
		YearsInRole,
        LeftCompany,
			CASE
				WHEN YearsInRole BETWEEN 0 AND 1 THEN 'New To Role'
				WHEN YearsInRole BETWEEN 2 AND 3 THEN 'Early Role Tenure'
				WHEN YearsInRole BETWEEN 4 AND 6 THEN 'Mid Role Tenure'
				WHEN YearsInRole BETWEEN 7 AND 10 THEN 'Long Role Tenure'
				ELSE 'Other'
			END AS Years_In_Role_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Years_In_Role_Group,
    COUNT(*) AS Total_employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM YearsInRoleGroup
GROUP BY Years_In_Role_Group
ORDER BY MIN(YearsInRole);





-- Attrition By Appraisal Rating
    
WITH AppraisalRatingGroup AS
(
	SELECT
		AppraisalRating,
        LeftCompany,
			CASE
				WHEN AppraisalRating BETWEEN 1 AND 2 THEN 'Low Appraisal'
				WHEN AppraisalRating = 3 THEN 'Average Appraisal'
				WHEN AppraisalRating BETWEEN 4 AND 5 THEN 'High Appraisal'
				ELSE 'Other'
			END AS Appraisal_Rating_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Appraisal_Rating_Group,
    COUNT(*) AS Total_employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM AppraisalRatingGroup
GROUP BY Appraisal_Rating_Group
ORDER BY MIN(AppraisalRating);




-- Attrition By Training Hours
    
WITH TrainingHoursGroup AS
(
	SELECT
		TrainingHours,
        LeftCompany,
			CASE
				WHEN TrainingHours = 0 THEN 'No Training'
				WHEN TrainingHours BETWEEN 1 AND 15 THEN 'Low Training'
				WHEN TrainingHours BETWEEN 16 AND 30 THEN 'Moderate Training'
				WHEN TrainingHours BETWEEN 31 AND 60 THEN 'High Training'
				ELSE 'Other'
			END AS Training_Hours_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Training_Hours_Group,
    COUNT(*) AS Total_employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM TrainingHoursGroup 
GROUP BY Training_Hours_Group 
ORDER BY MIN(TrainingHours);




-- Attrition By Overtime

SELECT 
    DoesOvertime,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM hr_attrition_indian_dataset
GROUP BY DoesOvertime
ORDER BY Attrition_Rate DESC;




-- Attrition By Job Satisfaction

WITH JobSatisfactionGroup AS
(
	SELECT
		JobSatisfaction,
        LeftCompany,
			CASE
				WHEN JobSatisfaction BETWEEN 1 AND 2 THEN 'Low Satisfaction'
				WHEN JobSatisfaction = 3 THEN 'Moderate Satisfaction'
				WHEN JobSatisfaction BETWEEN 4 AND 5 THEN 'High Satisfaction'
				ELSE 'Other'
			END AS Job_Satisfaction_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Job_Satisfaction_Group,
    COUNT(*) AS Total_employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM JobSatisfactionGroup
GROUP BY Job_Satisfaction_Group
ORDER BY MIN(JobSatisfaction);




-- Attrition By Work Life Balance

WITH WorkLifeBalanceGroup AS
(
	SELECT
		WorkLifeBalance,
        LeftCompany,
			CASE
				WHEN WorkLifeBalance = 1 THEN 'Poor Work-Life Balance'
				WHEN WorkLifeBalance BETWEEN 2 AND 3 THEN 'Moderate Work-Life Balance'
				WHEN WorkLifeBalance = 4 THEN 'Good Work-Life Balance'
				ELSE 'Other'
			END AS WorkLife_Balance_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	WorkLife_Balance_Group,
    COUNT(*) AS Total_employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM WorkLifeBalanceGroup
GROUP BY WorkLife_Balance_Group
ORDER BY MIN(WorkLifeBalance);




-- Attrition By Distance From Home

WITH DistanceFromHomeGroup AS
(
	SELECT
		DistanceFromHome,
        LeftCompany,
			CASE
				WHEN DistanceFromHome >= 1 AND DistanceFromHome < 6 THEN 'Very Short Distance'
                WHEN DistanceFromHome >= 6 AND DistanceFromHome < 16  THEN 'Short Distance'
                WHEN DistanceFromHome >= 16 AND DistanceFromHome < 31 THEN 'Moderate Distance'
                WHEN DistanceFromHome >= 31 AND DistanceFromHome < 51  THEN 'Long Distance'
				ELSE 'Other'
			END AS Distance_From_Home_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Distance_From_Home_Group,
    COUNT(*) AS Total_employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM DistanceFromHomeGroup
GROUP BY Distance_From_Home_Group
ORDER BY MIN(DistanceFromHome);



-- Attrition By Leaves Taken
    
WITH LeavesTakenGroup AS
(
	SELECT
		LeavesTaken,
        LeftCompany,
			CASE
				WHEN LeavesTaken = 0 THEN 'No Leave Taken'
				WHEN LeavesTaken BETWEEN 1 AND 10 THEN 'Low Leave Usage'
				WHEN LeavesTaken BETWEEN 11 AND 20 THEN 'Moderate Leave Usage'
				WHEN LeavesTaken BETWEEN 21 AND 30 THEN 'High Leave Usage'
				ELSE 'Other'
			END AS Leaves_Taken_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Leaves_Taken_Group,
    COUNT(*) AS Total_employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM LeavesTakenGroup 
GROUP BY Leaves_Taken_Group 
ORDER BY MIN(LeavesTaken);



-- Attrition By Cities

SELECT
	City,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM hr_attrition_indian_dataset
GROUP BY City
ORDER BY Attrition_Rate DESC;



-- Attrition By Gender

SELECT
	Gender,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM hr_attrition_indian_dataset
GROUP BY Gender
ORDER BY Gender;



-- Attrition By Maritial Status

SELECT
	MaritalStatus,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM hr_attrition_indian_dataset
GROUP BY MaritalStatus
ORDER BY Attrition_Rate DESC;





-- Attrition By Overtime VS Job Satisfaction

WITH OvertimeVsJobSatisfaction AS (
SELECT 
	DoesOvertime,
    JobSatisfaction,
    LeftCompany,
    CASE
		WHEN JobSatisfaction BETWEEN 1 AND 2 THEN 'Low Satisfaction'
        WHEN JobSatisfaction = 3 THEN 'Moderate Satisfaction'
        WHEN JobSatisfaction BETWEEN 4 AND 5 THEN 'High Satisfaction'
    END AS Job_Satisfaction_Group
FROM hr_attrition_indian_dataset
)

SELECT
	DoesOvertime,
    Job_Satisfaction_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM OvertimeVsJobSatisfaction
GROUP BY DoesOvertime, Job_Satisfaction_Group
ORDER BY DoesOvertime, MIN(JobSatisfaction);
    




-- Attrition By Salary VS Department

WITH SalaryVsDepartment AS (
	SELECT
		MonthlySalary,
        Department,
        LeftCompany,
        CASE
			WHEN MonthlySalary BETWEEN 15000 AND 34999 THEN 'Entry-Level Salary'
			WHEN MonthlySalary BETWEEN 35000 AND 54999 THEN 'Lower-Mid Salary'
			WHEN MonthlySalary BETWEEN 55000 AND 74999 THEN 'Mid-Level Salary'
			WHEN MonthlySalary BETWEEN 75000 AND 94999 THEN 'Upper-Mid Salary'
			WHEN MonthlySalary BETWEEN 95000 AND 120000 THEN 'High-Level Salary'
			ELSE 'Outside Salary Range'
		END AS Salary_Group
    FROM hr_attrition_indian_dataset
)

SELECT
	Department,
    Salary_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM SalaryVsDepartment
GROUP BY Department, Salary_Group
ORDER BY Department, MIN(MonthlySalary);






-- Attrition By Years With Company VS Years in Role

WITH YearsinCompanyVsRole AS (
	SELECT
		YearsWithCompany,
        YearsInRole,
        LeftCompany,
	
        CASE
				WHEN YearsWithCompany BETWEEN 1 AND 2 THEN 'New Tenure (1 to 2 Years)'
				WHEN YearsWithCompany BETWEEN 3 AND 4 THEN 'Short Tenure (3 to 4 Years)'
				WHEN YearsWithCompany BETWEEN 5 AND 7 THEN 'Mid Tenure (5 to 7 Years)'
				WHEN YearsWithCompany BETWEEN 8 AND 10 THEN 'Long Tenure (8 to 10 Years)'
				ELSE 'Other'
			END AS Years_In_Company_Group,
            
		CASE
				WHEN YearsInRole BETWEEN 0 AND 1 THEN 'New To Role'
				WHEN YearsInRole BETWEEN 2 AND 3 THEN 'Early Role Tenure'
				WHEN YearsInRole BETWEEN 4 AND 6 THEN 'Mid Role Tenure'
				WHEN YearsInRole BETWEEN 7 AND 10 THEN 'Long Role Tenure'
				ELSE 'Other'
			END AS Years_In_Role_Group
		
    FROM hr_attrition_indian_dataset
)

SELECT
	Years_In_Company_Group,
    Years_In_Role_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM YearsinCompanyVsRole
GROUP BY Years_In_Company_Group, Years_In_Role_Group
ORDER BY MIN(YearsWithCompany), MIN(YearsInRole);






-- Attrition By Salary Group VS Job Satisfaction

WITH SalaryVSJobSatisfaction AS (
SELECT
		MonthlySalary,
        JobSatisfaction,
		LeftCompany,
		CASE
			WHEN MonthlySalary BETWEEN 15000 AND 34999 THEN 'Entry-Level Salary'
			WHEN MonthlySalary BETWEEN 35000 AND 54999 THEN 'Lower-Mid Salary'
			WHEN MonthlySalary BETWEEN 55000 AND 74999 THEN 'Mid-Level Salary'
			WHEN MonthlySalary BETWEEN 75000 AND 94999 THEN 'Upper-Mid Salary'
			WHEN MonthlySalary BETWEEN 95000 AND 120000 THEN 'High-Level Salary'
			ELSE 'Outside Salary Range'
		END AS Salary_Group,
        
        CASE
				WHEN JobSatisfaction BETWEEN 1 AND 2 THEN 'Low Satisfaction'
				WHEN JobSatisfaction = 3 THEN 'Moderate Satisfaction'
				WHEN JobSatisfaction BETWEEN 4 AND 5 THEN 'High Satisfaction'
				ELSE 'Other'
		END AS Job_Satisfaction_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Salary_Group,
    Job_Satisfaction_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM SalaryVSJobSatisfaction
GROUP BY Salary_Group, Job_Satisfaction_Group
ORDER BY MIN(MonthlySalary), MIN(JobSatisfaction);





-- Attrition By Appraisal Rating VS Salary Group

WITH AppraisalRatingVsSalary AS (
	SELECT
		AppraisalRating,
        MonthlySalary,
        LeftCompany,
			CASE
				WHEN AppraisalRating BETWEEN 1 AND 2 THEN 'Low Appraisal'
				WHEN AppraisalRating = 3 THEN 'Average Appraisal'
				WHEN AppraisalRating BETWEEN 4 AND 5 THEN 'High Appraisal'
				ELSE 'Other'
			END AS Appraisal_Rating_Group,
            
            CASE
			WHEN MonthlySalary BETWEEN 15000 AND 34999 THEN 'Entry-Level Salary'
			WHEN MonthlySalary BETWEEN 35000 AND 54999 THEN 'Lower-Mid Salary'
			WHEN MonthlySalary BETWEEN 55000 AND 74999 THEN 'Mid-Level Salary'
			WHEN MonthlySalary BETWEEN 75000 AND 94999 THEN 'Upper-Mid Salary'
			WHEN MonthlySalary BETWEEN 95000 AND 120000 THEN 'High-Level Salary'
			ELSE 'Outside Salary Range'
		END AS Salary_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Appraisal_Rating_Group,
    Salary_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM AppraisalRatingVsSalary
GROUP BY Appraisal_Rating_Group, Salary_Group
ORDER BY MIN(AppraisalRating), MIN(MonthlySalary);





-- Attrition By Work-Life Balance VS Job Satisfaction

WITH WorkLifeBalanceVsJobSatisfaction AS (
	SELECT
		WorkLifeBalance,
        JobSatisfaction,
        LeftCompany,
			CASE
				WHEN WorkLifeBalance = 1 THEN 'Poor Work-Life Balance'
				WHEN WorkLifeBalance BETWEEN 2 AND 3 THEN 'Moderate Work-Life Balance'
				WHEN WorkLifeBalance = 4 THEN 'Good Work-Life Balance'
				ELSE 'Other'
			END AS WorkLife_Balance_Group,
            
            CASE
				WHEN JobSatisfaction BETWEEN 1 AND 2 THEN 'Low Satisfaction'
				WHEN JobSatisfaction = 3 THEN 'Moderate Satisfaction'
				WHEN JobSatisfaction BETWEEN 4 AND 5 THEN 'High Satisfaction'
				ELSE 'Other'
		END AS Job_Satisfaction_Group
        
	FROM hr_attrition_indian_dataset
)
SELECT
	WorkLife_Balance_Group,
    Job_Satisfaction_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM WorkLifeBalanceVsJobSatisfaction
GROUP BY WorkLife_Balance_Group, Job_Satisfaction_Group
ORDER BY MIN(WorkLifeBalance), MIN(JobSatisfaction);




-- Attrition By Distance From Home VS Overtime

WITH DistanceVsOvertime AS (
	SELECT
		DistanceFromHome,
        DoesOvertime,
        LeftCompany,
			CASE
				WHEN DistanceFromHome >= 1 AND DistanceFromHome < 6 THEN 'Very Short Distance'
                WHEN DistanceFromHome >= 6 AND DistanceFromHome < 16  THEN 'Short Distance'
                WHEN DistanceFromHome >= 16 AND DistanceFromHome < 31 THEN 'Moderate Distance'
                WHEN DistanceFromHome >= 31 AND DistanceFromHome < 51  THEN 'Long Distance'
				ELSE 'Other'
			END AS Distance_From_Home_Group
            
	FROM hr_attrition_indian_dataset
)
SELECT
	DoesOvertime,
    Distance_From_Home_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM DistanceVsOvertime
GROUP BY DoesOvertime, Distance_From_Home_Group
ORDER BY DoesOvertime, MIN(DistanceFromHome);




-- Attrition By Training Hours VS Appraisal Rating

WITH TrainingHoursVsAppraisalRating AS (
	SELECT
		TrainingHours,
        AppraisalRating,
        LeftCompany,
			CASE
				WHEN TrainingHours = 0 THEN 'No Training'
				WHEN TrainingHours BETWEEN 1 AND 15 THEN 'Low Training'
				WHEN TrainingHours BETWEEN 16 AND 30 THEN 'Moderate Training'
				WHEN TrainingHours BETWEEN 31 AND 60 THEN 'High Training'
				ELSE 'Other'
			END AS Training_Hours_Group,
            
            CASE
				WHEN AppraisalRating BETWEEN 1 AND 2 THEN 'Low Appraisal'
				WHEN AppraisalRating = 3 THEN 'Average Appraisal'
				WHEN AppraisalRating BETWEEN 4 AND 5 THEN 'High Appraisal'
				ELSE 'Other'
			END AS Appraisal_Rating_Group
	FROM hr_attrition_indian_dataset
)

SELECT
	Training_Hours_Group,
    Appraisal_Rating_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*),2) AS Attrition_Rate
FROM TrainingHoursVsAppraisalRating
GROUP BY Training_Hours_Group, Appraisal_Rating_Group
ORDER BY MIN(TrainingHours), MIN(AppraisalRating);





-- Attrition By Education VS Salary

WITH EducationVsSalary AS (
	SELECT
		EducationQualification,
        MonthlySalary,
        LeftCompany,
		CASE
			WHEN MonthlySalary BETWEEN 15000 AND 34999 THEN 'Entry-Level Salary'
			WHEN MonthlySalary BETWEEN 35000 AND 54999 THEN 'Lower-Mid Salary'
			WHEN MonthlySalary BETWEEN 55000 AND 74999 THEN 'Mid-Level Salary'
			WHEN MonthlySalary BETWEEN 75000 AND 94999 THEN 'Upper-Mid Salary'
			WHEN MonthlySalary BETWEEN 95000 AND 120000 THEN 'High-Level Salary'
			ELSE 'Outside Salary Range'
		END AS Salary_Group
	FROM hr_attrition_indian_dataset
)
SELECT
	EducationQualification,
    Salary_Group,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) AS Left_Count,
    COUNT(CASE WHEN LeftCompany = 'No' THEN 1 END ) AS Stayed_Count,
    ROUND(100 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END ) / COUNT(*),2) AS Attrition_Rate
FROM EducationVsSalary
GROUP BY EducationQualification ,Salary_Group
ORDER BY EducationQualification, MIN(MonthlySalary);




-- Attrition by number of risk factors
WITH risk AS (
    SELECT
        LeftCompany,
        (DoesOvertime = 'Yes') + (JobSatisfaction <= 2)
          + (WorkLifeBalance = 1) + (AppraisalRating <= 2) AS risk_factors
    FROM hr_attrition_indian_dataset
)
SELECT
    risk_factors,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) AS Left_Count,
    ROUND(100.0 * COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*), 2) AS Attrition_Rate,
    RANK() OVER (ORDER BY COUNT(CASE WHEN LeftCompany = 'Yes' THEN 1 END) / COUNT(*) DESC) AS Risk_Rank
FROM risk
GROUP BY risk_factors
ORDER BY risk_factors;