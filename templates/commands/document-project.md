---
description: Generate comprehensive documentation for the entire project (not just a feature)
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup & Context Loading**:
   
   Run `.specify/scripts/bash/generate-docs.sh --json --project` from repo root and parse JSON output.
   
   Expected JSON structure:
   ```json
   {
     "MODE": "project",
     "REPO_ROOT": "/path/to/repo",
     "PROJECT_TYPE": "spring-boot|nodejs|python|etc",
     "SCOPE": "all|readme|code-comments|api-docs",
     "SOURCE_FILES": ["src/main/java/File1.java", "src/main/java/File2.java"],
     "HAS_GIT": "true"
   }
   ```

2. **Analyze Project Structure**:
   
   - Read key source files to understand architecture
   - Identify main entry points
   - Find configuration files
   - Understand project organization
   - **CRITICAL**: Analyze actual code, not assumptions

3. **Determine Documentation Needs**:

   Check what exists and what's missing:
   - README.md completeness
   - API documentation
   - Architecture documentation
   - Setup/installation instructions
   - Code comments coverage

4. **Generate Documentation Based on Scope**:

   **If SCOPE is "all" (default)**:
   - Create/update comprehensive README.md
   - Add code comments where missing
   - Create docs/ folder with:
     - Architecture overview
     - API documentation
     - Setup guide
     - Developer guide
   - Generate diagrams if helpful (using mermaid)

   **If SCOPE is "readme"**:
   - Focus on README.md only
   - Project description
   - Key features
   - Quick start guide
   - Links to detailed docs

   **If SCOPE is "code-comments"**:
   - Add JavaDoc/JSDoc/docstrings to public APIs
   - Document complex logic
   - Add inline comments where needed
   - Focus on main source files

   **If SCOPE is "api-docs"**:
   - Document all API endpoints
   - Generate OpenAPI/Swagger specs
   - Add request/response examples
   - Document error codes

5. **Project-Type Specific Guidelines**:

   **For Spring Boot projects**:
   - Document REST endpoints (@RestController classes)
   - Explain configuration (application.yml/properties)
   - Document data models (@Entity classes)
   - Explain security setup if present
   - Add JavaDoc to services and controllers

   **For Node.js/Express projects**:
   - Document route handlers
   - Explain middleware
   - Document environment variables
   - Add JSDoc to key functions
   - Create API documentation

   **For Python projects**:
   - Add docstrings to classes and functions
   - Document CLI commands if applicable
   - Explain configuration
   - Create usage examples

   **For monorepos/microservices**:
   - Create docs/ at root with overview
   - Document each service separately
   - Explain inter-service communication
   - Add architecture diagrams

6. **README Structure** (if updating README):

   ```markdown
   # Project Name
   
   Brief description (1-2 sentences)
   
   ## Features
   
   - Key feature 1
   - Key feature 2
   - Key feature 3
   
   ## Quick Start
   
   ### Prerequisites
   - List requirements
   
   ### Installation
   ```bash
   # Installation steps
   ```
   
   ### Usage
   ```bash
   # Basic usage
   ```
   
   ## Documentation
   
   - [Architecture](docs/architecture.md)
   - [API Documentation](docs/api.md)
   - [Developer Guide](docs/development.md)
   
   ## Configuration
   
   Key configuration options
   
   ## Contributing
   
   Guidelines (if applicable)
   
   ## License
   
   License info
   ```

7. **Documentation Rules**:

   - **Match existing style**: If project has docs, follow the same format
   - **Be concise**: Focus on essential information
   - **Add examples**: Show don't tell
   - **Keep updated**: Document actual code, not wishful thinking
   - **Link between docs**: Create navigation between doc files
   - **Use diagrams**: Mermaid for architecture, flows, etc.

8. **Output & Report**:

   After generating documentation:
   - List all files created or updated
   - Provide summary of changes made
   - Suggest next steps
   - Note any areas needing manual review

## Example Execution

```
User: /speckit.document-project
→ Script runs in project mode
→ AI analyzes: Spring Boot application with REST API
→ AI generates:
   - README.md: Comprehensive project overview
   - docs/architecture.md: System architecture with diagrams
   - docs/api.md: Complete API documentation
   - JavaDoc comments: Added to all public classes
   - application.yml comments: Explained configuration
→ Reports: "✓ Project documentation complete"
```

## Handling Edge Cases

- **No README exists**: Create comprehensive one from scratch
- **README is minimal**: Enhance with proper structure
- **Large codebase**: Focus on public APIs and main components
- **Multiple modules**: Document structure and inter-dependencies
- **Legacy code**: Add docs to help future developers

## Key Rules

- **ALWAYS** analyze actual code structure
- **NEVER** make assumptions about architecture
- **ALWAYS** preserve existing documentation style
- **NEVER** duplicate information unnecessarily
- Ask for clarification **once** if critical info missing
