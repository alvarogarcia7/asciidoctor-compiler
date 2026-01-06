#!/bin/bash
#
# Setup script for multi-document project example
# This script creates the directory structure and files for the example
#

set -e

echo "Setting up multi-document project example..."
echo ""

# Create directory structure
echo "Creating directory structure..."
mkdir -p framework
mkdir -p examples/multi-doc-project

echo "✓ Directory structure created"
echo ""

# Create framework/Makefile.include
echo "Creating framework/Makefile.include..."
cat > framework/Makefile.include << 'EOF'
# Framework Makefile.include
# Common build rules for AsciiDoc multi-document projects
# Include this in your project Makefile with: include ../../framework/Makefile.include

.PHONY: all pdf html verify clean watch help

# Default build directory if not specified
BUILD_DIR ?= build

# Detect if we're in Docker or using bundler
ifeq ($(shell command -v bundle 2> /dev/null && [ -f ../../Gemfile.lock ] && echo yes),yes)
	ASCIIDOCTOR = bundle exec asciidoctor
	ASCIIDOCTOR_PDF = bundle exec asciidoctor-pdf
else
	ASCIIDOCTOR = asciidoctor
	ASCIIDOCTOR_PDF = asciidoctor-pdf
endif

# Common asciidoctor options
ASCIIDOCTOR_OPTS = -r asciidoctor-diagram
PDF_OPTS = $(ASCIIDOCTOR_OPTS)
HTML_OPTS = $(ASCIIDOCTOR_OPTS)

# Default target: build all documents
all: pdf html

# PDF generation rule
$(BUILD_DIR)/%.pdf: %.adoc | $(BUILD_DIR)
	@echo "Generating PDF: $@"
	@$(ASCIIDOCTOR_PDF) $(PDF_OPTS) $< -o $@
	@echo "✓ PDF generated: $@"

# HTML generation rule
$(BUILD_DIR)/%.html: %.adoc | $(BUILD_DIR)
	@echo "Generating HTML: $@"
	@$(ASCIIDOCTOR) $(HTML_OPTS) $< -o $@
	@echo "✓ HTML generated: $@"

# Create build directory
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Verify AsciiDoc syntax
verify:
	@echo "Verifying AsciiDoc files..."
	@for file in $(ADOC_FILES); do \
		echo "Checking $$file..."; \
		$(ASCIIDOCTOR) -o /dev/null $$file && echo "✓ $$file syntax is valid" || exit 1; \
	done
	@echo "✓ All files verified successfully"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "✓ Build artifacts removed"

# Watch for changes (requires inotifywait or entr)
watch:
	@echo "Watching for changes to AsciiDoc files..."
	@if command -v inotifywait &> /dev/null; then \
		echo "Using inotifywait for file monitoring..."; \
		while true; do \
			inotifywait -e modify,create,delete $(ADOC_FILES) && \
			$(MAKE) all; \
		done \
	elif command -v entr &> /dev/null; then \
		echo "Using entr for file monitoring..."; \
		echo $(ADOC_FILES) | tr ' ' '\n' | entr -c $(MAKE) all; \
	else \
		echo "Error: Neither inotifywait nor entr found."; \
		echo "Please install one of the following:"; \
		echo "  - inotify-tools (for inotifywait): apt install inotify-tools"; \
		echo "  - entr: apt install entr or brew install entr"; \
		exit 1; \
	fi

# Help target
help:
	@echo "Available targets:"
	@echo "  make all     - Build all documents (PDF and HTML)"
	@echo "  make pdf     - Build PDF documents only"
	@echo "  make html    - Build HTML documents only"
	@echo "  make verify  - Verify AsciiDoc syntax"
	@echo "  make clean   - Remove build artifacts"
	@echo "  make watch   - Auto-rebuild on changes (requires inotifywait or entr)"
	@echo "  make help    - Show this help message"
	@echo ""
	@echo "Documents:"
	@for file in $(ADOC_FILES); do \
		echo "  - $$file"; \
	done
EOF

echo "✓ Created framework/Makefile.include"
echo ""

# Create examples/multi-doc-project/Makefile
echo "Creating examples/multi-doc-project/Makefile..."
cat > examples/multi-doc-project/Makefile << 'EOF'
# Makefile for multi-document project example
# This Makefile demonstrates how to build multiple documents using the shared framework

