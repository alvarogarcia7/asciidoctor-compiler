# TASK.md - Task Management and Workflow

## Overview

This document describes the task management approach, workflow processes, and conventions used for tracking and completing work items in the AsciiDoctor ICD Template project.

## Development Workflow

### 1. Initial Setup
1. Clone the repository
2. Run `./setup.sh` to verify dependencies
3. Install required tools (asciidoctor, asciidoctor-pdf)
4. Test the build: `make all`

### 2. Making Changes
1. Edit `icd-template.adoc` source file
2. Run `make verify` to check AsciiDoc syntax and structure
3. Build outputs: `make all` or individual formats (`make pdf`, `make html`)
4. Review generated files in `build/` directory
5. Iterate until satisfied

### 3. Verification Process
Before committing changes, always run verification:
```bash
make verify          # Quick syntax validation
./scripts/verify.sh  # Comprehensive structure validation
```

### 4. Build Process
The project uses a Makefile-based build system:
- `make all` - Default target, builds both PDF and HTML
- `make pdf` - Generates PDF output only
- `make html` - Generates HTML output only
- `make clean` - Removes build artifacts
- `make watch` - Auto-rebuild on file changes (development mode)

## Automation Tools

### Build System (Makefile)
**Purpose**: Automates compilation of AsciiDoc to PDF and HTML formats

**Key Targets**:
- `all`: Compiles both PDF and HTML outputs
- `pdf`: Generates PDF using asciidoctor-pdf
- `html`: Generates HTML using asciidoctor
- `verify`: Runs syntax validation scripts
- `clean`: Removes build directory and artifacts
- `watch`: Monitors file changes and auto-rebuilds
- `help`: Displays available commands

**Configuration**:
- Input file: `icd-template.adoc`
- Output directory: `build/`
- PDF output: `build/icd-template.pdf`
- HTML output: `build/icd-template.html`

### Setup Script (`setup.sh`)
**Purpose**: Verifies that required dependencies are installed

**Functionality**:
- Checks for asciidoctor and asciidoctor-pdf
- Attempts automatic installation via Bundler if available
- Provides installation instructions if tools are missing
- Reports installation status and next steps

**Usage**:
```bash
./setup.sh
```

### Verification Script (`scripts/verify.sh`)
**Purpose**: Comprehensive validation of AsciiDoc document structure and content

**Checks Performed**:
1. **File Existence**: Verifies source file exists
2. **Document Structure**: Validates heading hierarchy and structure
3. **ECSS Compliance**: Ensures required sections are present:
   - Revision History
   - Applicable Documents
   - Terms, Definitions and Abbreviations
   - Terms and Definitions (subsection)
   - Abbreviations and Acronyms (subsection)
4. **Cross-References**: Validates all cross-references have matching anchors
5. **Internal Links**: Checks for broken xref links
6. **Table Formatting**: Validates table syntax and structure
7. **List Formatting**: Checks list syntax
8. **Placeholder Content**: Identifies TBD/TBC/TODO markers
9. **Required Attributes**: Verifies document metadata

**Output**:
- Color-coded status messages (✓ success, ✗ error, ⚠ warning)
- Line-by-line issue reporting
- Summary report with error/warning counts
- Exit code 0 for success, 1 for failures

**Usage**:
```bash
./scripts/verify.sh
# Or via Makefile:
make verify
```

### Compilation Script (`scripts/compile.sh`)
**Purpose**: Advanced compilation with logging and flexible options

**Features**:
- Supports both PDF and HTML compilation
- Configurable output directory
- Custom PDF themes
- Additional document attributes
- Detailed logging to timestamped log files
- Exit code handling for CI/CD integration

**Usage Examples**:
```bash
# Basic compilation (both formats)
./scripts/compile.sh

# PDF only
./scripts/compile.sh -p

# HTML only
./scripts/compile.sh -h

# Custom theme and attributes
./scripts/compile.sh -t custom-theme -a revnumber=2.0 -a status=draft

# Specify input file
./scripts/compile.sh document.adoc

# Custom output directory
./scripts/compile.sh -o /path/to/output
```

**Log Files**: Located in `build/logs/compile_YYYYMMDD_HHMMSS.log`

## File Watching and Auto-Rebuild

### Development Mode
Use `make watch` for continuous development:
```bash
make watch
```

**Requirements**:
- **Linux**: `inotifywait` (from inotify-tools package)
- **macOS/Linux**: `entr` (alternative file watcher)

**Installation**:
```bash
# Ubuntu/Debian
sudo apt install inotify-tools entr

# macOS
brew install entr
```

