# Query: JSON Extract Organization from `HumanResources.OrganizationNodes`

This query extracts supervisor and employee details from the JSON payload stored in the `HumanResources.OrganizationNodes` table. It uses `JSON_VALUE` to pull supervisor metadata and `OPENJSON` with a schema definition to expand nested employee arrays.  

The result is a flattened dataset that pairs each supervisor with their direct reports, including department context and job titles.

- Converts **nested JSON hierarchies** into a flat, queryable dataset.  
- Provides a **clear supervisor–employee mapping** for reporting and analytics.  
- Demonstrates SQL Server 2025’s **JSON integration capabilities** (`JSON_VALUE`, `OPENJSON`).  
- Useful for recruiter‑ready demos showing how relational and JSON data can be combined seamlessly.  

## Features  

- **Supervisor metadata**: Retrieves department group, department, supervisor ID, and supervisor name from the JSON array.  
- **Employee expansion**: Uses `OPENJSON` to parse the nested `employees` array into relational columns (`EmployeeID`, `Employee`, `JobTitle`).  
- **Relational + JSON hybrid**: Bridges hierarchical JSON data with tabular SQL output.  