# List of AsciiDoc source files (without .adoc extension)
DOCUMENTS = system-icd component-icd ssdlc

# List of AsciiDoc files for verification
ADOC_FILES = $(addsuffix .adoc,$(DOCUMENTS))

# Build targets
PDF_TARGETS = $(addprefix $(BUILD_DIR)/,$(addsuffix .pdf,$(DOCUMENTS)))
HTML_TARGETS = $(addprefix $(BUILD_DIR)/,$(addsuffix .html,$(DOCUMENTS)))

# Include the framework Makefile
include ../../framework/Makefile.include

# Override default targets to build all documents
pdf: $(PDF_TARGETS)

html: $(HTML_TARGETS)

# Document-specific targets (optional)
.PHONY: system component ssdlc

system: $(BUILD_DIR)/system-icd.pdf $(BUILD_DIR)/system-icd.html

component: $(BUILD_DIR)/component-icd.pdf $(BUILD_DIR)/component-icd.html

ssdlc: $(BUILD_DIR)/ssdlc.pdf $(BUILD_DIR)/ssdlc.html
EOF

echo "✓ Created examples/multi-doc-project/Makefile"
echo ""

# Create system-icd.adoc
echo "Creating examples/multi-doc-project/system-icd.adoc..."
cat > examples/multi-doc-project/system-icd.adoc << 'EOF'
= System Interface Control Document
:title: System Interface Control Document
:author: System Architecture Team
:revnumber: 1.0
:revdate: 2024-01-01
:doctype: book
:toc: left
:toclevels: 3
:sectnums:
:sectnumlevels: 4
:chapter-label:
:icons: font
:experimental:

== Document Information

[cols="1,3"]
|===
|*Document ID*|SYS-ICD-001
|*Revision*|{revnumber}
|*Date*|{revdate}
|*Status*|Draft
|===

== Introduction

This document defines the interfaces for the System-level components. It serves as an example of how multiple documents can be managed in a single project using the shared framework.

=== Purpose

The purpose of this System ICD is to:

* Define system-level interfaces
* Establish interface requirements and specifications
* Provide a baseline for system integration

=== Scope

This document covers:

* External system interfaces
* Inter-subsystem communication
* Data exchange formats

== System Overview

The system architecture consists of multiple subsystems that communicate through well-defined interfaces.

.System Context Diagram
----
┌─────────────┐         ┌─────────────┐
│  External   │◄───────►│   System    │
│   System    │         │   Gateway   │
└─────────────┘         └─────────────┘
                              │
                              ▼
                        ┌─────────────┐
                        │ Component   │
                        │  Subsystem  │
                        └─────────────┘
----

== Interface Specifications

=== External System Interface

*Interface ID:* SYS-IF-001

*Description:* This interface connects the system to external systems for data exchange.

*Protocol:* TCP/IP

*Data Format:* JSON

*Port:* 8080

=== Component Subsystem Interface

*Interface ID:* SYS-IF-002

*Description:* Internal interface between system gateway and component subsystem.

*Protocol:* Message Queue

*Data Format:* Protocol Buffers

== Data Elements

[cols="1,2,1,3"]
|===
|Element ID|Name|Type|Description

|SYS-DE-001
|System Status
|uint8
|Overall system operational status

|SYS-DE-002
|Timestamp
|uint64
|Message timestamp in milliseconds

|SYS-DE-003
|Message ID
|uint32
|Unique message identifier
|===

== Appendix A: Change History

[cols="1,1,2,2"]
|===
|Version|Date|Author|Changes

|1.0
|2024-01-01
|System Architecture Team
|Initial release
|===
EOF

echo "✓ Created examples/multi-doc-project/system-icd.adoc"
echo ""

# Create component-icd.adoc
echo "Creating examples/multi-doc-project/component-icd.adoc..."
cat > examples/multi-doc-project/component-icd.adoc << 'EOF'
= Component Interface Control Document
:title: Component Interface Control Document
:author: Component Development Team
:revnumber: 1.0
:revdate: 2024-01-01
:doctype: book
:toc: left
:toclevels: 3
:sectnums:
:sectnumlevels: 4
:chapter-label:
:icons: font
:experimental:

