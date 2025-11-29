# Views | sql-2025-json

## HumanResources.vEmployeeDetails

`HumanResources.vEmployeeDetails` is a view in AdventureWorks2025 that consolidates employee information into a single, query‑friendly dataset. It joins core HR tables to provide a unified record of each employee’s identity, organizational placement, supervisor relationship, and department details.  

This view serves as the foundation for building organizational hierarchies (`uspOrganization`, `uspOrganizationNodes`) and demonstrates how to enrich relational data with business‑ready attributes.

- Provides a **single source of truth** for employee and supervisor data.  
- Simplifies queries for org charts, reporting, and analytics.  
- Serves as a **base view** for stored procedures that build hierarchical JSON structures.  
- Demonstrates best practices in **joining HR tables** and applying filters for active employees.  

### Features  

- **Employee identity**: Includes `EmployeeID`, `NationalID`, `LoginID`, and full name (`FirstName + LastName`).  
- **Organizational hierarchy**: Captures `OrganizationNode` and `OrganizationLevel` for structural placement.  
- **Supervisor mapping**: Resolves `SupervisorID` and supervisor details via joins to `vSupervisors` and ancestor nodes.  
- **Role metadata**: Provides `JobTitle`, `Department`, and `DepartmentGroup`.  
- **Flags**:  
  - `IsSupervisor` (1 if employee supervises others)  
  - `SalariedFlag`  
  - `CurrentFlag` (active employees only)  
- **Employment details**: Includes `Gender` and `HireDate`.  
- **Active assignment filter**: Restricts results to employees with current department assignments (`EndDate IS NULL`).  

### Usage  

Query the view directly:  

```sql
SELECT *
FROM HumanResources.vEmployeeDetails
WHERE IsSupervisor = 1;
```

This returns all supervisors with their organizational placement and department details.

Here’s the **diagram‑style documentation** you can add to the README for `HumanResources.vEmployeeDetails`. It shows how the joins work and makes the construction of the view easy to visualize:

### Join Diagram  

The view pulls together data from multiple sources to create a unified employee record.  

```
HumanResources.Employee (e)
   │
   ├── LEFT JOIN HumanResources.vSupervisors (s)
   │       → Provides SupervisorID mapping
   │
   ├── LEFT JOIN subquery (sup)
   │       → Distinct SupervisorID from ancestor nodes
   │
   ├── INNER JOIN Person.Person (p)
   │       → Provides FirstName, LastName for Employee
   │
   ├── INNER JOIN HumanResources.EmployeeDepartmentHistory (edh)
   │       → Links employee to department assignments
   │
   └── INNER JOIN HumanResources.Department (d)
           → Provides Department and DepartmentGroup
```

### Flow Explanation  

- **Employee base**: Starts with `HumanResources.Employee` as the anchor.  
- **Supervisor mapping**:  
  - `vSupervisors` provides direct supervisor relationships.  
  - The `sup` subquery ensures supervisor IDs are captured from ancestor nodes.  
- **Identity enrichment**: Joins to `Person.Person` for employee names.  
- **Department context**: Joins to `EmployeeDepartmentHistory` and `Department` to add department and group metadata.  
- **Active filter**: Restricts results to employees with current assignments (`EndDate IS NULL`).  


## HumanResources.vSupervisors

`HumanResources.vSupervisors` is a view in AdventureWorks2025 that maps each employee to their immediate supervisor based on organizational hierarchy. It leverages the `OrganizationNode` column and the `GetAncestor(1)` function to identify parent nodes, creating a simple but essential link between employees and supervisors.

This view is a foundational building block for higher‑level organizational structures (`vEmployeeDetails`, `uspOrganization`, `uspOrganizationNodes`).

- Provides a **clean mapping table** for employee–supervisor relationships.  
- Serves as a **core input** for `vEmployeeDetails` and organizational hierarchy procedures.  
- Simplifies queries that need to traverse or analyze reporting structures.  
- Demonstrates practical use of SQL Server’s **hierarchy functions** (`GetAncestor`).  

### Features  

- **Employee–Supervisor mapping**: Returns each `EmployeeID` alongside their `SupervisorID`.  
- **Hierarchy resolution**: Uses `OrganizationNode.GetAncestor(1)` to determine the supervisor node one level above the employee.  
- **Flexible join**: Employs a `LEFT JOIN` so employees without supervisors (e.g., CEO) are still included with a `NULL` supervisor.  
- **Lightweight design**: Minimal columns for fast lookups and easy integration into other views and procedures.  

### Usage  

Query the view directly:  

```sql
SELECT *
FROM HumanResources.vSupervisors
WHERE SupervisorID IS NOT NULL;
```

This returns all employees who have a supervisor relationship defined.
