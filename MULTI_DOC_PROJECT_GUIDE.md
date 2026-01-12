# Multi-Document Project Pattern - Complete Guide

This guide explains how to use the multi-document project pattern to manage multiple AsciiDoc documents (ICDs, SSDLC, specifications, etc.) in a single unified project with shared tooling and CI/CD infrastructure.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Overview](#overview)
3. [Setup Instructions](#setup-instructions)
4. [Project Structure](#project-structure)
5. [How It Works](#how-it-works)
6. [Usage](#usage)
7. [CI/CD Integration](#cicd-integration)
8. [Extending the Pattern](#extending-the-pattern)
9. [Best Practices](#best-practices)
10. [Troubleshooting](#troubleshooting)

## Quick Start

### Step 1: Run Setup Script

```bash
./setup-multi-doc-example.sh
```

This creates the complete example multi-document project with:
- Shared framework Makefile
- Three example documents (system ICD, component ICD, SSDLC)
- GitLab CI/CD configuration with matrix strategy
- Comprehensive documentation

### Step 2: Build the Examples

```bash
cd examples/multi-doc-project
make all
```

This generates all PDFs and HTMLs in the `build/` directory.

### Step 3: Explore

- Review the generated documents in `examples/multi-doc-project/build/`
- Check the `README.md` in the example project
- Examine the Makefile and .gitlab-ci.yml to understand the pattern

## Overview

### What is the Multi-Document Pattern?

The multi-document pattern allows you to manage multiple related documents in a single project with:

- **Shared Build Infrastructure**: Common Makefile rules in `framework/`
- **Consistent Tooling**: All documents use the same build process
- **Parallel CI/CD**: Documents build in parallel using GitLab matrix strategy
- **Unified Management**: Version control, review, and release as a unit

### Why Use This Pattern?

**Traditional Approach (One Document Per Repository)**
- ✗ Duplicated build scripts and configuration
- ✗ Inconsistent tooling across documents
- ✗ Difficult to maintain consistency
- ✗ Separate CI/CD pipelines
- ✗ Manual coordination for related docs

**Multi-Document Pattern**
- ✓ Single source of build logic
- ✓ Consistent tooling and processes
- ✓ Easy maintenance and updates
- ✓ Efficient parallel builds
- ✓ Coordinated versioning

### When to Use This Pattern

Use the multi-document pattern when you have:

- Multiple related documents (e.g., system ICD, component ICD, API spec)
- Documents that need coordinated versioning
- Documents that share assets (images, includes, themes)
- Need for consistent build and CI/CD processes
- 3 or more documents that benefit from parallel builds

## Setup Instructions

### Automatic Setup (Recommended)

Run the provided setup script:

```bash
./setup-multi-doc-example.sh
```

The script creates:

```
framework/
└── Makefile.include              # Shared build rules

examples/
└── multi-doc-project/
    ├── Makefile                   # Project Makefile
    ├── .gitlab-ci.yml            # CI/CD configuration
    ├── README.md                  # Project documentation
    ├── system-icd.adoc            # Example document 1
    ├── component-icd.adoc         # Example document 2
    └── ssdlc.adoc                 # Example document 3
```

### Manual Setup

If you prefer manual setup or need to understand what the script does:

1. **Create directory structure:**
   ```bash
   mkdir -p framework
   mkdir -p examples/multi-doc-project
   ```

2. **Create `framework/Makefile.include`** (see setup script for full content)

3. **Create project Makefile** in `examples/multi-doc-project/Makefile`

4. **Create `.gitlab-ci.yml`** with matrix strategy

5. **Create your AsciiDoc documents** (`.adoc` files)

## Project Structure

### Framework Directory

```
framework/
└── Makefile.include              # Shared build rules for all projects
```

The `Makefile.include` provides:
- Common targets: `all`, `pdf`, `html`, `verify`, `clean`, `watch`, `help`
- Automatic bundler/system asciidoctor detection
- Pattern rules for PDF and HTML generation
- Verification rules for AsciiDoc syntax

### Multi-Document Project

```
examples/multi-doc-project/
├── Makefile                      # Project-specific configuration
├── .gitlab-ci.yml               # CI/CD with matrix strategy
├── README.md                     # Project documentation
├── system-icd.adoc               # Document 1
├── component-icd.adoc            # Document 2
├── ssdlc.adoc                    # Document 3
└── build/                        # Generated outputs (created on build)
    ├── system-icd.pdf
    ├── system-icd.html
    ├── component-icd.pdf
    ├── component-icd.html
    ├── ssdlc.pdf
    └── ssdlc.html
```

### Project Makefile Structure

```makefile
# List documents (without .adoc extension)
DOCUMENTS = system-icd component-icd ssdlc

# Create file list for verification
ADOC_FILES = $(addsuffix .adoc,$(DOCUMENTS))

# Build target lists
PDF_TARGETS = $(addprefix $(BUILD_DIR)/,$(addsuffix .pdf,$(DOCUMENTS)))
HTML_TARGETS = $(addprefix $(BUILD_DIR)/,$(addsuffix .html,$(DOCUMENTS)))

# Include shared framework
include ../../framework/Makefile.include

# Override targets for multiple documents
pdf: $(PDF_TARGETS)
html: $(HTML_TARGETS)

# Optional: Document-specific targets
system: $(BUILD_DIR)/system-icd.pdf $(BUILD_DIR)/system-icd.html
component: $(BUILD_DIR)/component-icd.pdf $(BUILD_DIR)/component-icd.html
ssdlc: $(BUILD_DIR)/ssdlc.pdf $(BUILD_DIR)/ssdlc.html
```

## How It Works

### Build Process

1. **User runs `make all`** in the project directory

2. **Project Makefile** includes `framework/Makefile.include`

3. **Framework provides** pattern rules:
   ```makefile
   $(BUILD_DIR)/%.pdf: %.adoc | $(BUILD_DIR)
       $(ASCIIDOCTOR_PDF) $(PDF_OPTS) $< -o $@
   ```

4. **Make resolves** dependencies and builds each document:
   - `system-icd.adoc` → `build/system-icd.pdf` + `build/system-icd.html`
   - `component-icd.adoc` → `build/component-icd.pdf` + `build/component-icd.html`
   - `ssdlc.adoc` → `build/ssdlc.pdf` + `build/ssdlc.html`

### CI/CD Process

1. **GitLab CI detects** `.gitlab-ci.yml` in project

2. **Verify stage** runs `make verify` to check AsciiDoc syntax

3. **Build stage** uses matrix strategy:
   ```yaml
   parallel:
     matrix:
       - DOCUMENT: system-icd
       - DOCUMENT: component-icd
       - DOCUMENT: ssdlc
   ```

4. **Three parallel jobs** run simultaneously:
   - Job 1: Build system-icd.pdf and system-icd.html
   - Job 2: Build component-icd.pdf and component-icd.html
   - Job 3: Build ssdlc.pdf and ssdlc.html

5. **Artifacts** are collected per job and available for download

6. **Deploy stage** (optional) publishes documents

## Usage

### Building Documents

#### Build All Documents

```bash
cd examples/multi-doc-project
make all                    # Build all PDFs and HTMLs
```

#### Build Specific Formats

```bash
make pdf                    # Build all PDFs only
make html                   # Build all HTMLs only
```

#### Build Specific Documents

```bash
make system                 # Build system-icd.pdf and system-icd.html
make component              # Build component-icd.pdf and component-icd.html
make ssdlc                  # Build ssdlc.pdf and ssdlc.html
```

#### Build Individual Outputs

```bash
make build/system-icd.pdf   # Build single PDF
make build/ssdlc.html       # Build single HTML
```

### Verification

```bash
make verify                 # Verify AsciiDoc syntax for all documents
```

This runs `asciidoctor -o /dev/null` on each file to check for errors without generating output.

### Development Workflow

#### Watch Mode

```bash
make watch
```

Automatically rebuilds documents when `.adoc` files change. Requires `inotifywait` (Linux) or `entr` (macOS/Linux).

Install:
- Linux: `apt install inotify-tools`
- macOS: `brew install entr`

#### Clean Build

```bash
make clean                  # Remove all build artifacts
make all                    # Full rebuild
```

### Get Help

```bash
make help                   # Show available targets and documents
```

## CI/CD Integration

### GitLab CI/CD Configuration

The `.gitlab-ci.yml` provides three approaches:

#### 1. Matrix Strategy (Default, Recommended)

```yaml
build:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  parallel:
    matrix:
      - DOCUMENT: system-icd
      - DOCUMENT: component-icd
      - DOCUMENT: ssdlc
  script:
    - asciidoctor-pdf ${DOCUMENT}.adoc -o build/${DOCUMENT}.pdf
    - asciidoctor ${DOCUMENT}.adoc -o build/${DOCUMENT}.html
  artifacts:
    paths:
      - build/${DOCUMENT}.pdf
      - build/${DOCUMENT}.html
```

**Advantages:**
- Parallel execution (faster)
- Individual artifact downloads
- Clear per-document status
- Scales well with many documents

#### 2. Single Job Build (Alternative)

```yaml
build-all:
  stage: build
  script:
    - make all
  artifacts:
    paths:
      - build/*.pdf
      - build/*.html
  when: manual
```

**Advantages:**
- Simpler configuration
- Single artifact bundle
- Uses project Makefile directly

#### 3. Hybrid Approach

Use matrix for fast feedback, single-job for comprehensive builds:
- Matrix: Automatic on all commits
- Single-job: Manual on release tags

### Pipeline Stages

1. **Verify Stage**
   - Validates AsciiDoc syntax
   - Runs on all branches/MRs
   - Fast feedback on errors

2. **Build Stage**
   - Generates PDF and HTML
   - Parallel matrix execution
   - Produces artifacts

3. **Deploy Stage**
   - Publishes documents
   - Runs on master/tags only
   - Manual trigger for control

### Artifact Management

Each matrix job produces artifacts:
```
system-icd-main-a1b2c3d/
├── build/
│   ├── system-icd.pdf
│   └── system-icd.html
```

Download individual documents or all at once from the pipeline view.

## Extending the Pattern

### Adding a New Document

1. **Create the AsciiDoc file:**
   ```bash
   cd examples/multi-doc-project
   touch api-specification.adoc
   ```

2. **Add to Makefile:**
   ```makefile
   DOCUMENTS = system-icd component-icd ssdlc api-specification
   ```

3. **Add to CI/CD matrix:**
   ```yaml
   parallel:
     matrix:
       - DOCUMENT: system-icd
       - DOCUMENT: component-icd
       - DOCUMENT: ssdlc
       - DOCUMENT: api-specification  # New document
   ```

4. **(Optional) Add specific target:**
   ```makefile
   api: $(BUILD_DIR)/api-specification.pdf $(BUILD_DIR)/api-specification.html
   ```

5. **Build:**
   ```bash
   make all
   ```

### Customizing Build for Specific Document

Add document-specific rules in project Makefile:

```makefile
# Custom PDF theme for system ICD
$(BUILD_DIR)/system-icd.pdf: system-icd.adoc
	@echo "Generating system ICD with custom theme..."
	@$(ASCIIDOCTOR_PDF) $(PDF_OPTS) \
		-a pdf-theme=../../themes/pdf/custom-theme.yml \
		-a custom-attribute=value \
		$< -o $@

# Custom HTML stylesheet for SSDLC
$(BUILD_DIR)/ssdlc.html: ssdlc.adoc
	@echo "Generating SSDLC with custom stylesheet..."
	@$(ASCIIDOCTOR) $(HTML_OPTS) \
		-a stylesheet=../../themes/html/ssdlc.css \
		$< -o $@
```

### Sharing Content Across Documents

#### Option 1: Include Files

Create shared includes:

```
examples/multi-doc-project/
├── includes/
│   ├── common-intro.adoc
│   ├── revision-history.adoc
│   └── terminology.adoc
├── system-icd.adoc
└── component-icd.adoc
```

Include in documents:

```asciidoc
// In system-icd.adoc
include::includes/common-intro.adoc[]
include::includes/terminology.adoc[]
```

#### Option 2: Shared Attributes

Define common attributes in a file:

```asciidoc
// includes/common-attributes.adoc
:company-name: Acme Corporation
:project-name: Project Phoenix
:classification: Internal Use Only
```

Include at the top of each document:

```asciidoc
include::includes/common-attributes.adoc[]

= {project-name} System ICD
```

#### Option 3: Document Variables in Makefile

Pass variables during build:

```makefile
COMMON_ATTRS = \
	-a company-name="Acme Corporation" \
	-a project-name="Project Phoenix" \
	-a classification="Internal"

$(BUILD_DIR)/%.pdf: %.adoc | $(BUILD_DIR)
	$(ASCIIDOCTOR_PDF) $(PDF_OPTS) $(COMMON_ATTRS) $< -o $@
```

### Creating a New Multi-Document Project

1. **Copy the example structure:**
   ```bash
   cp -r examples/multi-doc-project examples/my-new-project
   cd examples/my-new-project
   ```

2. **Update Makefile:**
   ```makefile
   DOCUMENTS = doc1 doc2 doc3
   ADOC_FILES = $(addsuffix .adoc,$(DOCUMENTS))
   # ... rest remains the same
   ```

3. **Create your documents:**
   ```bash
   cp system-icd.adoc doc1.adoc
   cp component-icd.adoc doc2.adoc
   cp ssdlc.adoc doc3.adoc
   ```

4. **Update .gitlab-ci.yml:**
   ```yaml
   parallel:
     matrix:
       - DOCUMENT: doc1
       - DOCUMENT: doc2
       - DOCUMENT: doc3
   ```

5. **Update README.md** with project-specific information

6. **Build and verify:**
   ```bash
   make verify
   make all
   ```

## Best Practices

### Project Organization

1. **One Project Per Topic Area**: Group related documents
   - Good: system-icd, component-icd, api-spec (all related to interfaces)
   - Avoid: random unrelated documents together

2. **Consistent Naming**: Use lowercase with hyphens
   - Good: `system-icd.adoc`, `api-specification.adoc`
   - Avoid: `SystemICD.adoc`, `API_Spec.adoc`

3. **Clear Directory Structure**:
   ```
   my-project/
   ├── Makefile
   ├── .gitlab-ci.yml
   ├── README.md
   ├── doc1.adoc
   ├── doc2.adoc
   ├── includes/              # Shared content
   └── images/                # Shared images
   ```

### Document Management

1. **Synchronized Versioning**: Version related documents together
2. **Cross-References**: Link between related documents
3. **Shared Terminology**: Use common terms/definitions files
4. **Consistent Style**: Apply same themes and formatting

### Build Configuration

1. **Use Framework**: Don't duplicate build logic
2. **Minimal Project Makefile**: Keep it simple, let framework handle complexity
3. **Document Variables**: Use Makefile variables for common settings
4. **Clear Targets**: Provide intuitive make targets

### CI/CD Configuration

1. **Matrix for 3+ Documents**: Parallel builds improve speed
2. **Verify First**: Catch syntax errors early
3. **Reasonable Artifacts**: Balance between granularity and convenience
4. **Manual Deploy**: Require explicit approval for deployment

### Documentation

1. **Project README**: Explain what documents are included and why
2. **Build Instructions**: Clear steps for local development
3. **CI/CD Status**: Link to pipeline badges
4. **Change History**: Document structure changes

### Version Control

1. **Track Source**: Commit all `.adoc` files
2. **Ignore Build**: Add `build/` to `.gitignore`
3. **Include Config**: Track Makefile and `.gitlab-ci.yml`
4. **Document Changes**: Clear commit messages for doc updates

## Troubleshooting

### Setup Issues

**Problem**: "framework/Makefile.include: No such file or directory"

**Solution**: Run the setup script:
```bash
./setup-multi-doc-example.sh
```

**Problem**: "Permission denied" when running setup script

**Solution**: Make script executable:
```bash
chmod +x setup-multi-doc-example.sh
./setup-multi-doc-example.sh
```

### Build Issues

**Problem**: Build fails for one document

**Solution**: Test individually:
```bash
make verify                                   # Check syntax
asciidoctor-pdf system-icd.adoc              # Build directly
make build/system-icd.pdf                     # Build via make
```

**Problem**: "command not found: asciidoctor"

**Solution**: Install dependencies:
```bash
bundle install                # If using Bundler
# OR
gem install asciidoctor asciidoctor-pdf  # System install
```

**Problem**: Build succeeds but output is wrong

**Solution**:
1. Clean and rebuild: `make clean && make all`
2. Check include paths in `.adoc` files
3. Verify attribute values
4. Check theme paths

### CI/CD Issues

**Problem**: Matrix builds don't run in parallel

**Solution**: 
- Requires GitLab 13.3+ for `parallel:matrix`
- Check GitLab version: Settings → CI/CD → Runners
- Use single-job build as fallback

**Problem**: Artifacts not found

**Solution**: Check artifact paths match build output:
```yaml
artifacts:
  paths:
    - build/${DOCUMENT}.pdf     # Must match actual location
    - build/${DOCUMENT}.html
```

**Problem**: Pipeline fails on "make verify"

**Solution**:
1. Run locally first: `make verify`
2. Check AsciiDoc syntax errors
3. Ensure all included files exist
4. Verify image paths are correct

### Watch Mode Issues

**Problem**: "Neither inotifywait nor entr found"

**Solution**: Install file monitoring tool:
```bash
# Linux
sudo apt install inotify-tools

# macOS
brew install entr
```

**Problem**: Watch mode doesn't detect changes

**Solution**:
- Save files properly (some editors use temp files)
- Check file permissions
- Try the other tool (entr vs inotifywait)

### Performance Issues

**Problem**: Builds are slow

**Solution**:
1. Use CI/CD matrix for parallel builds
2. Cache Docker images in CI/CD
3. Minimize diagram generation
4. Use incremental builds (only changed docs)

**Problem**: CI/CD pipeline times out

**Solution**:
1. Increase timeout in `.gitlab-ci.yml`:
   ```yaml
   build:
     timeout: 30m
   ```
2. Split into more matrix jobs
3. Reduce document complexity

## Additional Resources

### Documentation

- [AsciiDoctor User Manual](https://asciidoctor.org/docs/user-manual/)
- [AsciiDoctor PDF Theming Guide](https://docs.asciidoctor.org/pdf-converter/latest/theme/)
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [GitLab Matrix Strategy](https://docs.gitlab.com/ee/ci/yaml/#parallelmatrix)
- [GNU Make Manual](https://www.gnu.org/software/make/manual/)

### Example Projects

- `examples/multi-doc-project/` - Complete working example
- `examples/multi-doc-project/README.md` - Detailed project documentation

### Support Files

- `setup-multi-doc-example.sh` - Automated setup script
- `framework/Makefile.include` - Shared build rules
- `MULTI_DOC_EXAMPLE_README.md` - Quick reference guide

### Getting Help

1. Check this guide for common scenarios
2. Review example project README
3. Examine working example code
4. Consult AsciiDoctor documentation
5. Review GitLab CI/CD documentation

## Summary

The multi-document pattern provides a scalable, maintainable approach to managing multiple related documents:

**Key Components:**
- Shared framework with common build rules
- Project-specific Makefile listing documents
- GitLab CI/CD with matrix strategy for parallel builds
- Consistent tooling and processes

**Benefits:**
- Reduced maintenance burden
- Faster CI/CD pipelines
- Consistent output quality
- Easy to extend and modify

**Use When:**
- Managing 2+ related documents
- Need coordinated versioning
- Want consistent build processes
- Benefit from parallel builds

Start with the example project, understand the pattern, then adapt it to your specific needs.
