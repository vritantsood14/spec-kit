---
description: Update project README with feature overview (lightweight doc update)
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup & Context Loading**:
   
   Run `.specify/scripts/bash/generate-docs.sh --json --scope readme` from repo root.

2. **Load Artifacts**:
   
   - Read PLAN_FILE for implementation details
   - Read SPEC_FILE for feature requirements
   - Read existing README.md

3. **Update README.md**:
   
   - Add concise feature description (2-3 sentences max)
   - Link to detailed docs if they exist in docs/ folder
   - Update table of contents if present
   - Follow existing README structure and style
   - Place in appropriate section (Features, API, etc.)

4. **Validation**:
   
   - Ensure no duplicate content
   - Verify links work
   - Match existing formatting style

5. **Report**:
   
   - Confirm README updated
   - Show what was added/changed
   - Suggest next steps if needed

## Key Rules

- Keep it brief - README is for overview, not deep docs
- Link to detailed documentation instead of inline detail
- Match existing style and tone
- Don't create new sections unless necessary
- Update existing sections when possible
