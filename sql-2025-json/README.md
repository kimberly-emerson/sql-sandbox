# AdventureWorks2025 Organizational Data Pipeline

This project showcases SQL Server 2025’s new JSON functions with practical examples. 

It demonstrates how SQL Server 2025 can model organizational hierarchies using **relational + JSON features**. The pipeline progresses from raw HR tables → consolidated views → structured tables → JSON aggregation → flattened query output.  

It’s both a technical showcase of advanced SQL Server 2025 capabilities (`JSON_ARRAYAGG`, `JSON_OBJECT`, `OPENJSON`) and an example of modern API-ready data modeling.

- **Modern SQL showcase**: Demonstrates SQL Server 2025’s JSON functions in a real business context for API‑friendly output.  
- **Reusable pattern**: Provides a blueprint for bridging relational HR data with JSON‑based architectures.  
- **End‑to‑end clarity**: Shows the full lineage from raw tables → views → procedures → tables → query output.  

```
OrganizationNodes
   ├── OrganizationLevel
   ├── OrganizationNode
   └── Supervisors [JSON Array]
        ├── Supervisor
        │    ├── organizationNode
        │    ├── organizationLevel
        │    ├── employeeID
        │    ├── employee
        │    ├── jobTitle
        │    ├── department
        │    ├── departmentGroup
        │    ├── supervisorID
        │    ├── supervisor
        │    ├── employeeCount
        │    └── Employees [Nested JSON Array]
        │         ├── employeeID
        │         ├── employee
        │         ├── jobTitle
        │         ├── department
        │         └── departmentGroup
```

- Top level: Each row in OrganizationNodes represents a node in the hierarchy.
- Supervisors array: Contains JSON objects for each supervisor at that node.
- Nested employees array: Each supervisor object contains a nested array of their direct reports.
- Flattening query: The final query uses `OPENJSON` + `JSON_VALUE` to expand this structure into a tabular dataset.

## Pipeline Flow  

```
Raw HR Tables
   ├── HumanResources.Employee
   ├── Person.Person
   ├── HumanResources.EmployeeDepartmentHistory
   ├── HumanResources.Department
   └── HumanResources.vSupervisors
        │
        ▼
View: HumanResources.vSupervisors
   → Maps each employee to their immediate supervisor
        │
        ▼
View: HumanResources.vEmployeeDetails
   → Consolidates employee identity, department, and supervisor relationships
        │
        ▼
Stored Procedure: HumanResources.uspOrganization
   → Drops/rebuilds HumanResources.Organization table
   → Normalizes hierarchy (CEO root, supervisors, employees)
        │
        ▼
Table: HumanResources.Organization
   → Stores relational org chart with supervisor/employee metadata
        │
        ▼
Stored Procedure: HumanResources.uspOrganizationNodes
   → Aggregates supervisors and employees into JSON arrays
        │
        ▼
Table: HumanResources.OrganizationNodes
   → Stores JSON‑based org chart (supervisors + nested employees)
        │
        ▼
Query: Supervisor–Employee Expansion
   → Uses JSON_VALUE + OPENJSON to flatten JSON into a tabular output
```

## Components  

### Views  
- **`vSupervisors`**: Lightweight mapping of employees to supervisors using `OrganizationNode.GetAncestor(1)`.  
- **`vEmployeeDetails`**: Enriched dataset combining employee identity, department, and supervisor relationships.  

### Tables  
- **`Organization`**: Normalized org chart table populated by `uspOrganization`.  
- **`OrganizationNodes`**: JSON‑based org chart table populated by `uspOrganizationNodes`.  

### Stored Procedures  
- **`uspOrganization`**: Rebuilds the `Organization` table with hierarchical supervisor/employee relationships.  
- **`uspOrganizationNodes`**: Aggregates supervisors and employees into JSON arrays for modern API‑friendly consumption.  

### Query  
- **Supervisor–Employee Expansion**: Flattens JSON from `OrganizationNodes` using `OPENJSON` and `JSON_VALUE` to produce a dataset showing supervisors and their direct reports.  

## Getting Started  

### Prerequisites  

- SQL Server 2025 installed and running.  
- AdventureWorks2025 sample database loaded.  
- Ensure JSON functions (`JSON_ARRAYAGG`, `JSON_OBJECT`, `OPENJSON`) are enabled.  

### Setup Steps  

1. **Create Views**  
   - Run the scripts for `vSupervisors` and `vEmployeeDetails`.  

2. **Run Stored Procedures in Order**  
   - Execute `uspOrganization` to build the `Organization` table.  
   - Execute `uspOrganizationNodes` to populate the `OrganizationNodes` table with JSON hierarchies.  

3. **Query the Data**  
   - Use the Supervisor–Employee Expansion query to flatten JSON into a tabular dataset.  

### Verification  
- After running `uspOrganization`, check:  
  ```sql
  SELECT TOP 10 * FROM HumanResources.Organization;
  ```  
- After running `uspOrganizationNodes`, check:  
  ```sql
  SELECT TOP 1 Supervisors FROM HumanResources.OrganizationNodes;
  ```  
- Run the expansion query to confirm supervisor–employee mappings are flattened correctly.  