== Document Information

[cols="1,3"]
|===
|*Document ID*|COMP-ICD-001
|*Revision*|{revnumber}
|*Date*|{revdate}
|*Status*|Draft
|===

== Introduction

This document defines the interfaces for the Component-level subsystems. This is part of a multi-document project demonstrating how to manage multiple ICDs in a single repository.

=== Purpose

The purpose of this Component ICD is to:

* Define component-level interfaces
* Specify internal module communication
* Document API specifications

=== Scope

This document covers:

* Component module interfaces
* Internal APIs
* Data structures and protocols

== Component Architecture

The component subsystem consists of multiple modules that work together to provide functionality.

.Component Architecture
----
┌──────────────────────────────────────┐
│        Component Subsystem           │
│  ┌──────────┐      ┌──────────┐    │
│  │  Module  │◄────►│  Module  │    │
│  │    A     │      │    B     │    │
│  └──────────┘      └──────────┘    │
│        │                 │           │
│        └────────┬────────┘           │
│                 ▼                    │
│          ┌──────────┐                │
│          │  Module  │                │
│          │    C     │                │
│          └──────────┘                │
└──────────────────────────────────────┘
----

== Interface Specifications

=== Module A to Module B Interface

*Interface ID:* COMP-IF-001

*Description:* Data exchange between Module A and Module B.

*Method:* Function calls

*Data Format:* Structured data types

*Frequency:* Event-driven

=== Module C Interface

*Interface ID:* COMP-IF-002

*Description:* Aggregated data interface from Module A and B to Module C.

*Method:* Shared memory

*Data Format:* Binary structures

*Update Rate:* 10 Hz

== API Specifications

=== Module A API

[source,c]
----
// Initialize Module A
int module_a_init(config_t *config);

// Process data
int module_a_process(data_t *input, result_t *output);

// Shutdown Module A
void module_a_shutdown();
----

=== Module B API

[source,c]
----
// Initialize Module B
int module_b_init(config_t *config);

// Get status
status_t module_b_get_status();

// Shutdown Module B
void module_b_shutdown();
----

== Data Structures

[cols="1,2,1,3"]
|===
|Structure|Field|Type|Description

|config_t
|mode
|uint8
|Operating mode

|config_t
|rate
|uint16
|Processing rate in Hz

|data_t
|timestamp
|uint64
|Data timestamp

|data_t
|payload
|uint8[]
|Data payload
|===

== Appendix A: Change History

[cols="1,1,2,2"]
|===
|Version|Date|Author|Changes

|1.0
|2024-01-01
|Component Development Team
|Initial release
|===
EOF

echo "✓ Created examples/multi-doc-project/component-icd.adoc"
echo ""

# Create ssdlc.adoc
echo "Creating examples/multi-doc-project/ssdlc.adoc..."
cat > examples/multi-doc-project/ssdlc.adoc << 'EOF'
= Secure Software Development Lifecycle (SSDLC) Document
:title: Secure Software Development Lifecycle
:author: Security Team
:revnumber: 1.0
:revdate: 2024-01-01
:doctype: book
:toc: left
:toclevels: 3
:sectnums:
:sectnumlevels: 4
:chapter-label:
:icons: font
:experimental:

== Document Information

[cols="1,3"]
|===
|*Document ID*|SSDLC-001
|*Revision*|{revnumber}
|*Date*|{revdate}
|*Status*|Draft
|===

== Introduction

This document describes the Secure Software Development Lifecycle (SSDLC) processes and practices for the project. This demonstrates how non-ICD documents can also be managed in a multi-document project.

=== Purpose

The purpose of this SSDLC document is to:

* Define security requirements and practices
* Establish secure coding guidelines
* Document security testing procedures
* Ensure compliance with security standards

=== Scope

This document covers:

* Security requirements and threat modeling
* Secure design principles
* Implementation security controls
* Security testing and validation
* Deployment and maintenance security

== SSDLC Overview

The SSDLC integrates security activities throughout the software development lifecycle.

.SSDLC Phases
----
┌──────────────┐
│ Requirements │  ──► Security Requirements
└──────────────┘      Threat Modeling
       │
       ▼
