#!/usr/bin/env bash
# generate-docs.sh - Documentation generator for spec-kit and projects

set -e

# Source the common functions from spec-kit (if available)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Try to source common.sh, but don't fail if it's not available
if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
    source "$SCRIPT_DIR/common.sh"
    HAS_SPECKIT=true
else
    HAS_SPECKIT=false
fi

JSON_MODE=false
SCOPE="all"
FEATURE_NUM=""
PROJECT_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --json) 
            JSON_MODE=true 
            ;;
        --scope) 
            SCOPE="$2"
            shift 
            ;;
        --feature) 
            FEATURE_NUM="$2"
            shift 
            ;;
        --project)
            PROJECT_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json] [--scope SCOPE] [--feature NUM] [--project]"
            echo "  --json         Output in JSON format"
            echo "  --scope SCOPE  Documentation scope: all|readme|code-comments|api-docs"
            echo "  --feature NUM  Specific feature number (optional)"
            echo "  --project      Document entire project (not just a feature)"
            exit 0
            ;;
        *) 
            ;;
    esac
    shift
done

# Find repo root
find_repo_root() {
    local dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.git" ] || [ -d "$dir/.specify" ] || [ -f "$dir/pom.xml" ] || [ -f "$dir/package.json" ]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    echo "$PWD"
}

REPO_ROOT=$(find_repo_root)

# Run from repo root so detect-project-type and find work correctly
cd "$REPO_ROOT"

# Check if we have git
HAS_GIT=false
if git rev-parse --show-toplevel >/dev/null 2>&1; then
    HAS_GIT=true
fi

# Detect project type (run from REPO_ROOT so package.json, pom.xml, etc. are found)
PROJECT_TYPE="$("$SCRIPT_DIR/detect-project-type.sh")"

# PROJECT MODE: Document entire project
if [[ "$PROJECT_MODE" == "true" ]] || [[ "$HAS_SPECKIT" == "false" ]]; then
    # Get all source files (excluding common ignore patterns)
    SOURCE_FILES="[]"
    if command -v find >/dev/null 2>&1; then
        SOURCE_FILES=$(find . -type f \
            \( -name "*.java" -o -name "*.kt" -o -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.rs" \) \
            ! -path "*/node_modules/*" \
            ! -path "*/target/*" \
            ! -path "*/build/*" \
            ! -path "*/.git/*" \
            ! -path "*/dist/*" \
            2>/dev/null | jq -R . | jq -s . || echo "[]")
    fi
    
    if $JSON_MODE; then
        cat <<EOF
{
  "MODE": "project",
  "REPO_ROOT": "$REPO_ROOT",
  "PROJECT_TYPE": "$PROJECT_TYPE",
  "SCOPE": "$SCOPE",
  "SOURCE_FILES": $SOURCE_FILES,
  "HAS_GIT": "$HAS_GIT"
}
EOF
    else
        echo "Mode: Project-wide documentation"
        echo "Repo Root: $REPO_ROOT"
        echo "Project Type: $PROJECT_TYPE"
        echo "Scope: $SCOPE"
    fi
    exit 0
fi

# FEATURE MODE: Document specific spec-kit feature
eval "$(get_feature_paths)"

# Check if we're on a feature branch
if [[ ! "$CURRENT_BRANCH" =~ ^[0-9]{3}- ]] && [[ "$PROJECT_MODE" != "true" ]]; then
    # Not on feature branch, switch to project mode
    PROJECT_MODE=true
    
    SOURCE_FILES="[]"
    if command -v find >/dev/null 2>&1; then
        SOURCE_FILES=$(find . -type f \
            \( -name "*.java" -o -name "*.kt" -o -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.rs" \) \
            ! -path "*/node_modules/*" \
            ! -path "*/target/*" \
            ! -path "*/build/*" \
            ! -path "*/.git/*" \
            ! -path "*/dist/*" \
            2>/dev/null | jq -R . | jq -s . || echo "[]")
    fi
    
    if $JSON_MODE; then
        cat <<EOF
{
  "MODE": "project",
  "REPO_ROOT": "$REPO_ROOT",
  "PROJECT_TYPE": "$PROJECT_TYPE",
  "SCOPE": "$SCOPE",
  "SOURCE_FILES": $SOURCE_FILES,
  "HAS_GIT": "$HAS_GIT"
}
EOF
    else
        echo "Mode: Project-wide documentation (not on feature branch)"
        echo "Repo Root: $REPO_ROOT"
        echo "Project Type: $PROJECT_TYPE"
        echo "Scope: $SCOPE"
    fi
    exit 0
fi

# Validate feature directory exists
if [[ ! -d "$FEATURE_DIR" ]]; then
    echo "ERROR: Feature directory not found: $FEATURE_DIR" >&2
    exit 1
fi

# Find documentation artifacts
PLAN_FILE="$FEATURE_DIR/plan.md"
REVIEW_FILE="$FEATURE_DIR/review.md"
SPEC_FILE="$FEATURE_DIR/spec.md"
TASKS_FILE="$FEATURE_DIR/tasks.md"

# Get changed files (if git available)
CHANGED_FILES="[]"
if [[ "$HAS_GIT" == "true" ]]; then
    BASE_BRANCH="main"
    if ! git rev-parse --verify main >/dev/null 2>&1; then
        BASE_BRANCH="master"
    fi
    
    CHANGED_FILES=$(git diff --name-only "$BASE_BRANCH"...HEAD 2>/dev/null | jq -R . | jq -s . || echo "[]")
fi

# Output JSON for AI command to consume
if $JSON_MODE; then
    cat <<EOF
{
  "MODE": "feature",
  "FEATURE_DIR": "$FEATURE_DIR",
  "BRANCH": "$CURRENT_BRANCH",
  "PLAN_FILE": "$PLAN_FILE",
  "REVIEW_FILE": "$REVIEW_FILE",
  "SPEC_FILE": "$SPEC_FILE",
  "TASKS_FILE": "$TASKS_FILE",
  "PROJECT_TYPE": "$PROJECT_TYPE",
  "SCOPE": "$SCOPE",
  "CHANGED_FILES": $CHANGED_FILES,
  "REPO_ROOT": "$REPO_ROOT"
}
EOF
else
    echo "Mode: Feature documentation"
    echo "Feature: $CURRENT_BRANCH"
    echo "Feature Dir: $FEATURE_DIR"
    echo "Plan: $PLAN_FILE"
    echo "Review: $REVIEW_FILE"
    echo "Spec: $SPEC_FILE"
    echo "Project Type: $PROJECT_TYPE"
    echo "Scope: $SCOPE"
    echo "Repo Root: $REPO_ROOT"
fi
