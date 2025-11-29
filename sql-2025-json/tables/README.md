# Tables | sql-2025-json

## HumanResources.Organization

`HumanResources.Organization` is a **user-defined** table in AdventureWorks2025 that stores a normalized organizational hierarchy. It captures employees, their roles, departments, and supervisor relationships, providing a structured dataset for building org charts, reporting, and JSON‑based hierarchies.

This table is populated by the stored procedure `HumanResources.uspOrganization`, which rebuilds it using the `HumanResources.vEmployeeDetails` view.

- Provides a **normalized org chart table** for queries, reporting, and analytics.  
- Serves as the **foundation** for JSON aggregation in `uspOrganizationNodes`.  
- Bridges employee data with supervisor relationships for **modernization projects**.  
- Demonstrates SQL Server 2025’s ability to model hierarchical structures in relational form.  

### Usage  

Query the table directly:  

```sql
SELECT Employee, JobTitle, Supervisor
FROM HumanResources.Organization
WHERE Department = 'Sales';
```

This returns all employees in the Sales department along with their supervisors.

## HumanResources.OrganizationNodes

`HumanResources.OrganizationNodes` is a **user-defined** table in AdventureWorks2025 designed to store hierarchical organizational data in JSON format. Each row represents an organizational node and level, with a JSON array of supervisors and their associated employees.  

This table is populated by the stored procedure `HumanResources.uspOrganizationNodes`, which aggregates data from `HumanResources.Organization` into API-ready JSON structures.

- Provides a **JSON‑based org chart** directly from SQL Server 2025.  
- Bridges relational structures with **API‑friendly hierarchical data**.  
- Serves as the **output layer** for modern applications consuming organizational hierarchies.  
- Demonstrates advanced use of `JSON_ARRAYAGG` and `JSON_OBJECT` functions.  

### Usage  

Query the table directly:  

```sql
SELECT OrganizationNode, Supervisors
FROM HumanResources.OrganizationNodes
WHERE OrganizationLevel = 2;
```

This returns all supervisor JSON arrays for nodes at level 2 in the hierarchy.