┌──────────────┐
│    Design    │  ──► Secure Architecture
└──────────────┘      Security Controls
       │
       ▼
┌──────────────┐
│Implement│  ──► Secure Coding
└──────────────┘      Code Review
       │
       ▼
┌──────────────┐
│   Testing    │  ──► Security Testing
└──────────────┘      Vulnerability Assessment
       │
       ▼
┌──────────────┐
│  Deployment  │  ──► Security Configuration
└──────────────┘      Monitoring
----

== Security Requirements

=== Confidentiality

[cols="1,3,2"]
|===
|Req ID|Requirement|Priority

|SEC-REQ-001
|All sensitive data shall be encrypted at rest
|Mandatory

|SEC-REQ-002
|All network communication shall use TLS 1.2 or higher
|Mandatory

|SEC-REQ-003
|Access to sensitive data shall require authentication
|Mandatory
|===

=== Integrity

[cols="1,3,2"]
|===
|Req ID|Requirement|Priority

|SEC-REQ-101
|All data transmissions shall include integrity checks
|Mandatory

|SEC-REQ-102
|Configuration files shall be digitally signed
|Desirable

|SEC-REQ-103
|Software updates shall be cryptographically verified
|Mandatory
|===

=== Availability

[cols="1,3,2"]
|===
|Req ID|Requirement|Priority

|SEC-REQ-201
|System shall implement rate limiting to prevent DoS
|Mandatory

|SEC-REQ-202
|System shall log all security events
|Mandatory

|SEC-REQ-203
|System shall support secure backup and recovery
|Desirable
|===

== Secure Design Principles

=== Principle of Least Privilege

Components shall operate with the minimum privileges necessary to perform their functions.

=== Defense in Depth

Multiple layers of security controls shall be implemented to protect against threats.

=== Fail Securely

The system shall fail to a secure state in the event of errors or attacks.

=== Input Validation

All input data shall be validated before processing.

== Secure Coding Guidelines

=== General Guidelines

* Use memory-safe languages where possible
* Avoid unsafe functions (strcpy, sprintf, etc.)
* Initialize all variables before use
* Check return values from all functions
* Handle errors gracefully
* Use const correctness

=== Code Review Checklist

* [ ] Input validation implemented
* [ ] Bounds checking on all arrays
* [ ] No hard-coded credentials or secrets
* [ ] Error handling implemented
* [ ] Resource cleanup on all paths
* [ ] Thread-safe where applicable

== Security Testing

=== Static Analysis

* Run static analysis tools on all code
* Address all critical and high-severity findings
* Document accepted findings with justification

=== Dynamic Analysis

* Perform penetration testing
* Conduct fuzzing of input interfaces
* Test authentication and authorization

=== Vulnerability Management

* Scan for known vulnerabilities
* Apply security patches promptly
* Track and remediate findings

== Compliance and Standards

This project complies with:

* NIST SP 800-53 Security Controls
* OWASP Top 10
* CWE/SANS Top 25
* Industry-specific standards (as applicable)

== Appendix A: Threat Model

[cols="1,2,2,2"]
|===
|Threat ID|Threat|Impact|Mitigation

|THR-001
|Unauthorized access
|High
|Authentication + Authorization

|THR-002
|Data interception
|High
|Encryption (TLS)

|THR-003
|Code injection
|High
|Input validation

|THR-004
|Denial of Service
|Medium
|Rate limiting
|===

== Appendix B: Change History

[cols="1,1,2,2"]
|===
|Version|Date|Author|Changes

|1.0
|2024-01-01
|Security Team
|Initial release
|===
EOF

echo "✓ Created examples/multi-doc-project/ssdlc.adoc"
echo ""

# Create .gitlab-ci.yml for multi-document project
echo "Creating examples/multi-doc-project/.gitlab-ci.yml..."
cat > examples/multi-doc-project/.gitlab-ci.yml << 'EOF'
# GitLab CI/CD configuration for multi-document project
# This demonstrates using matrix strategy to build multiple documents

stages:
  - verify
  - build
  - deploy

variables:
  BUILD_DIR: "build"

# Verify all documents
verify:
  stage: verify
  image: asciidoctor/docker-asciidoctor:latest
  script:
    - echo "Verifying all AsciiDoc documents..."
    - make verify
  only:
    - branches
    - tags
    - merge_requests