**Behavior**:
- Monitors `icd-template.adoc` for changes
- Automatically runs `make all` when file is modified
- Continues running until interrupted (Ctrl+C)

## CI/CD Integration

### Continuous Integration (Future)
While no CI/CD pipeline is currently configured, the project is structured to support automated workflows:

**Recommended GitHub Actions Workflow**:
```yaml
name: Build and Verify

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y ruby-full
          gem install asciidoctor asciidoctor-pdf
      - name: Verify document
        run: make verify
      - name: Build outputs
        run: make all
      - name: Upload artifacts
        uses: actions/upload-artifact@v2
        with:
          name: icd-outputs
          path: build/
```

### Pre-commit Hooks (Recommended)
Consider adding a `.git/hooks/pre-commit` script:
```bash
#!/bin/bash
echo "Running verification..."
make verify || {
    echo "Verification failed. Commit aborted."
    exit 1
}
```

## Task Tracking Conventions

### Work Item Categories
1. **Content Updates**: Modifications to `icd-template.adoc`
2. **Build System**: Changes to Makefile or build scripts
3. **Verification**: Updates to validation logic
4. **Documentation**: README, AGENTS.md, TASK.md updates
5. **Infrastructure**: CI/CD, tooling, dependencies

### Checklist for Changes
- [ ] Edit source file(s)
- [ ] Run `make verify` - all checks pass
- [ ] Run `make all` - builds complete successfully
- [ ] Review PDF output in `build/icd-template.pdf`
- [ ] Review HTML output in `build/icd-template.html`
- [ ] Update documentation if needed
- [ ] Test with `bundle exec` if using Bundler
- [ ] Commit changes with descriptive message

### Quality Gates
All changes must pass:
1. **Syntax Validation**: `make verify` exits with code 0
2. **Build Success**: `make all` completes without errors
3. **Manual Review**: Generated outputs are correct and well-formatted

## Dependency Management

### Ruby Gems (via Bundler)
**Gemfile** specifies project dependencies:
- `asciidoctor ~> 2.0`
- `asciidoctor-pdf ~> 2.3`

**Installation**:
```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

**Usage**: Prefix all make commands with `bundle exec`:
```bash
bundle exec make all
bundle exec make verify
```

### Build Artifacts
Generated files are placed in `build/` directory:
- `build/icd-template.pdf`
- `build/icd-template.html`
- `build/logs/` (compilation logs from scripts/compile.sh)

**Cleanup**:
```bash
make clean  # Removes entire build/ directory
```

### Version Control
The `.gitignore` includes:
- `build/` - Generated outputs
- `vendor/bundle/` - Bundler dependencies
- `.bundle/` - Bundler configuration
- Log files and temporary artifacts

## Best Practices

### Document Structure
1. Always include required ECSS sections
2. Use consistent heading hierarchy (don't skip levels)
3. Add anchors for cross-references: `[[anchor-name]]`
4. Reference anchors consistently: `<<anchor-name>>`

### Table Formatting
```asciidoc
[cols="1,2,3"]
|===
| Header 1 | Header 2 | Header 3

| Cell 1   | Cell 2   | Cell 3
|===
```

### Cross-References
```asciidoc
[[section-introduction]]
== Introduction

See <<section-introduction>> for details.
```

### Attributes and Metadata
Define at document start:
```asciidoc
= Document Title
:author: Author Name
:revnumber: 1.0
:revdate: 2024-01-01
:doctype: book
:toc: left
:toclevels: 3
```

## Troubleshooting

### Common Issues

**Issue**: `asciidoctor: command not found`
**Solution**: Run `./setup.sh` and follow installation instructions

**Issue**: `make verify` reports errors
**Solution**: Review error messages and fix AsciiDoc syntax issues

**Issue**: PDF/HTML output missing or corrupted
**Solution**: Check `build/logs/` for compilation errors

**Issue**: `make watch` not working
**Solution**: Install `inotifywait` or `entr` as shown above

### Getting Help
1. Review AsciiDoc syntax: https://docs.asciidoctor.org/asciidoc/latest/
2. Check Makefile for available targets: `make help`
3. Review verification output: `./scripts/verify.sh`
4. Check compilation logs: `cat build/logs/compile_*.log`

## Summary

This project uses a streamlined workflow centered around:
1. **Makefile** for build automation
2. **Verification scripts** for quality assurance
3. **Compilation scripts** for flexible builds
4. **File watching** for development efficiency
5. **Clear conventions** for document structure

All automation is designed to ensure consistent, high-quality ICD documents that comply with ECSS standards.
