#!/bin/sh

# Create directory structure
for dir in framework framework/scripts framework/themes framework/themes/html framework/themes/pdf templates templates/icd templates/ssdlc templates/generic; do
  if [ ! -d "$dir" ]; then
    mkdir "$dir"
  fi
done


# Copy scripts
echo "Copying scripts..."
cp scripts/compile.sh framework/scripts/
cp scripts/verify.sh framework/scripts/
chmod +x framework/scripts/*.sh

# Copy themes
echo "Copying themes..."
for file in themes/html/*; do
    [ -f "$file" ] && cp "$file" framework/themes/html/
done

for file in themes/pdf/*; do
    [ -f "$file" ] && cp "$file" framework/themes/pdf/
done

cp themes/README.md framework/themes/

# Copy Docker files
echo "Copying Docker configuration..."
cp Dockerfile framework/
cp docker-compose.yml framework/

# Copy ICD template
echo "Copying ICD template..."
cp icd-template.adoc templates/icd/

echo ""
echo "Creating framework Makefile.include..."
cat > framework/Makefile.include << 'EOF'
# Shared Makefile rules for AsciiDoc document generation
# Include this file in template-specific Makefiles

# Framework paths (relative to template directory)
FRAMEWORK_DIR ?= ../../framework
SCRIPTS_DIR = $(FRAMEWORK_DIR)/scripts
THEMES_DIR = $(FRAMEWORK_DIR)/themes

# Build configuration
BUILD_DIR ?= ../../build
VERIFY_SCRIPT = $(SCRIPTS_DIR)/verify.sh
COMPILE_SCRIPT = $(SCRIPTS_DIR)/compile.sh

# Docker configuration
DOCKER_IMAGE_NAME ?= asciidoctor-docs
DOCKER_IMAGE_TAG ?= latest

# Detect if we're in Docker or using bundler
ifeq ($(shell command -v bundle 2> /dev/null && [ -f ../../Gemfile.lock ] && echo yes),yes)
	ASCIIDOCTOR = bundle exec asciidoctor
	ASCIIDOCTOR_PDF = bundle exec asciidoctor-pdf
else
	ASCIIDOCTOR = asciidoctor
	ASCIIDOCTOR_PDF = asciidoctor-pdf
endif

# Common targets
.PHONY: help clean verify watch docker-build

help:
	@echo "Available targets:"
	@echo "  make all          - Compile both PDF and HTML (default)"
	@echo "  make pdf          - Compile PDF only"
	@echo "  make html         - Compile HTML only"
	@echo "  make verify       - Run verification script"
	@echo "  make clean        - Remove build artifacts"
	@echo "  make watch        - Auto-compile on changes (requires inotifywait or entr)"
	@echo "  make docker-build - Build Docker image"
	@echo "  make help         - Show this help message"

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Build artifacts removed."

verify:
	@if [ -f $(VERIFY_SCRIPT) ]; then \
		echo "Running verification script..."; \
		cd $(shell dirname $(ASCIIDOC_FILE)) && $(VERIFY_SCRIPT); \
	else \
		echo "Verification script not found: $(VERIFY_SCRIPT)"; \
		exit 1; \
	fi

watch:
	@echo "Watching for changes to $(ASCIIDOC_FILE)..."
	@if command -v inotifywait &> /dev/null; then \
		echo "Using inotifywait for file monitoring..."; \
		while true; do \
			inotifywait -e modify,create,delete $(ASCIIDOC_FILE) && \
			$(MAKE) all; \
		done \
	elif command -v entr &> /dev/null; then \
		echo "Using entr for file monitoring..."; \
		echo $(ASCIIDOC_FILE) | entr -c $(MAKE) all; \
	else \
		echo "Error: Neither inotifywait nor entr found."; \
		echo "Please install one of the following:"; \
		echo "  - inotify-tools (for inotifywait): apt install inotify-tools"; \
		echo "  - entr: apt install entr or brew install entr"; \
		exit 1; \
	fi

docker-build:
	@echo "Building Docker image..."
	@docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) -f $(FRAMEWORK_DIR)/Dockerfile $(FRAMEWORK_DIR)/..
	@echo "Docker image built: $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)"

# Common build directory creation
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
EOF

echo ""
echo "Creating ICD template Makefile..."
cat > templates/icd/Makefile << 'EOF'
# Include shared framework rules
include ../../framework/Makefile.include

# Template-specific configuration
ASCIIDOC_FILE = icd-template.adoc
PDF_OUTPUT = icd-template.pdf
HTML_OUTPUT = icd-template.html

.PHONY: all pdf html

all: pdf html

pdf: $(BUILD_DIR)/$(PDF_OUTPUT)

html: $(BUILD_DIR)/$(HTML_OUTPUT)

$(BUILD_DIR)/$(PDF_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating ICD PDF..."
	@$(ASCIIDOCTOR_PDF) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(PDF_OUTPUT)
	@echo "PDF generated: $(BUILD_DIR)/$(PDF_OUTPUT)"

$(BUILD_DIR)/$(HTML_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating ICD HTML..."
	@$(ASCIIDOCTOR) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(HTML_OUTPUT)
	@echo "HTML generated: $(BUILD_DIR)/$(HTML_OUTPUT)"
EOF

echo ""
echo "Creating SSDLC template..."
cat > templates/ssdlc/ssdlc-template.adoc << 'EOF'
= Secure Software Development Lifecycle (SSDLC) Document
:title: Secure Software Development Lifecycle Document
:author: [Author Name]
:revnumber: 1.0
:revdate: {docdate}
:doctype: book
:toc: left
:toclevels: 3
:sectnums:
:sectnumlevels: 4
:chapter-label:
:figure-caption: Figure
:table-caption: Table
:appendix-caption: Appendix
:xrefstyle: short
:imagesdir: images
:icons: font
:source-highlighter: rouge
:pdf-theme: ../../framework/themes/pdf/ecss-default-theme.yml
:stylesheet: ../../framework/themes/html/ecss-default.css
:experimental:

// Document metadata
:document-title: Secure Software Development Lifecycle Document
:document-id: [Document ID]
:document-type: SSDLC
:project-name: [Project Name]
:classification: [Classification Level]
:organization: [Organization Name]

<<<

== Cover Page

[.text-center]
--
*{organization}*

*{project-name}*

*{document-title}*

Document ID: {document-id}

Revision: {revnumber}

Date: {revdate}

Classification: {classification}
--

<<<

== Document Control

=== Revision History

[cols="1,1,1,3,2"]
|===
|*Revision*|*Date*|*Author*|*Description of Changes*|*Approved By*

|1.0
|{revdate}
|{author}
|Initial release
|[Approver]

|===

<<<

== Executive Summary

[Provide a high-level overview of the secure software development lifecycle approach, key security principles, and the purpose of this document.]

<<<

== Introduction

=== Purpose

This document defines the Secure Software Development Lifecycle (SSDLC) framework for [Project Name]. The purpose is to:

* Integrate security practices throughout the software development lifecycle
* Define security requirements and controls
* Establish secure coding standards and guidelines
* Provide security testing and validation procedures
* Ensure compliance with security standards and regulations

=== Scope

[Define the scope of the SSDLC framework, including which projects, systems, and development activities it applies to.]

=== Definitions and Acronyms

[cols="1,3"]
|===
|*Term*|*Definition*

|SSDLC
|Secure Software Development Lifecycle

|SAST
|Static Application Security Testing

|DAST
|Dynamic Application Security Testing

|CVE
|Common Vulnerabilities and Exposures

|===

<<<

== Security Requirements

=== Security Objectives

[Define the security objectives for the software, such as confidentiality, integrity, availability, authentication, authorization, etc.]

=== Threat Model

[Describe the threat model, including potential threats, attack vectors, and risk assessment.]

=== Security Requirements Specification

[cols="1,3,1,1"]
|===
|*Requirement ID*|*Security Requirement*|*Priority*|*Status*

|SEC-REQ-001
|[Security requirement description]
|High
|[Status]

|===

<<<

== Secure Development Process

=== SSDLC Phases

==== Requirements Phase

[Describe security activities during requirements gathering, including security requirements elicitation and threat modeling.]

==== Design Phase

[Describe secure design principles, architecture security review, and security design patterns.]

==== Implementation Phase

[Describe secure coding practices, code review processes, and security training for developers.]

==== Testing Phase

[Describe security testing activities, including SAST, DAST, penetration testing, and vulnerability scanning.]

==== Deployment Phase

[Describe secure deployment practices, security hardening, and deployment verification.]

==== Maintenance Phase

[Describe ongoing security monitoring, patch management, and incident response procedures.]

=== Security Activities Matrix

[cols="2,3,3"]
|===
|*SDLC Phase*|*Security Activities*|*Deliverables*

|Requirements
|Threat modeling, Security requirements
|Threat model, Security requirements document

|Design
|Security architecture review
|Security architecture document

|Implementation
|Secure coding, Code review
|Secure code, Code review reports

|Testing
|SAST, DAST, Penetration testing
|Security test reports

|Deployment
|Security hardening, Configuration review
|Deployment security checklist

|Maintenance
|Vulnerability monitoring, Patch management
|Security bulletins, Patch reports

|===

<<<

== Secure Coding Standards

=== General Principles

* Input validation
* Output encoding
* Authentication and session management
* Access control
* Cryptographic practices
* Error handling and logging
* Data protection
* Communication security

=== Language-Specific Guidelines

[Provide secure coding guidelines specific to the programming languages used in the project.]

=== Code Review Process

[Describe the code review process, including peer reviews and automated code analysis.]

<<<

== Security Testing

=== Static Analysis (SAST)

[Describe SAST tools, processes, and acceptance criteria.]

=== Dynamic Analysis (DAST)

[Describe DAST tools, processes, and acceptance criteria.]

=== Penetration Testing

[Describe penetration testing methodology, frequency, and reporting.]

=== Vulnerability Management

[Describe the process for identifying, tracking, and remediating vulnerabilities.]

<<<

== Compliance and Standards

=== Applicable Standards

[List applicable security standards such as OWASP, CERT, CWE, etc.]

=== Compliance Requirements

[Describe regulatory and compliance requirements.]

=== Security Metrics

[Define security metrics and KPIs to measure SSDLC effectiveness.]

<<<

== Appendices

[appendix]
== Appendix A: Security Checklists

=== Requirements Phase Checklist

* [ ] Threat model completed
* [ ] Security requirements identified
* [ ] Risk assessment performed

=== Design Phase Checklist

* [ ] Security architecture reviewed
* [ ] Security design patterns applied
* [ ] Data flow diagrams created

=== Implementation Phase Checklist

* [ ] Secure coding standards followed
* [ ] Code review completed
* [ ] Security training completed

=== Testing Phase Checklist

* [ ] SAST performed
* [ ] DAST performed
* [ ] Penetration testing completed
* [ ] Vulnerabilities addressed

=== Deployment Phase Checklist

* [ ] Security hardening applied
* [ ] Configuration reviewed
* [ ] Security verification completed

[appendix]
== Appendix B: Tool Recommendations

[Provide recommendations for security tools including SAST, DAST, dependency scanning, etc.]

[appendix]
== Appendix C: Training Resources

[List training resources for secure software development.]
EOF

echo ""
echo "Creating SSDLC Makefile..."
cat > templates/ssdlc/Makefile << 'EOF'
# Include shared framework rules
include ../../framework/Makefile.include

# Template-specific configuration
ASCIIDOC_FILE = ssdlc-template.adoc
PDF_OUTPUT = ssdlc-template.pdf
HTML_OUTPUT = ssdlc-template.html

.PHONY: all pdf html

all: pdf html

pdf: $(BUILD_DIR)/$(PDF_OUTPUT)

html: $(BUILD_DIR)/$(HTML_OUTPUT)

$(BUILD_DIR)/$(PDF_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating SSDLC PDF..."
	@$(ASCIIDOCTOR_PDF) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(PDF_OUTPUT)
	@echo "PDF generated: $(BUILD_DIR)/$(PDF_OUTPUT)"

$(BUILD_DIR)/$(HTML_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating SSDLC HTML..."
	@$(ASCIIDOCTOR) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(HTML_OUTPUT)
	@echo "HTML generated: $(BUILD_DIR)/$(HTML_OUTPUT)"
EOF

echo ""
echo "Creating generic template..."
cat > templates/generic/generic-template.adoc << 'EOF'
= Generic Document Template
:title: Generic Document Template
:author: [Author Name]
:revnumber: 1.0
:revdate: {docdate}
:doctype: book
:toc: left
:toclevels: 3
:sectnums:
:sectnumlevels: 4
:chapter-label:
:figure-caption: Figure
:table-caption: Table
:appendix-caption: Appendix
:xrefstyle: short
:imagesdir: images
:icons: font
:source-highlighter: rouge
:pdf-theme: ../../framework/themes/pdf/ecss-default-theme.yml
:stylesheet: ../../framework/themes/html/ecss-default.css
:experimental:

// Document metadata
:document-title: Generic Document
:document-id: [Document ID]
:project-name: [Project Name]
:organization: [Organization Name]

<<<

== Document Information

[cols="1,3"]
|===
|*Document ID*|{document-id}
|*Revision*|{revnumber}
|*Date*|{revdate}
|*Author*|{author}
|*Organization*|{organization}
|===

<<<

== Revision History

[cols="1,1,1,3,2"]
|===
|*Revision*|*Date*|*Author*|*Description of Changes*|*Approved By*

|1.0
|{revdate}
|{author}
|Initial release
|[Approver]

|===

<<<

== Introduction

=== Purpose

[Describe the purpose of this document.]

=== Scope

[Define the scope and boundaries of this document.]

=== Audience

[Identify the intended audience for this document.]

=== Document Organization

[Describe how this document is organized.]

<<<

== Section 2

=== Subsection 2.1

[Your content here...]

=== Subsection 2.2

[Your content here...]

<<<

== Section 3

=== Subsection 3.1

[Your content here...]

=== Subsection 3.2

[Your content here...]

<<<

== Conclusion

[Provide a summary and conclusion.]

<<<

== References

[List references, applicable documents, and resources.]

[cols="1,2,1"]
|===
|*Reference ID*|*Document Title*|*Version*

|[REF-001]
|[Document title]
|[Version]

|===

<<<

== Appendices

[appendix]
== Appendix A: Additional Information

[Provide additional information, diagrams, or supplementary content.]

[appendix]
== Appendix B: Glossary

[cols="1,3"]
|===
|*Term*|*Definition*

|[Term]
|[Definition]

|===
EOF

echo ""
echo "Creating generic Makefile..."
cat > templates/generic/Makefile << 'EOF'
# Include shared framework rules
include ../../framework/Makefile.include

# Template-specific configuration
ASCIIDOC_FILE = generic-template.adoc
PDF_OUTPUT = generic-template.pdf
HTML_OUTPUT = generic-template.html

.PHONY: all pdf html

all: pdf html

pdf: $(BUILD_DIR)/$(PDF_OUTPUT)

html: $(BUILD_DIR)/$(HTML_OUTPUT)

$(BUILD_DIR)/$(PDF_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating generic PDF..."
	@$(ASCIIDOCTOR_PDF) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(PDF_OUTPUT)
	@echo "PDF generated: $(BUILD_DIR)/$(PDF_OUTPUT)"

$(BUILD_DIR)/$(HTML_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating generic HTML..."
	@$(ASCIIDOCTOR) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(HTML_OUTPUT)
	@echo "HTML generated: $(BUILD_DIR)/$(HTML_OUTPUT)"
EOF

echo ""
echo "Creating root Makefile..."
cat > Makefile.new << 'EOF'
# Root Makefile for multi-template document repository

.PHONY: all icd ssdlc generic clean help

all: icd ssdlc generic

icd:
	@echo "Building ICD template..."
	@$(MAKE) -C templates/icd all

ssdlc:
	@echo "Building SSDLC template..."
	@$(MAKE) -C templates/ssdlc all

generic:
	@echo "Building generic template..."
	@$(MAKE) -C templates/generic all

clean:
	@echo "Cleaning all build artifacts..."
	@rm -rf build
	@echo "Build artifacts removed."

help:
	@echo "Available targets:"
	@echo "  make all       - Build all templates (ICD, SSDLC, generic)"
	@echo "  make icd       - Build ICD template only"
	@echo "  make ssdlc     - Build SSDLC template only"
	@echo "  make generic   - Build generic template only"
	@echo "  make clean     - Remove all build artifacts"
	@echo "  make help      - Show this help message"
	@echo ""
	@echo "To build a specific template:"
	@echo "  cd templates/icd && make all"
	@echo "  cd templates/ssdlc && make all"
	@echo "  cd templates/generic && make all"
EOF

echo ""
echo "==================================="
echo "Restructuring complete!"
echo "==================================="
echo ""
echo "Summary:"
echo "  - Created framework/ directory with scripts, themes, and Docker files"
echo "  - Created templates/icd/ with ICD template"
echo "  - Created templates/ssdlc/ with SSDLC template"
echo "  - Created templates/generic/ with generic template"
echo "  - Created Makefile.new (review and rename to Makefile if desired)"
echo ""
echo "Next steps:"
echo "  1. Review Makefile.new and rename to Makefile if you want to replace the old one"
echo "  2. Test building: cd templates/icd && make all"
echo "  3. Verify outputs in build/ directory"
echo "  4. Update any CI/CD scripts to use new paths"
echo "  5. Consider removing old directories: scripts/, themes/, and icd-template.adoc from root"
echo ""
