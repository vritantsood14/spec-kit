---
description: Generate comprehensive documentation for implemented features using plan and review artifacts
handoffs: 
  - label: Update README Only
    agent: speckit.readme
    prompt: Update the main README with feature overview
    send: false
  - label: Generate API Docs
    agent: speckit.apidocs
    prompt: Generate API documentation
    send: false
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup & Context Loading**:
   
   Run `.specify/scripts/bash/generate-docs.sh --json` from repo root and parse JSON output.
   
   Expected JSON structure:
   ```json
   {
     "FEATURE_DIR": "/path/to/specs/001-feature",
     "BRANCH": "001-feature-name",
     "PLAN_FILE": "/path/to/plan.md",
     "REVIEW_FILE": "/path/to/review.md",
     "SPEC_FILE": "/path/to/spec.md",
     "PROJECT_TYPE": "spring-boot|nodejs|python|etc",
     "SCOPE": "all|readme|code-comments|api-docs",
     "CHANGED_FILES": ["src/file1.java", "src/file2.java"],
     "REPO_ROOT": "/path/to/repo"
   }
   ```

2. **Load Documentation Artifacts**:
   
   - **REQUIRED**: Read PLAN_FILE to understand implementation approach
   - **IF EXISTS**: Read REVIEW_FILE for completion notes
   - **IF EXISTS**: Read SPEC_FILE for feature requirements
   - **REQUIRED**: Read changed files to understand actual implementation

3. **Analyze Implementation**:
   
   - Compare plan vs actual implementation
   - Identify key changes, new files, modified files
   - Understand architecture from code structure
   - **CRITICAL**: Code is source of truth, not plan/spec

4. **Generate Documentation Based on Scope**:

   **If SCOPE is "all" (default)**:
   - Update README.md with feature overview
   - Add/update code comments in implementation files
   - Create/update documentation in docs/ folder
   - Generate API documentation if applicable

   **If SCOPE is "readme"**:
   - Only update README.md high-level overview
   - Add one-line summary to changelog if exists

   **If SCOPE is "code-comments"**:
   - Only add/update inline code documentation
   - Function/class/method documentation
   - Complex logic explanations

   **If SCOPE is "api-docs"**:
   - Generate API endpoint documentation
   - Update OpenAPI/Swagger specs if applicable
   - Create usage examples

5. **Documentation Rules** (from project context):

   You are documenting a feature that has been implemented. **The code is the source of truth**.

   Update or add documentation in:
   - **Primary README** – brief high-level overview
   - **Code comments** – function/method documentation (IDEs), inline only where unclear
   - **Main docs folder** – comprehensive guides with examples
   - **New files** – only if feature is large enough to justify

   **Rules**:
   1. Match project's documentation style, format, verbosity, and structure
   2. Don't add docs to implementation-only directories (except code comments)
   3. **NEVER** create documentation files in specs/ directories (historical reference only)
   4. Avoid redundancy unless it improves usability
   5. Review existing files before adding more documentation
   6. Don't document tests unless user specifically requests it
   7. Keep README updates concise - link to detailed docs instead of inline detail
   8. For APIs: document endpoints, request/response, error codes, examples

6. **Project-Type Specific Guidelines**:

   **For Spring Boot / Java projects**:
   - Use JavaDoc for public APIs
   - Document REST endpoints with @Operation, @ApiResponse annotations
   - Update OpenAPI docs if using Springdoc
   - Include example requests/responses

   **For Node.js / JavaScript projects**:
   - Use JSDoc for functions
   - Document API routes with clear examples
   - Update package.json description if needed
   - Include TypeScript types documentation if applicable

   **For Python projects**:
   - Use docstrings (Google or NumPy style based on existing code)
   - Document functions, classes, modules
   - Update requirements/dependencies if needed
   - Include type hints documentation

   **For Go projects**:
   - Use Go doc comments (// before declaration)
   - Document exported functions and types
   - Keep examples in _test.go files or examples/

7. **Output & Report**:

   After generating documentation:
   - List all files created or updated
   - Provide summary of changes made
   - Suggest next steps (e.g., review docs, commit changes)
   - If any TODOs or unclear areas, note them

## Example Execution

```
User: /speckit.document
→ Script runs, finds feature 003-user-authentication
→ AI loads plan, review, changed files
→ AI generates:
   - README.md: Added "Authentication" section
   - src/auth/AuthService.java: Added JavaDoc
   - docs/authentication.md: Created comprehensive guide
   - Updated OpenAPI spec with new endpoints
→ Reports: "✓ Documentation generated for 003-user-authentication"
```

## Handling Edge Cases

- **No review file**: Use plan + code analysis only
- **No plan file**: Use code analysis + spec only (warn user)
- **No changed files**: Ask user which files to document
- **Unknown project type**: Use generic documentation approach
- **Empty scope**: Default to "all"

## Key Rules

- **ALWAYS** use absolute paths from JSON output
- **NEVER** modify spec.md, plan.md, review.md (read-only historical docs)
- **ALWAYS** check existing documentation style before writing
- **NEVER** create duplicate documentation
- Ask for clarification **once** if critical info missing, otherwise add TODO
