# Stored Procedures | sql-2025-json

## HumanResources.uspOrganization

`HumanResources.uspOrganization` is a stored procedure for AdventureWorks2025 that rebuilds the `HumanResources.Organization` table with a clean, hierarchical view of employees and their supervisors. It leverages common table expressions (CTEs) to establish the CEO as the root node and recursively map supervisor/employee relationships across the organization.

This procedure demonstrates how to structure relational data into a clear organizational hierarchy, making it easier to query, visualize, and integrate into applications. It provides a normalized org chart table for queries and reporting.  

### Features  

- **Table reset**: Drops the existing `Organization` table if it exists, ensuring a fresh rebuild.  
- **Hierarchy construction**: Uses CTEs to define the CEO as the root (`OrganizationLevel = 0`) and recursively attach employees to their supervisors.  
- **Rich metadata**: Captures employee details (ID, name, job title, department, group) alongside supervisor information (ID, name, job title, department, group).  
- **Ordered output**: Inserts rows into the new `Organization` table sorted by supervisor, level, and node for consistent traversal.  
- **Execution feedback**: Prints the number of employees inserted for quick verification.  

### Usage  

Run the procedure with:  

```sql
EXEC HumanResources.uspOrganization;
```

Expected behavior:  

- Drops and recreates the `HumanResources.Organization` table.  
- Populates it with one row per employee, including supervisor details.  
- Prints a completion message with the total number of employees inserted.  

## HumanResources.uspOrganizationNodes

`HumanResources.uspOrganizationNodes` is a stored procedure for AdventureWorks2025 that generates a JSON‑based organizational hierarchy. It ensures the HumanResources.OrganizationNodes table exists, refreshes its contents, and inserts supervisor/employee relationships using SQL Server 2025’s new JSON functions.

This repo demonstrates practical use of `JSON_ARRAYAGG` and `JSON_OBJECT` to model hierarchical data directly in SQL. These functions allow bridging relational structures with API‑friendly hierarchical data.

### Features

- **Automatic table management: **Creates OrganizationNodes if missing, truncates if it already exists.
- **JSON aggregation:** Builds nested JSON arrays of supervisors and their direct reports.
- **Rich metadata:** Includes employee details, job titles, departments, supervisor info, and employee counts.
-**Transparent execution:** Prints status messages and row counts for quick verification.

### Usage  

Run the procedure with:  

```sql
EXEC HumanResources.uspOrganizationNodes;
```

Expected behavior:

- Table is created or refreshed.
- Rows are inserted for each organization node.
- JSON payloads are generated for supervisors and employees.
- A completion message prints the number of nodes inserted.
