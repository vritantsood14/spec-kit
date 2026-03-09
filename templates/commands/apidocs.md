---
description: Generate API documentation from implementation and contracts
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup & Context Loading**:
   
   Run `.specify/scripts/bash/generate-docs.sh --json --scope api-docs` from repo root.

2. **Load Artifacts**:
   
   - Read PLAN_FILE for API architecture
   - Read contracts/ directory if exists
   - Read CHANGED_FILES to find API implementations
   - Identify project type from PROJECT_TYPE

3. **Analyze API Endpoints**:
   
   - Extract endpoint definitions from code
   - Identify request/response formats
   - Document authentication requirements
   - List error codes and messages
   - Find example usage

4. **Generate Documentation by Project Type**:

   **Spring Boot**:
   - Update Springdoc/Swagger annotations
   - Generate OpenAPI YAML/JSON
   - Add @Operation, @ApiResponse to controllers
   - Document DTOs with @Schema

   **Node.js/Express**:
   - Update JSDoc for routes
   - Generate Swagger/OpenAPI JSON
   - Document middleware
   - Add request/response examples

   **Python/FastAPI**:
   - Update docstrings with examples
   - Generate OpenAPI JSON (auto from FastAPI)
   - Document Pydantic models
   - Add request/response examples

   **Go**:
   - Add godoc comments to handlers
   - Generate markdown API docs
   - Document structs and interfaces
   - Add example requests

5. **Create/Update Documentation Files**:
   
   - Create docs/api/ directory if needed
   - Generate endpoint reference docs
   - Add authentication guide
   - Include example requests/responses
   - Document error codes
   - Add rate limiting info if applicable

6. **Report**:
   
   - List generated documentation files
   - Show coverage (% of endpoints documented)
   - Suggest improvements if gaps found

## Key Rules

- Document all public endpoints
- Include authentication/authorization details
- Provide working example requests
- Document all error codes
- Keep examples realistic and tested
- Update OpenAPI specs if project uses them
