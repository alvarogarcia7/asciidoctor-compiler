# AsciiDoc Template Repository Guide

This comprehensive guide documents the template repository structure, initialization workflow, customization procedures, multi-document project setup, CI/CD configuration, and framework upgrade procedures.

## Table of Contents

- [Repository Overview](#repository-overview)
- [Repository Structure](#repository-structure)
- [Initialization Workflow](#initialization-workflow)
- [Template Customization](#template-customization)
- [Multi-Document Projects](#multi-document-projects)
- [CI/CD Configuration](#cicd-configuration)
- [Framework Upgrades](#framework-upgrades)
- [Best Practices](#best-practices)

---

## Repository Overview

This repository serves as a comprehensive template system for creating professional AsciiDoc documentation projects. It provides:

- **Multiple Document Types**: Pre-configured templates for ICD (Interface Control Documents), SSDLC (Secure Software Development Lifecycle), and generic documentation
- **Automated Initialization**: Interactive script-based project setup with metadata collection and placeholder replacement
- **Build Automation**: Makefile-based build system with PDF and HTML generation
- **CI/CD Integration**: GitLab CI pipeline templates for automated builds and deployments
- **Theming System**: Customizable PDF (YAML) and HTML (CSS) themes for consistent branding
- **Development Tools**: Verification scripts, watch mode, and Docker support

### Key Features

- **Template-Driven**: Start with battle-tested document structures following industry standards (ECSS, etc.)
- **Customizable**: Extensive customization options for organizational branding and requirements
- **Automated**: One-command project initialization and build automation
- **Version-Controlled**: Git-friendly source format with human-readable diffs
- **Professional Output**: High-quality PDF and HTML generation with custom themes

---

## Repository Structure

### Directory Layout

```
template-repository/
├── templates/                    # Document templates
│   ├── icd/                     # ICD-specific resources
│   ├── ssdlc/                   # SSDLC-specific resources
│   ├── generic/                 # Generic document resources
│   ├── icd-template.adoc        # ICD template file
│   ├── ssdlc-template.adoc      # SSDLC template file
│   ├── generic-template.adoc    # Generic template file
│   └── README.md                # Template documentation
│
├── ci-templates/                # CI/CD pipeline templates
│   ├── .gitlab-ci-icd.yml       # ICD CI pipeline
│   ├── .gitlab-ci-ssdlc.yml     # SSDLC CI pipeline (with security)
│   ├── .gitlab-ci-generic.yml   # Generic CI pipeline
│   └── README.md                # CI template documentation
│
├── themes/                      # Styling themes
│   ├── pdf/                     # PDF themes (YAML)
│   │   ├── ecss-default-theme.yml
│   │   ├── minimal-theme.yml
│   │   ├── corporate-theme.yml
│   │   └── dark-theme.yml
│   ├── html/                    # HTML themes (CSS)
│   │   ├── ecss-default.css
│   │   ├── minimal.css
│   │   ├── corporate.css
│   │   └── dark.css
│   └── README.md                # Theme documentation
│
├── scripts/                     # Utility scripts
│   ├── verify.sh                # Document verification
│   └── compile.sh               # Advanced compilation
│
├── init-project.sh              # Project initialization script
├── Makefile                     # Build automation
├── Gemfile                      # Ruby dependencies
├── Dockerfile                   # Docker build environment
├── docker-compose.yml           # Docker compose configuration
├── setup.sh                     # Environment setup verification
├── verify.sh                    # Quick verification wrapper
│
├── README.md                    # Main repository documentation
├── TEMPLATE-README.md           # This file (template guide)
├── AGENTS.md                    # AI agent context and commands
└── .gitignore                   # Git ignore patterns
```

### Core Components

#### Templates Directory (`templates/`)

Contains AsciiDoc document templates for different documentation types:

- **`icd-template.adoc`**: Comprehensive Interface Control Document template with interface specifications, data definitions, protocol documentation, and ECSS compliance features
- **`ssdlc-template.adoc`**: Secure Software Development Lifecycle template with security requirements, threat modeling, and compliance tracking
- **`generic-template.adoc`**: Flexible general-purpose template for any technical documentation

Each template includes:
- Document metadata and attributes
- Professional cover page
- Document control sections (revision history, applicable documents, terms)
- Template-specific main content sections
- Appendices for supplementary information
- Pre-configured cross-references and requirement IDs

#### CI Templates Directory (`ci-templates/`)

GitLab CI pipeline templates optimized for each document type:

- **`.gitlab-ci-icd.yml`**: ICD pipeline with verification, build, and deployment stages
- **`.gitlab-ci-ssdlc.yml`**: Extended pipeline with security scanning and compliance validation
- **`.gitlab-ci-generic.yml`**: Flexible pipeline with multiple output formats and GitLab Pages support

All pipelines include:
- Syntax and structure verification
- Parallel PDF and HTML builds
- Artifact management with branch-specific retention
- Manual deployment controls
- Build logging and error reporting

#### Themes Directory (`themes/`)

Professional styling themes for consistent document branding:

**PDF Themes (YAML):**
- Control page layout, typography, colors, spacing, headers/footers
- ECSS-compliant default theme for aerospace documentation
- Minimal, corporate, and dark themes for various use cases
- Fully customizable through YAML configuration

**HTML Themes (CSS):**
- Responsive design with mobile-friendly layouts
- Print-optimized styles
- CSS custom properties for easy customization
- Matching aesthetics with PDF themes

#### Initialization Script (`init-project.sh`)

Interactive Bash script that automates new project creation:

**Workflow:**
1. Verifies template availability
2. Prompts for project type selection (ICD/SSDLC/Generic)
3. Collects document metadata (title, author, ID, organization, etc.)
4. Displays configuration summary for confirmation
5. Copies and customizes the selected template
6. Generates project-specific Makefile
7. Sets up GitLab CI configuration
8. Creates project directory structure
9. Displays next steps and usage instructions

**Features:**
- Color-coded output for clarity
- Default values for quick setup
- Safe overwrite handling with confirmation
- Comprehensive placeholder replacement
- Modular, maintainable code structure

#### Build System (`Makefile`)

Makefile-based build automation with targets for:

- `make all`: Build both PDF and HTML (default target)
- `make pdf`: Generate PDF output only
- `make html`: Generate HTML output only
- `make verify`: Run document syntax validation
- `make clean`: Remove build artifacts
- `make watch`: Auto-rebuild on file changes (requires inotifywait/entr)
- `make docker-build`: Build Docker image
- `make help`: Display available targets

**Features:**
- Automatic bundler detection
- Diagram support (asciidoctor-diagram)
- Build directory creation
- Error handling and logging
- Cross-platform compatibility (Linux/macOS)

#### Docker Environment

Complete containerized build environment requiring no local dependencies:

**Includes:**
- AsciiDoctor (HTML generation)
- AsciiDoctor-PDF (PDF generation)
- AsciiDoctor-Diagram (diagram rendering)
- PlantUML and Graphviz (diagram engines)
- Java runtime (for PlantUML)
- Build tools (grep, bash, make)
- Watch tools (inotify-tools)

**Usage:**
```bash
# Build Docker image
make docker-build

# Build documents in container
docker-compose run --rm asciidoctor make all

# Interactive shell
docker-compose run --rm asciidoctor bash
```

---

## Initialization Workflow

### Using `init-project.sh`

The recommended way to create new documentation projects is with the initialization script.

#### Step 1: Prepare the Repository

Ensure you have the template repository:

```bash
# Clone the template repository
git clone <template-repo-url> my-new-project
cd my-new-project

# Ensure init-project.sh is executable
chmod +x init-project.sh
```

#### Step 2: Run the Initialization Script

```bash
./init-project.sh
```

The script presents an interactive interface:

```
════════════════════════════════════════════════════════════════
  AsciiDoc Project Initialization Script v1.0.0
════════════════════════════════════════════════════════════════
```

#### Step 3: Select Project Type

```
════════════════════════════════════════════════════════════════
  Project Type Selection
════════════════════════════════════════════════════════════════

  1) ICD     - Interface Control Document
  2) SSDLC   - Secure Software Development Lifecycle
  3) Generic - General AsciiDoc documentation

Select project type [1-3]:
```

**Choose based on your documentation needs:**

- **ICD (1)**: For system interfaces, communication protocols, data specifications
- **SSDLC (2)**: For security planning, threat models, compliance documentation
- **Generic (3)**: For user manuals, design docs, specifications, general technical writing

#### Step 4: Provide Document Metadata

The script collects essential metadata with sensible defaults:

```
════════════════════════════════════════════════════════════════
  Document Metadata
════════════════════════════════════════════════════════════════

Document name (without extension) [my-document]: spacecraft-telemetry-icd
Document title [spacecraft-telemetry-icd]: Spacecraft Telemetry Interface Specification
Document ID [DOC-20240115-001]: SC-ICD-TLM-001
Author name [john]: Jane Smith
Organization name [My Organization]: Aerospace Corp
Project name [spacecraft-telemetry-icd]: Mars Observer Mission
Initial revision [0.1]: 0.1
Revision date [2024-01-15]: 2024-01-15
Classification level [UNCLASSIFIED]: RESTRICTED
Distribution statement [Approved for public release]: Internal Use Only
Contract number (optional) [N/A]: NASA-2024-001
Document status [Draft]: Draft
```

**Tips:**
- Press Enter to accept defaults (shown in brackets)
- Document name becomes the filename (e.g., `spacecraft-telemetry-icd.adoc`)
- Use consistent naming patterns for document IDs
- Classification and distribution control document access

#### Step 5: Review Configuration Summary

The script displays all collected information for confirmation:

```
════════════════════════════════════════════════════════════════
  Configuration Summary
════════════════════════════════════════════════════════════════

  Project Type:      ICD
  Document Name:     spacecraft-telemetry-icd
  Document Title:    Spacecraft Telemetry Interface Specification
  Document ID:       SC-ICD-TLM-001
  Author:            Jane Smith
  Organization:      Aerospace Corp
  Project Name:      Mars Observer Mission
  Revision:          0.1
  Date:              2024-01-15
  Classification:    RESTRICTED
  Distribution:      Internal Use Only
  Contract Number:   NASA-2024-001
  Status:            Draft

Proceed with these settings? [Y/n]:
```

Type `Y` or press Enter to proceed.

#### Step 6: Project Generation

The script performs the following actions:

1. **Copies Template**: Selected template copied to `<document-name>.adoc`
2. **Replaces Placeholders**: All `[Placeholder]` values replaced with your metadata
3. **Updates Attributes**: AsciiDoc document attributes customized
4. **Generates Makefile**: Custom Makefile created with correct filenames
5. **Copies CI Template**: Appropriate GitLab CI configuration installed
6. **Updates CI Variables**: CI configuration customized for your document
7. **Creates Directories**: Project structure (`build/`, `images/`, `scripts/`) created

#### Step 7: Completion and Next Steps

```
════════════════════════════════════════════════════════════════
  Project Initialization Complete!
════════════════════════════════════════════════════════════════

  Document file:     spacecraft-telemetry-icd.adoc
  Makefile:          Makefile
  GitLab CI:         .gitlab-ci.yml

ℹ Next steps:

  1. Review and edit spacecraft-telemetry-icd.adoc
  2. Build the document:
     make all        - Build both PDF and HTML
     make pdf        - Build PDF only
     make html       - Build HTML only

  3. Verify the document:
     make verify     - Run syntax verification

  4. Watch for changes (auto-rebuild):
     make watch      - Auto-compile on file changes

ℹ GitLab CI pipeline is configured and ready to use

✓ Happy documenting! 📝
```

### Manual Initialization (Without Script)

If you prefer manual setup or need custom initialization:

```bash
# 1. Copy desired template
cp templates/icd-template.adoc my-document.adoc

# 2. Edit document and replace placeholders manually
#    - [Author Name] → Your Name
#    - [Document ID] → DOC-001
#    - [Project Name] → Your Project
#    - [Organization Name] → Your Organization
#    - etc.

# 3. Copy and customize Makefile
cp Makefile Makefile.new
# Edit: ASCIIDOC_FILE, PDF_OUTPUT, HTML_OUTPUT

# 4. Copy CI template (optional)
cp ci-templates/.gitlab-ci-icd.yml .gitlab-ci.yml
# Edit: DOCUMENT_FILE and OUTPUT_NAME variables

# 5. Create project structure
mkdir -p build images scripts
```

### Post-Initialization Tasks

After initialization:

1. **Review Document**: Open `.adoc` file and review all sections
2. **Customize Content**: Replace template content with your actual documentation
3. **Test Build**: Run `make all` to ensure everything works
4. **Version Control**: Initialize git repository and make initial commit
5. **Configure CI/CD**: If using GitLab, verify pipeline configuration

```bash
# Test build
make all

# Initialize version control
git init
git add .
git commit -m "Initial project setup from template"

# Push to GitLab (if using CI/CD)
git remote add origin <your-gitlab-repo>
git push -u origin master
```

---

## Template Customization

### Organizational Customization

To adapt templates for your organization's needs:

#### 1. Customizing Template Files

**Create Organization-Specific Templates:**

```bash
# Copy existing template as base
cp templates/icd-template.adoc templates/icd-myorg-template.adoc

# Edit to include:
# - Organization-specific cover page layout
# - Standard compliance requirements
# - Mandatory document sections
# - Pre-filled applicable documents
# - Organization-specific terminology
# - Standard appendices
```

**Common Customizations:**

1. **Cover Page Branding**: Add organization logo, standard footer, classification markings
2. **Document Control**: Pre-fill standard applicable documents, reference standards
3. **Section Structure**: Add/remove sections per organizational standards
4. **Requirement Formats**: Customize requirement ID patterns (ORG-REQ-XXX)
5. **Terminology**: Pre-populate with organization-specific terms and abbreviations
6. **Appendices**: Include standard forms, templates, checklists

**Example Customization (Cover Page):**

```asciidoc
// Original template
= Interface Control Document
[Author Name]
:organization: [Organization Name]

// Customized for organization
= Interface Control Document
[Author Name]
:organization: Aerospace Systems Corporation
:logo-image: images/asc-logo.png
:footer-text: Aerospace Systems Corporation - Proprietary
:classification-marking: COMPANY CONFIDENTIAL
```

#### 2. Customizing Document Attributes

Create a standard attributes include file:

**File: `templates/standard-attributes.adoc`**

```asciidoc
// Organization Standard Attributes
:organization: Aerospace Systems Corporation
:org-abbrev: ASC
:org-address: 123 Space Center Drive, Houston, TX
:org-website: https://aerospace-systems.example.com
:compliance-standard: ECSS-E-ST-70C
:quality-system: ISO 9001:2015
:classification-levels: UNCLASSIFIED|INTERNAL|CONFIDENTIAL|SECRET
:default-classification: INTERNAL
:document-retention: 7 years minimum
:approval-authority: Engineering Review Board
```

**Include in templates:**

```asciidoc
= Document Title
include::standard-attributes.adoc[]

// Document-specific attributes
:document-id: DOC-001
:project-name: Project Phoenix
```

#### 3. Creating Custom Sections

Add organization-mandated sections:

```asciidoc
== Configuration Management
// Your organization may require this section

=== Baseline Identification
// Document baselines per your CM process

=== Change Control Process
// Link to organization change control procedures

=== Version Control
// Describe version control requirements

== Quality Assurance
// QA requirements per organizational standards

=== Review Process
// Peer review, technical review, approval workflow

=== Acceptance Criteria
// Define acceptance criteria per QA procedures
```

#### 4. Modifying init-project.sh for Organization

Customize the initialization script:

```bash
# Edit init-project.sh

# Update default values
DEFAULT_ORGANIZATION="Aerospace Systems Corporation"
DEFAULT_CLASSIFICATION="INTERNAL"
DEFAULT_DISTRIBUTION="Company Confidential - Internal Use Only"
DEFAULT_APPROVAL_AUTHORITY="Engineering Review Board"

# Add organization-specific prompts
prompt_metadata() {
    # ... existing prompts ...
    
    # Add custom prompt
    DEPARTMENT=$(prompt_with_default "Department" "Systems Engineering")
    PROJECT_CODE=$(prompt_with_default "Project code" "PRJ-001")
    COST_CENTER=$(prompt_with_default "Cost center" "CC-1234")
}

# Update placeholder replacement
update_placeholders() {
    # ... existing replacements ...
    
    # Add custom replacements
    sed -i.bak "s/\[Department\]/$DEPARTMENT/g" "$temp_file"
    sed -i.bak "s/\[Project Code\]/$PROJECT_CODE/g" "$temp_file"
    sed -i.bak "s/\[Cost Center\]/$COST_CENTER/g" "$temp_file"
}
```

#### 5. Customizing Themes

**Create Organization Theme:**

```bash
# Copy and customize PDF theme
cp themes/pdf/ecss-default-theme.yml themes/pdf/myorg-theme.yml
```

**Edit `themes/pdf/myorg-theme.yml`:**

```yaml
# Organization-specific colors
heading:
  font_color: 003366  # Company blue

link:
  font_color: 0066cc  # Company light blue

# Organization fonts (if using custom fonts)
base:
  font_family: CorporateFont  # Your corporate font

# Organization logo on title page
title_page:
  logo:
    image: image:images/company-logo.png[pdfwidth=2.5in]
    align: center

# Standard footer with organization info
footer:
  recto:
    left:
      content: 'Aerospace Systems Corp'
    center:
      content: '{document-id}'
    right:
      content: 'Page {page-number}'
```

**Create matching HTML theme:**

```css
/* themes/html/myorg.css */
:root {
  --color-primary: #003366;        /* Company blue */
  --color-secondary: #0066cc;      /* Company light blue */
  --logo-path: url('../images/company-logo.png');
  --font-family-base: 'Corporate Font', Arial, sans-serif;
}

/* Add company logo to header */
#header::before {
  content: '';
  display: block;
  width: 200px;
  height: 60px;
  background-image: var(--logo-path);
  background-size: contain;
  background-repeat: no-repeat;
  margin: 0 auto 2rem;
}
```

**Update templates to use organization theme:**

```asciidoc
= Document Title
:pdf-theme: themes/pdf/myorg-theme.yml
:stylesheet: themes/html/myorg.css
```

#### 6. Pre-Populating Standard Content

Create include files for standard content:

**File: `templates/includes/standard-references.adoc`**

```asciidoc
==== Reference Documents

[cols="1,3,1,1", options="header"]
|===
|ID|Title|Document Number|Revision

|[RD1]
|Company Engineering Standard
|ASC-ENG-STD-001
|Rev. C

|[RD2]
|Configuration Management Procedures
|ASC-CM-PROC-001
|Rev. B

|[RD3]
|ECSS-E-ST-70C Space engineering - Ground systems and operations
|ECSS-E-ST-70C
|Rev. C

|===
```

**Include in templates:**

```asciidoc
== Document Control

include::includes/standard-references.adoc[]
```

#### 7. Standardizing Document IDs

Create a document ID schema:

```bash
# Edit init-project.sh to enforce document ID patterns

validate_document_id() {
    local doc_id="$1"
    local pattern="^[A-Z]{2,4}-[A-Z]{2,4}-[0-9]{3,4}$"
    
    if [[ ! $doc_id =~ $pattern ]]; then
        print_error "Document ID must match pattern: XX-YYY-000"
        print_info "Examples: SYS-ICD-001, SEC-SSDLC-042, DOC-SPEC-123"
        return 1
    fi
    return 0
}

# Use in prompt_metadata()
while true; do
    DOCUMENT_ID=$(prompt_with_default "Document ID" "SYS-ICD-001")
    if validate_document_id "$DOCUMENT_ID"; then
        break
    fi
done
```

### Per-Project Customization

Once a project is initialized, customize for specific needs:

#### 1. Document Structure

Add/remove sections as needed:

```asciidoc
// Remove unused sections
// Simply comment out or delete

// Add project-specific sections
== System-Specific Considerations

=== Integration with Legacy Systems

=== Migration Strategy

=== Backward Compatibility
```

#### 2. Theme Overrides

Override specific theme settings without modifying theme files:

```asciidoc
= Document Title
:pdf-theme: themes/pdf/ecss-default-theme.yml
:pdf-themesdir: .
// Override specific values
:title-page-background-color: #003366
:heading-font-color: #0066cc
```

#### 3. Custom Attributes

Define project-specific attributes:

```asciidoc
:project-phase: Design Phase
:delivery-milestone: Milestone 3
:customer-name: NASA JPL
:contract-type: Firm Fixed Price
:security-classification: ITAR Controlled

// Use in document
This document is prepared for {customer-name} under {contract-type} contract.
Security Classification: {security-classification}
```

#### 4. Custom Includes

Modularize large documents:

```
project/
├── main-document.adoc
├── sections/
│   ├── introduction.adoc
│   ├── requirements.adoc
│   ├── specifications.adoc
│   └── appendices.adoc
└── images/
    └── diagrams/
```

**In `main-document.adoc`:**

```asciidoc
= Main Document Title

include::sections/introduction.adoc[]

include::sections/requirements.adoc[]

include::sections/specifications.adoc[]

include::sections/appendices.adoc[]
```

---

## Multi-Document Projects

Managing multiple related documents in a single repository.

### Repository Structure for Multi-Document Projects

```
multi-doc-project/
├── docs/
│   ├── icd/
│   │   ├── comms-icd.adoc
│   │   ├── data-icd.adoc
│   │   └── power-icd.adoc
│   ├── ssdlc/
│   │   ├── security-plan.adoc
│   │   └── threat-model.adoc
│   ├── specs/
│   │   ├── system-spec.adoc
│   │   └── subsystem-spec.adoc
│   └── shared/
│       ├── common-terms.adoc
│       ├── standard-refs.adoc
│       └── abbreviations.adoc
├── images/
│   ├── common/
│   ├── icd/
│   └── specs/
├── themes/
│   ├── pdf/
│   └── html/
├── scripts/
│   ├── build-all.sh
│   └── verify-all.sh
├── Makefile
├── .gitlab-ci.yml
└── README.md
```

### Master Makefile for Multi-Document Projects

**File: `Makefile`**

```makefile
.PHONY: all clean verify help icd ssdlc specs

# Directories
DOCS_DIR = docs
BUILD_DIR = build
ICD_DIR = $(DOCS_DIR)/icd
SSDLC_DIR = $(DOCS_DIR)/ssdlc
SPECS_DIR = $(DOCS_DIR)/specs

# Tools
ASCIIDOCTOR = bundle exec asciidoctor
ASCIIDOCTOR_PDF = bundle exec asciidoctor-pdf

# Build all documents
all: icd ssdlc specs

# Build ICD documents
icd:
	@echo "Building ICD documents..."
	@mkdir -p $(BUILD_DIR)/icd
	@$(ASCIIDOCTOR_PDF) -r asciidoctor-diagram $(ICD_DIR)/comms-icd.adoc -o $(BUILD_DIR)/icd/comms-icd.pdf
	@$(ASCIIDOCTOR) -r asciidoctor-diagram $(ICD_DIR)/comms-icd.adoc -o $(BUILD_DIR)/icd/comms-icd.html
	@$(ASCIIDOCTOR_PDF) -r asciidoctor-diagram $(ICD_DIR)/data-icd.adoc -o $(BUILD_DIR)/icd/data-icd.pdf
	@$(ASCIIDOCTOR) -r asciidoctor-diagram $(ICD_DIR)/data-icd.adoc -o $(BUILD_DIR)/icd/data-icd.html
	@echo "ICD documents built"

# Build SSDLC documents
ssdlc:
	@echo "Building SSDLC documents..."
	@mkdir -p $(BUILD_DIR)/ssdlc
	@$(ASCIIDOCTOR_PDF) $(SSDLC_DIR)/security-plan.adoc -o $(BUILD_DIR)/ssdlc/security-plan.pdf
	@$(ASCIIDOCTOR) $(SSDLC_DIR)/security-plan.adoc -o $(BUILD_DIR)/ssdlc/security-plan.html
	@echo "SSDLC documents built"

# Build specification documents
specs:
	@echo "Building specification documents..."
	@mkdir -p $(BUILD_DIR)/specs
	@$(ASCIIDOCTOR_PDF) $(SPECS_DIR)/system-spec.adoc -o $(BUILD_DIR)/specs/system-spec.pdf
	@$(ASCIIDOCTOR) $(SPECS_DIR)/system-spec.adoc -o $(BUILD_DIR)/specs/system-spec.html
	@echo "Specification documents built"

# Verify all documents
verify:
	@echo "Verifying all documents..."
	@for file in $(shell find $(DOCS_DIR) -name "*.adoc" -not -path "*/shared/*"); do \
		echo "Verifying $$file..."; \
		$(ASCIIDOCTOR) -o /dev/null $$file || exit 1; \
	done
	@echo "All documents verified successfully"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete"

# Help
help:
	@echo "Available targets:"
	@echo "  make all     - Build all documents"
	@echo "  make icd     - Build ICD documents only"
	@echo "  make ssdlc   - Build SSDLC documents only"
	@echo "  make specs   - Build specification documents only"
	@echo "  make verify  - Verify all documents"
	@echo "  make clean   - Remove build artifacts"
	@echo "  make help    - Show this help"
```

### Shared Content Management

Create reusable content modules:

**File: `docs/shared/common-terms.adoc`**

```asciidoc
==== Terms and Definitions

[glossary]
API:: Application Programming Interface
COTS:: Commercial Off-The-Shelf
ICD:: Interface Control Document
TBD:: To Be Determined
TBR:: To Be Resolved
```

**File: `docs/shared/standard-refs.adoc`**

```asciidoc
==== Reference Documents

[cols="1,3,1,1", options="header"]
|===
|ID|Title|Document Number|Revision

|[RD1]
|System Requirements Specification
|SYS-REQ-001
|1.0

|[RD2]
|Architecture Design Document
|SYS-ARCH-001
|1.2

|===
```

**Include in documents:**

```asciidoc
= Communication Interface Control Document

== Document Control

include::../shared/standard-refs.adoc[]

include::../shared/common-terms.adoc[]
```

### Cross-Document References

Reference between documents:

```asciidoc
// In comms-icd.adoc
[[comms-icd-section-5-2]]
=== Protocol Specification

// In data-icd.adoc
See <<../icd/comms-icd.adoc#comms-icd-section-5-2,Communication Protocol>>
for transport details.

// Or use external links in PDF/HTML
For protocol details, refer to the Communications ICD document.
```

### Multi-Document CI/CD Pipeline

**File: `.gitlab-ci.yml`**

```yaml
stages:
  - verify
  - build
  - deploy

variables:
  BUILD_DIR: "build"
  DOCS_DIR: "docs"

# Verify all documents
verify:all:
  stage: verify
  image: asciidoctor/docker-asciidoctor:latest
  script:
    - echo "Verifying all documents..."
    - find ${DOCS_DIR} -name "*.adoc" -not -path "*/shared/*" -exec asciidoctor -o /dev/null {} \;
    - echo "Verification complete"
  only:
    - branches

# Build ICD documents
build:icd:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  script:
    - mkdir -p ${BUILD_DIR}/icd
    - asciidoctor-pdf -r asciidoctor-diagram ${DOCS_DIR}/icd/comms-icd.adoc -o ${BUILD_DIR}/icd/comms-icd.pdf
    - asciidoctor -r asciidoctor-diagram ${DOCS_DIR}/icd/comms-icd.adoc -o ${BUILD_DIR}/icd/comms-icd.html
    - asciidoctor-pdf -r asciidoctor-diagram ${DOCS_DIR}/icd/data-icd.adoc -o ${BUILD_DIR}/icd/data-icd.pdf
    - asciidoctor -r asciidoctor-diagram ${DOCS_DIR}/icd/data-icd.adoc -o ${BUILD_DIR}/icd/data-icd.html
  artifacts:
    name: "icd-docs-${CI_COMMIT_REF_SLUG}"
    paths:
      - ${BUILD_DIR}/icd/
    expire_in: 7 days
  dependencies:
    - verify:all

# Build SSDLC documents
build:ssdlc:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  script:
    - mkdir -p ${BUILD_DIR}/ssdlc
    - asciidoctor-pdf ${DOCS_DIR}/ssdlc/security-plan.adoc -o ${BUILD_DIR}/ssdlc/security-plan.pdf
    - asciidoctor ${DOCS_DIR}/ssdlc/security-plan.adoc -o ${BUILD_DIR}/ssdlc/security-plan.html
  artifacts:
    name: "ssdlc-docs-${CI_COMMIT_REF_SLUG}"
    paths:
      - ${BUILD_DIR}/ssdlc/
    expire_in: 7 days
  dependencies:
    - verify:all

# Build specification documents
build:specs:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  script:
    - mkdir -p ${BUILD_DIR}/specs
    - asciidoctor-pdf ${DOCS_DIR}/specs/system-spec.adoc -o ${BUILD_DIR}/specs/system-spec.pdf
    - asciidoctor ${DOCS_DIR}/specs/system-spec.adoc -o ${BUILD_DIR}/specs/system-spec.html
  artifacts:
    name: "specs-${CI_COMMIT_REF_SLUG}"
    paths:
      - ${BUILD_DIR}/specs/
    expire_in: 7 days
  dependencies:
    - verify:all

# Deploy all documents
deploy:all:
  stage: deploy
  image: alpine:latest
  script:
    - echo "Deploying all documents..."
    # Add deployment commands here (e.g., rsync, scp, API calls)
  artifacts:
    name: "all-docs-${CI_COMMIT_REF_SLUG}"
    paths:
      - ${BUILD_DIR}/
    expire_in: 30 days
  dependencies:
    - build:icd
    - build:ssdlc
    - build:specs
  only:
    - master
    - tags
  when: manual
```

### Build Automation Scripts

**File: `scripts/build-all.sh`**

```bash
#!/bin/bash

set -e

BUILD_DIR="build"
DOCS_DIR="docs"

echo "Building all documents..."

# Create build directories
mkdir -p ${BUILD_DIR}/{icd,ssdlc,specs}

# Build ICD documents
echo "Building ICD documents..."
for doc in ${DOCS_DIR}/icd/*.adoc; do
    basename=$(basename "$doc" .adoc)
    echo "  - Building $basename..."
    bundle exec asciidoctor-pdf -r asciidoctor-diagram "$doc" -o "${BUILD_DIR}/icd/${basename}.pdf"
    bundle exec asciidoctor -r asciidoctor-diagram "$doc" -o "${BUILD_DIR}/icd/${basename}.html"
done

# Build SSDLC documents
echo "Building SSDLC documents..."
for doc in ${DOCS_DIR}/ssdlc/*.adoc; do
    basename=$(basename "$doc" .adoc)
    echo "  - Building $basename..."
    bundle exec asciidoctor-pdf "$doc" -o "${BUILD_DIR}/ssdlc/${basename}.pdf"
    bundle exec asciidoctor "$doc" -o "${BUILD_DIR}/ssdlc/${basename}.html"
done

# Build specification documents
echo "Building specification documents..."
for doc in ${DOCS_DIR}/specs/*.adoc; do
    basename=$(basename "$doc" .adoc)
    echo "  - Building $basename..."
    bundle exec asciidoctor-pdf "$doc" -o "${BUILD_DIR}/specs/${basename}.pdf"
    bundle exec asciidoctor "$doc" -o "${BUILD_DIR}/specs/${basename}.html"
done

echo "All documents built successfully!"
echo "Output directory: ${BUILD_DIR}/"
```

Make executable:

```bash
chmod +x scripts/build-all.sh
```

---

## CI/CD Configuration

### CI Template Selection

Choose the appropriate CI template based on your document type:

| Document Type | CI Template | Key Features |
|--------------|-------------|--------------|
| ICD | `.gitlab-ci-icd.yml` | Verification, PDF/HTML build, artifact management |
| SSDLC | `.gitlab-ci-ssdlc.yml` | Security scanning, compliance checking, secure artifacts |
| Generic | `.gitlab-ci-generic.yml` | Flexible stages, multiple formats, GitLab Pages |

### Basic CI Setup

**Step 1: Copy Template**

```bash
# For ICD projects
cp ci-templates/.gitlab-ci-icd.yml .gitlab-ci.yml

# For SSDLC projects
cp ci-templates/.gitlab-ci-ssdlc.yml .gitlab-ci.yml

# For generic documentation
cp ci-templates/.gitlab-ci-generic.yml .gitlab-ci.yml
```

**Step 2: Configure Variables**

Edit `.gitlab-ci.yml` to set project-specific variables:

```yaml
variables:
  DOCUMENT_FILE: "your-document.adoc"
  OUTPUT_NAME: "your-document"
  BUILD_DIR: "build"
  ARTIFACT_EXPIRATION: "7 days"
```

**Step 3: Commit and Push**

```bash
git add .gitlab-ci.yml
git commit -m "Add GitLab CI configuration"
git push origin master
```

The pipeline will automatically run on push.

### Advanced CI Configuration

#### Customizing Pipeline Stages

Add custom stages to your pipeline:

```yaml
stages:
  - verify
  - build
  - test
  - deploy
  - notify

# Custom test stage
test:links:
  stage: test
  image: alpine:latest
  script:
    - apk add --no-cache wget grep
    - echo "Checking for broken links in HTML output..."
    - wget --spider --recursive --no-parent build/*.html 2>&1 | grep -i "broken link" || true
  dependencies:
    - build:html
  allow_failure: true
```

#### Matrix Builds

Build multiple document variants:

```yaml
build:variants:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  parallel:
    matrix:
      - THEME: ["ecss-default", "minimal", "corporate"]
        FORMAT: ["pdf", "html"]
  script:
    - |
      if [ "$FORMAT" = "pdf" ]; then
        asciidoctor-pdf -a pdf-theme=themes/pdf/${THEME}-theme.yml \
          ${DOCUMENT_FILE} -o build/${OUTPUT_NAME}-${THEME}.pdf
      else
        asciidoctor -a stylesheet=themes/html/${THEME}.css \
          ${DOCUMENT_FILE} -o build/${OUTPUT_NAME}-${THEME}.html
      fi
  artifacts:
    name: "${OUTPUT_NAME}-${THEME}-${FORMAT}"
    paths:
      - build/
    expire_in: 7 days
```

#### Branch-Specific Behavior

Different behavior for different branches:

```yaml
# Short expiration for feature branches
build:pdf:feature:
  extends: .build_template
  artifacts:
    expire_in: 3 days
  only:
    - branches
  except:
    - master
    - main

# Long expiration for master
build:pdf:master:
  extends: .build_template
  artifacts:
    expire_in: 30 days
  only:
    - master
    - main

# Permanent retention for tags
build:pdf:release:
  extends: .build_template
  artifacts:
    expire_in: never
  only:
    - tags
```

#### Scheduled Builds

Configure scheduled pipelines for regular document rebuilds:

```yaml
# In .gitlab-ci.yml
rebuild:scheduled:
  stage: build
  script:
    - make all
  artifacts:
    paths:
      - build/
    expire_in: 90 days
  only:
    variables:
      - $CI_PIPELINE_SOURCE == "schedule"
```

**In GitLab UI:** CI/CD → Schedules → New Schedule
- Description: "Weekly documentation rebuild"
- Interval: `0 2 * * 0` (Every Sunday at 2 AM)
- Target Branch: master

#### Deployment Automation

Automate document deployment:

```yaml
deploy:production:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client rsync
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $DEPLOY_SERVER >> ~/.ssh/known_hosts
  script:
    - echo "Deploying documents to production..."
    - rsync -avz --delete build/ $DEPLOY_USER@$DEPLOY_SERVER:$DEPLOY_PATH/
    - echo "Deployment complete"
  environment:
    name: production
    url: https://docs.example.com
  only:
    - master
    - tags
  when: manual
```

**Required CI/CD Variables (Settings → CI/CD → Variables):**
- `SSH_PRIVATE_KEY`: SSH private key for deployment
- `DEPLOY_SERVER`: Target server hostname
- `DEPLOY_USER`: SSH username
- `DEPLOY_PATH`: Destination path on server

#### GitLab Pages Deployment

Publish HTML documentation to GitLab Pages:

```yaml
pages:
  stage: deploy
  image: alpine:latest
  script:
    - mkdir -p public
    - cp -r build/*.html public/
    - cp -r images public/
    - |
      cat > public/index.html <<EOF
      <!DOCTYPE html>
      <html>
      <head><title>Documentation Index</title></head>
      <body>
      <h1>Project Documentation</h1>
      <ul>
        <li><a href="document.html">Main Document</a></li>
      </ul>
      </body>
      </html>
      EOF
  artifacts:
    paths:
      - public
  only:
    - master
```

Access at: `https://<username>.gitlab.io/<project>/`

### CI/CD Best Practices

1. **Use Caching**: Cache gem dependencies for faster builds

```yaml
variables:
  BUNDLE_PATH: vendor/bundle

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - vendor/bundle

before_script:
  - bundle config set --local path 'vendor/bundle'
  - bundle install
```

2. **Fail Fast**: Run verification before expensive builds

```yaml
verify:
  stage: verify
  # Fast syntax check
  
build:pdf:
  stage: build
  needs:
    - verify  # Only run if verify succeeds
```

3. **Parallel Execution**: Build PDF and HTML in parallel

```yaml
build:pdf:
  stage: build
  # PDF build

build:html:
  stage: build
  # HTML build

# Both run simultaneously
```

4. **Artifact Management**: Set appropriate expiration

```yaml
# Feature branches: short retention
artifacts:
  expire_in: 3 days

# Master branch: longer retention
artifacts:
  expire_in: 30 days

# Tagged releases: permanent
artifacts:
  expire_in: never
```

5. **Security**: Protect sensitive documents

```yaml
# SSDLC template includes:
security:scan:
  stage: security
  script:
    - grep -r "API_KEY\|PASSWORD\|SECRET" docs/ || true
    - # Fail if secrets found
```

---

## Framework Upgrades

Upgrade AsciiDoctor and related tools without affecting document content.

### Understanding Framework Components

The documentation framework consists of:

- **Ruby**: Runtime environment
- **Bundler**: Dependency management
- **AsciiDoctor**: HTML generation engine
- **AsciiDoctor-PDF**: PDF generation engine
- **AsciiDoctor-Diagram**: Diagram rendering
- **PlantUML**: UML diagram generation
- **Graphviz**: Graph visualization

### Checking Current Versions

```bash
# Check Ruby version
ruby --version

# Check Bundler version
bundle --version

# Check gem versions
bundle exec asciidoctor --version
bundle exec asciidoctor-pdf --version

# Check all installed gems
bundle list
```

### Upgrading Process

#### Step 1: Backup Current State

```bash
# Create backup branch
git checkout -b backup-before-upgrade

# Commit current state
git add Gemfile Gemfile.lock
git commit -m "Backup before framework upgrade"

# Return to main branch
git checkout master
```

#### Step 2: Update Gemfile

**Edit `Gemfile`:**

```ruby
source 'https://rubygems.org'

# Update version constraints
gem 'asciidoctor', '~> 2.0', '>= 2.0.20'  # Was: '~> 2.0'
gem 'asciidoctor-pdf', '~> 2.3', '>= 2.3.10'  # Was: '~> 2.3'
gem 'asciidoctor-diagram', '~> 2.2', '>= 2.2.14'  # Was: '~> 2.2'
```

**Version Constraint Syntax:**
- `~> 2.0`: Allow patches (2.0.x) but not minor versions (2.1.x)
- `>= 2.0.20`: Minimum version
- `~> 2.0, >= 2.0.20`: Pessimistic version with minimum

#### Step 3: Update Dependencies

```bash
# Update gems
bundle update

# Or update specific gem
bundle update asciidoctor
bundle update asciidoctor-pdf

# Check what changed
git diff Gemfile.lock
```

#### Step 4: Test Documents

```bash
# Clean previous builds
make clean

# Build all documents
make all

# Verify output
ls -lh build/

# View PDFs and HTMLs to check for issues
```

#### Step 5: Check for Breaking Changes

```bash
# Run verification
make verify

# Build with verbose output
bundle exec asciidoctor-pdf -v icd-template.adoc -o build/test.pdf

# Check for warnings or errors
```

#### Step 6: Update Docker Image (if using Docker)

**Edit `Dockerfile`:**

```dockerfile
FROM asciidoctor/docker-asciidoctor:latest  # or specific version

# Verify versions in image
RUN asciidoctor --version && \
    asciidoctor-pdf --version && \
    asciidoctor-diagram --version
```

**Rebuild Docker image:**

```bash
make docker-build

# Test Docker build
docker-compose run --rm asciidoctor make all
```

#### Step 7: Update CI/CD

If CI uses Docker, ensure image version is current:

```yaml
# .gitlab-ci.yml
image: asciidoctor/docker-asciidoctor:latest  # or v1.74

# Or use Bundler in CI
build:pdf:
  image: ruby:3.2
  before_script:
    - bundle install
  script:
    - bundle exec asciidoctor-pdf document.adoc
```

#### Step 8: Commit Changes

```bash
# Add updated files
git add Gemfile Gemfile.lock Dockerfile

# Commit with clear message
git commit -m "Upgrade AsciiDoctor framework to v2.0.20

- Update asciidoctor to ~> 2.0, >= 2.0.20
- Update asciidoctor-pdf to ~> 2.3, >= 2.3.10
- Update asciidoctor-diagram to ~> 2.2, >= 2.2.14
- Rebuild Docker image with latest versions
- Tested: All documents build successfully"

# Push changes
git push origin master
```

### Handling Breaking Changes

#### Common Breaking Changes

1. **Deprecated Attributes**: Some document attributes may change

```asciidoc
// Old (deprecated)
:toc-placement: preamble

// New
:toc: preamble
```

2. **Theme YAML Changes**: PDF theme structure may evolve

```yaml
# Old
base_font_size: 10

# New
base:
  font_size: 10
```

3. **Syntax Changes**: AsciiDoc syntax may be tightened

```asciidoc
// Old (may work but warned)
|===
|Header 1|Header 2
|Cell 1|Cell 2
|===

// New (strict)
|===
| Header 1 | Header 2

| Cell 1 | Cell 2
|===
```

#### Migration Strategy

**Create Migration Script:**

```bash
#!/bin/bash
# migrate-documents.sh

echo "Migrating documents for AsciiDoctor 2.x..."

# Replace deprecated attributes
find docs/ -name "*.adoc" -type f -exec sed -i \
  's/:toc-placement: preamble/:toc: preamble/g' {} +

# Update table syntax (add spaces)
find docs/ -name "*.adoc" -type f -exec sed -i \
  's/|\([A-Za-z]\)/| \1/g' {} +

echo "Migration complete. Please review changes:"
git diff docs/
```

#### Testing Strategy

**Create Test Build:**

```bash
# Test on subset of documents first
bundle exec asciidoctor-pdf docs/simple-doc.adoc -o build/test.pdf

# If successful, test all documents
make clean && make all

# Compare output
diff -r build-old/ build/
```

### Ruby Version Upgrade

If upgrading Ruby itself:

#### Step 1: Check Compatibility

```bash
# Check minimum Ruby version for gems
grep "ruby" Gemfile

# Check Bundler compatibility
bundle platform --ruby
```

#### Step 2: Install New Ruby Version

```bash
# Using rbenv
rbenv install 3.2.0
rbenv local 3.2.0

# Using rvm
rvm install 3.2.0
rvm use 3.2.0

# Verify
ruby --version
```

#### Step 3: Reinstall Gems

```bash
# Clear bundle cache
bundle clean --force

# Reinstall gems for new Ruby version
bundle install

# Test
bundle exec asciidoctor --version
```

#### Step 4: Update .ruby-version File

```bash
# Create or update .ruby-version
echo "3.2.0" > .ruby-version

# Commit
git add .ruby-version
git commit -m "Upgrade to Ruby 3.2.0"
```

### Rollback Procedure

If upgrade causes issues:

```bash
# Restore from backup branch
git checkout backup-before-upgrade

# Restore Gemfile.lock
git checkout backup-before-upgrade -- Gemfile.lock

# Reinstall old versions
bundle install

# Test
make all

# If working, keep old versions
git add Gemfile.lock
git commit -m "Rollback framework upgrade due to issues"
```

### Maintaining Compatibility

**Use Version Ranges for Stability:**

```ruby
# Gemfile - Conservative approach
gem 'asciidoctor', '~> 2.0.18'  # Lock to specific minor version
gem 'asciidoctor-pdf', '~> 2.3.9'
gem 'asciidoctor-diagram', '~> 2.2.10'
```

**Pin Exact Versions for Critical Projects:**

```ruby
# Gemfile - Maximum stability
gem 'asciidoctor', '2.0.18'
gem 'asciidoctor-pdf', '2.3.9'
gem 'asciidoctor-diagram', '2.2.10'
```

**Document Framework Versions:**

Add to README or AGENTS.md:

```markdown
## Framework Versions

Last tested with:
- Ruby: 3.2.0
- Bundler: 2.4.22
- AsciiDoctor: 2.0.18
- AsciiDoctor-PDF: 2.3.9
- AsciiDoctor-Diagram: 2.2.10

Upgrade tested: 2024-01-15
```

### Continuous Integration for Upgrades

Add upgrade testing to CI:

```yaml
# .gitlab-ci.yml
test:upgrade:
  stage: test
  image: ruby:3.2
  script:
    - bundle update
    - bundle exec asciidoctor-pdf document.adoc -o build/test.pdf
    - test -f build/test.pdf
  allow_failure: true
  only:
    - schedules
```

---

## Best Practices

### Version Control

1. **Commit Document Source, Not Outputs**

```bash
# .gitignore
build/
*.pdf
*.html
vendor/bundle/
```

2. **Use Meaningful Commit Messages**

```bash
git commit -m "Add timing requirements to Interface IF-003

- Define message timing constraints
- Add timeout specifications
- Document retry behavior"
```

3. **Tag Releases**

```bash
# Tag document releases
git tag -a v1.0 -m "Release version 1.0 - Initial approved version"
git push origin v1.0
```

### Document Maintenance

1. **Regular Verification**

```bash
# Run verification regularly
make verify

# Check for broken links
grep -r "<<.*>>" *.adoc | grep "\[???\]"
```

2. **Keep Templates Updated**

```bash
# Periodically sync with template repository
git remote add template <template-repo-url>
git fetch template
git merge template/master --no-commit

# Review and keep relevant updates
```

3. **Maintain Revision History**

Update revision history table for every significant change:

```asciidoc
|1.1
|2024-02-01
|Added power interface specifications
|J. Smith
|Engineering Review Board
```

### Collaboration

1. **Use Feature Branches**

```bash
git checkout -b feature/add-power-interface
# Make changes
git commit -m "Add power interface specification"
git push origin feature/add-power-interface
# Create merge request
```

2. **Code Review for Documents**

Use merge requests for peer review of technical documentation.

3. **Document Dependencies**

Clearly document relationships between documents:

```asciidoc
==== Related Documents

This ICD depends on:
- System Requirements Specification (SYS-REQ-001)
- Architecture Design (SYS-ARCH-001)

This ICD is referenced by:
- Integration Test Plan (TEST-INT-001)
```

### Performance Optimization

1. **Use Build Caching**

```makefile
# Cache intermediate outputs
.INTERMEDIATE: diagrams/*.png
```

2. **Parallel Builds**

```bash
# Build multiple documents in parallel
make -j4 all
```

3. **Incremental Builds**

```makefile
# Only rebuild if source changed
$(BUILD_DIR)/%.pdf: %.adoc
	asciidoctor-pdf $< -o $@
```

### Documentation Quality

1. **Consistent Naming Conventions**

- Document IDs: `SYS-ICD-001`
- Requirement IDs: `IF001-FREQ-001`
- Section anchors: `[[interface-if001-specification]]`

2. **Use Style Guide**

Maintain organizational style guide for:
- Terminology
- Abbreviations
- Formatting conventions
- Section structure

3. **Automated Quality Checks**

```bash
# scripts/quality-check.sh
#!/bin/bash

echo "Running quality checks..."

# Check for TODO markers
if grep -r "TODO\|TBD\|TBR" docs/*.adoc; then
    echo "Warning: Found TODO items"
fi

# Check requirement ID format
if grep -rE "REQ-[0-9]+" docs/*.adoc | grep -v "REQ-[0-9]{3}"; then
    echo "Warning: Inconsistent requirement ID format"
fi

echo "Quality check complete"
```

### Security Considerations

1. **Classification Marking**

Always clearly mark document classification:

```asciidoc
:classification: CONFIDENTIAL
:distribution: Internal Use Only

*CONFIDENTIAL - Internal Use Only*
```

2. **Sensitive Information**

- Never commit credentials, API keys, or secrets
- Use placeholders for sensitive data
- Review diffs before committing

3. **Access Control**

- Use GitLab protected branches
- Require approvals for document releases
- Restrict CI/CD variable access

### Continuous Improvement

1. **Collect Feedback**

Create feedback mechanism:

```asciidoc
== Document Feedback

Please report errors or suggest improvements:

- Email: docs@example.com
- Issue Tracker: https://gitlab.example.com/project/issues
```

2. **Template Updates**

Regularly improve templates based on lessons learned.

3. **Metrics Tracking**

Track documentation metrics:
- Build times
- Error rates
- Review cycle times
- Document completeness

---

## Additional Resources

### Documentation

- **AsciiDoc Syntax**: https://docs.asciidoctor.org/asciidoc/latest/
- **AsciiDoctor Manual**: https://asciidoctor.org/docs/user-manual/
- **AsciiDoctor-PDF Theming**: https://docs.asciidoctor.org/pdf-converter/latest/theme/
- **GitLab CI/CD**: https://docs.gitlab.com/ee/ci/

### Repository Documentation

- `README.md`: Main repository documentation and quick start
- `AGENTS.md`: Build commands and CI/CD information
- `templates/README.md`: Template-specific documentation
- `ci-templates/README.md`: CI/CD pipeline documentation
- `themes/README.md`: Theme customization guide
- `INIT_PROJECT_GUIDE.md`: Detailed initialization guide

### Support

For questions or issues:

1. Check relevant README files
2. Review GitLab CI pipeline logs
3. Consult AsciiDoctor documentation
4. Open issue in repository issue tracker

---

**Version**: 1.0  
**Last Updated**: 2024-01-15  
**Maintained By**: Documentation Engineering Team