# Build documents using matrix strategy
build:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  parallel:
    matrix:
      - DOCUMENT: system-icd
      - DOCUMENT: component-icd
      - DOCUMENT: ssdlc
  before_script:
    - mkdir -p ${BUILD_DIR}
  script:
    - echo "Building ${DOCUMENT}..."
    - asciidoctor-pdf ${DOCUMENT}.adoc -o ${BUILD_DIR}/${DOCUMENT}.pdf
    - asciidoctor ${DOCUMENT}.adoc -o ${BUILD_DIR}/${DOCUMENT}.html
    - echo "✓ Generated ${DOCUMENT}.pdf and ${DOCUMENT}.html"
  artifacts:
    name: "${DOCUMENT}-${CI_COMMIT_REF_NAME}-${CI_COMMIT_SHORT_SHA}"
    paths:
      - ${BUILD_DIR}/${DOCUMENT}.pdf
      - ${BUILD_DIR}/${DOCUMENT}.html
    expire_in: 7 days
  only:
    - branches
    - tags
    - merge_requests

# Alternative: Build all documents in a single job
build-all:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  before_script:
    - mkdir -p ${BUILD_DIR}
  script:
    - echo "Building all documents..."
    - make all
    - ls -lh ${BUILD_DIR}/
  artifacts:
    name: "all-documents-${CI_COMMIT_REF_NAME}-${CI_COMMIT_SHORT_SHA}"
    paths:
      - ${BUILD_DIR}/*.pdf
      - ${BUILD_DIR}/*.html
    expire_in: 7 days
  only:
    - branches
    - tags
    - merge_requests
  when: manual  # Run manually as alternative to matrix build

# Deploy (placeholder)
deploy:
  stage: deploy
  script:
    - echo "Deploy stage placeholder"
    - echo "Customize based on your deployment requirements"
    - ls -lh ${BUILD_DIR}/
  dependencies:
    - build
  only:
    - master
    - main
    - tags
  when: manual
EOF

echo "✓ Created examples/multi-doc-project/.gitlab-ci.yml"
echo ""

# Create README.md
echo "Creating examples/multi-doc-project/README.md..."
cat > examples/multi-doc-project/README.md << 'EOF'
# Multi-Document Project Example

This directory demonstrates a complete multi-document project setup using the shared framework. It shows how to manage multiple AsciiDoc documents (ICDs, SSDLC, etc.) in a single project with consistent tooling and CI/CD.

## Project Structure

```
examples/multi-doc-project/
├── Makefile                    # Project-specific Makefile
├── .gitlab-ci.yml             # CI/CD configuration with matrix strategy
├── README.md                  # This file
├── system-icd.adoc            # System-level ICD
├── component-icd.adoc         # Component-level ICD
├── ssdlc.adoc                 # SSDLC document
└── build/                     # Generated outputs (gitignored)
    ├── system-icd.pdf
    ├── system-icd.html
    ├── component-icd.pdf
    ├── component-icd.html
    ├── ssdlc.pdf
    └── ssdlc.html
```

## Features

### 1. Shared Framework

The project uses the shared framework Makefile (`../../framework/Makefile.include`) which provides:

- Common build rules for PDF and HTML generation
- Consistent verification and validation
- Watch mode for development
- Clean build artifact management

### 2. Multi-Document Support

Multiple documents are managed in a single project:

- **system-icd.adoc**: System-level Interface Control Document
- **component-icd.adoc**: Component-level Interface Control Document
- **ssdlc.adoc**: Secure Software Development Lifecycle document

Each document can be built independently or all together.

### 3. GitLab CI/CD Matrix Strategy

The `.gitlab-ci.yml` demonstrates two approaches:

**Matrix Build** (default):
- Builds each document in parallel using GitLab's matrix strategy
- Faster CI/CD execution for large projects
- Individual artifacts per document

**Single Job Build** (manual):
- Builds all documents in one job
- Simpler artifact management
- Run manually when needed

## Usage

### Building Documents

Build all documents:
```bash
make all
```

Build only PDFs:
```bash
make pdf
```

Build only HTMLs:
```bash
make html
```

Build specific document:
```bash
make system              # Build system-icd.pdf and system-icd.html
make component           # Build component-icd.pdf and component-icd.html
make ssdlc               # Build ssdlc.pdf and ssdlc.html
```

### Verification

Verify AsciiDoc syntax:
```bash
make verify
```

### Development

Watch for changes and auto-rebuild:
```bash
make watch
```

### Clean

Remove build artifacts:
```bash
make clean
```

## CI/CD Pipeline

The GitLab CI/CD pipeline includes:

1. **Verify Stage**: Validates all AsciiDoc syntax
2. **Build Stage**: 
   - Matrix build: Parallel document generation
   - Build-all: Single-job generation (manual)
3. **Deploy Stage**: Deployment placeholder (customize as needed)

### Matrix Strategy

The matrix strategy builds documents in parallel:

```yaml
parallel:
  matrix:
    - DOCUMENT: system-icd
    - DOCUMENT: component-icd
    - DOCUMENT: ssdlc
```

This creates three parallel jobs, each building one document. Benefits:

- Faster pipeline execution
- Clear per-document build status
- Individual artifact downloads

## Extending the Project

### Adding New Documents

1. Create new `.adoc` file (e.g., `api-spec.adoc`)
2. Add to `DOCUMENTS` list in Makefile:
   ```makefile
   DOCUMENTS = system-icd component-icd ssdlc api-spec
   ```
3. Add to matrix in `.gitlab-ci.yml`:
   ```yaml
   - DOCUMENT: api-spec
   ```
4. (Optional) Add specific build target in Makefile:
   ```makefile
   api: $(BUILD_DIR)/api-spec.pdf $(BUILD_DIR)/api-spec.html
   ```

### Customizing Build Options

Edit the Makefile to add document-specific options:

```makefile
# Custom options for specific documents
$(BUILD_DIR)/system-icd.pdf: system-icd.adoc
	$(ASCIIDOCTOR_PDF) $(PDF_OPTS) -a custom-attribute $< -o $@
```

### Using Different Themes

Reference themes from the framework:

```asciidoc
:pdf-theme: ../../framework/themes/pdf/ecss-default-theme.yml
:stylesheet: ../../framework/themes/html/ecss-default.css
```

## Best Practices

1. **Consistent Structure**: Keep all documents in the same directory
2. **Shared Resources**: Use framework for common scripts and themes
3. **Version Control**: Track all `.adoc` files, ignore `build/` directory
4. **Documentation**: Maintain README for each document project
5. **CI/CD**: Use matrix strategy for multiple documents
6. **Naming**: Use consistent naming convention (lowercase with hyphens)

## Dependencies

- AsciiDoctor: Document processor
- AsciiDoctor-PDF: PDF generation
- AsciiDoctor-Diagram: Diagram support (optional)
- Make: Build automation
- GitLab Runner: CI/CD execution

## Troubleshooting

### Build Failures

Check AsciiDoc syntax:
```bash
make verify
```

### Missing Framework

Ensure the framework directory exists at `../../framework/` with `Makefile.include`.

### CI/CD Issues

- Verify `.gitlab-ci.yml` syntax
- Check runner has necessary Docker images
- Ensure artifacts paths are correct

## Support

For issues or questions:
- Check framework documentation
- Review main project README
- Consult AsciiDoctor documentation

## License

[Specify license if applicable]
EOF

echo "✓ Created examples/multi-doc-project/README.md"
echo ""

echo "════════════════════════════════════════════════════════"
echo "✓ Multi-document project example setup complete!"
echo ""
echo "Directory structure created:"
echo "  framework/Makefile.include"
echo "  examples/multi-doc-project/Makefile"
echo "  examples/multi-doc-project/.gitlab-ci.yml"
echo "  examples/multi-doc-project/README.md"
echo "  examples/multi-doc-project/system-icd.adoc"
echo "  examples/multi-doc-project/component-icd.adoc"
echo "  examples/multi-doc-project/ssdlc.adoc"
echo ""
echo "To build the example documents:"
echo "  cd examples/multi-doc-project"
echo "  make all"
echo ""
echo "To see available targets:"
echo "  cd examples/multi-doc-project"
echo "  make help"
echo "════════════════════════════════════════════════════════"
