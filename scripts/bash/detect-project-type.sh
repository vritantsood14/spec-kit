#!/usr/bin/env bash
# detect-project-type.sh - Auto-detect project type and structure

detect_project_type() {
    # Check for various project indicators
    if [[ -f "package.json" ]]; then
        if grep -q "\"react\"" package.json 2>/dev/null; then
            echo "react"
        elif grep -q "\"next\"" package.json 2>/dev/null; then
            echo "nextjs"
        elif grep -q "\"express\"" package.json 2>/dev/null; then
            echo "nodejs-api"
        elif grep -q "\"@nestjs\"" package.json 2>/dev/null; then
            echo "nestjs"
        else
            echo "nodejs"
        fi
    elif [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]] || [[ -f "build.gradle.kts" ]]; then
        if grep -q "spring-boot" pom.xml build.gradle build.gradle.kts 2>/dev/null; then
            echo "spring-boot"
        elif grep -q "quarkus" pom.xml build.gradle build.gradle.kts 2>/dev/null; then
            echo "quarkus"
        elif grep -q "micronaut" pom.xml build.gradle build.gradle.kts 2>/dev/null; then
            echo "micronaut"
        else
            echo "java"
        fi
    elif [[ -f "go.mod" ]]; then
        if grep -q "gin-gonic/gin" go.mod 2>/dev/null; then
            echo "go-gin"
        elif grep -q "gofiber/fiber" go.mod 2>/dev/null; then
            echo "go-fiber"
        else
            echo "golang"
        fi
    elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]] || [[ -f "pyproject.toml" ]]; then
        if grep -rq "fastapi\|FastAPI" . 2>/dev/null; then
            echo "python-fastapi"
        elif grep -rq "flask\|Flask" . 2>/dev/null; then
            echo "python-flask"
        elif grep -rq "django\|Django" . 2>/dev/null; then
            echo "python-django"
        else
            echo "python"
        fi
    elif [[ -f "Cargo.toml" ]]; then
        if grep -q "actix-web" Cargo.toml 2>/dev/null; then
            echo "rust-actix"
        elif grep -q "rocket" Cargo.toml 2>/dev/null; then
            echo "rust-rocket"
        else
            echo "rust"
        fi
    elif [[ -f "Gemfile" ]]; then
        if grep -q "rails" Gemfile 2>/dev/null; then
            echo "ruby-rails"
        elif grep -q "sinatra" Gemfile 2>/dev/null; then
            echo "ruby-sinatra"
        else
            echo "ruby"
        fi
    elif [[ -f "composer.json" ]]; then
        if grep -q "laravel" composer.json 2>/dev/null; then
            echo "php-laravel"
        elif grep -q "symfony" composer.json 2>/dev/null; then
            echo "php-symfony"
        else
            echo "php"
        fi
    elif [[ -f "Package.swift" ]]; then
        echo "swift"
    elif [[ -f ".csproj" ]] || [[ -f "*.csproj" ]]; then
        echo "dotnet"
    else
        echo "unknown"
    fi
}

detect_project_type
