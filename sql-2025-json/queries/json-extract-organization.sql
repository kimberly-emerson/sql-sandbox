USE AdventureWorks2025;
GO

SELECT 
    DepartmentGroup = JSON_VALUE(Supervisors, '$[0].departmentGroup'),
    Department = JSON_VALUE(Supervisors, '$[0].department'),
    SupervisorID = JSON_VALUE(Supervisors, '$[0].employeeID'),
    Supervisor = JSON_VALUE(Supervisors, '$[0].employee'),
    EmployeeID,
    Employee,
    JobTitle
FROM 
    HumanResources.OrganizationNodes
    CROSS APPLY OPENJSON(Supervisors, '$[0].employees')
    WITH (
        EmployeeID INT '$.employeeID',
        Employee NVARCHAR(100) '$.employee',
        JobTitle NVARCHAR(100) '$.jobTitle'
    ) AS Employees