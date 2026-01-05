# Interface Control Document (ICD) Template

A comprehensive AsciiDoc template for creating Interface Control Documents (ICDs) compliant with aerospace and space system documentation standards, including ECSS (European Cooperation for Space Standardization) guidelines.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Generating Output](#generating-output)
- [Template Structure](#template-structure)
- [Customization Guide](#customization-guide)
- [ECSS Compliance](#ecss-compliance)
- [Development Workflow](#development-workflow)
- [Troubleshooting](#troubleshooting)

## Overview

This template provides a production-ready structure for Interface Control Documents used in complex system integration projects, particularly in aerospace, defense, and space systems. It includes:

- **Complete ICD structure** following industry best practices
- **ECSS-compliant organization** with references to relevant standards
- **Comprehensive sections** for requirements, specifications, and data definitions
- **Built-in traceability** with cross-references and requirement tracking
- **Professional formatting** for both PDF and HTML output
- **Change control procedures** with forms and processes

### Features

- Pre-structured sections for interface requirements, specifications, and data elements
- Requirements traceability matrices and compliance tracking
- Interface change control process with ICR (Interface Change Request) form
- Test and verification procedures
- Data element definitions with primitive and composite types
- Protocol specifications and message format templates
- State machine and timing diagrams support (PlantUML integration)
- Professional document formatting with table of contents, cross-references, and page breaks

## Prerequisites

### Required Software

| Tool | Version | Purpose |
|------|---------|---------|
| **asciidoctor** | 2.0+ | HTML generation from AsciiDoc |
| **asciidoctor-pdf** | 2.3+ | PDF generation from AsciiDoc |
| **Ruby** | 2.5+ | Required for asciidoctor gems |
| **Bundler** | 2.0+ | Optional, for project-local gem management |

### Optional Tools

- **inotify-tools** or **entr** - For auto-rebuild on file changes (`make watch`)
- **PlantUML** - For rendering UML diagrams (if using diagram features)

## Installation

### Option 1: Homebrew (Recommended for macOS/Linux)

```bash
brew install asciidoctor
```

This installs both `asciidoctor` and `asciidoctor-pdf` globally on your system.

### Option 2: RubyGems (All Platforms)

```bash
gem install asciidoctor asciidoctor-pdf
```

You may need `sudo` on some systems:

```bash
sudo gem install asciidoctor asciidoctor-pdf
```

### Option 3: Bundler (Project-local Installation)

For isolated project dependencies that don't affect your global Ruby installation:

```bash
# Configure bundler to install gems locally
bundle config set --local path 'vendor/bundle'

# Install dependencies from Gemfile
bundle install
```

When using Bundler, prefix all `make` commands with `bundle exec`:

```bash
bundle exec make all
```

### Verify Installation

Run the setup script to verify everything is installed correctly:

```bash
./setup.sh
```

This script checks for required tools and provides installation guidance if anything is missing.

## Quick Start

1. **Clone or download** this repository
2. **Install prerequisites** (see [Installation](#installation))
3. **Customize the template** (see [Customization Guide](#customization-guide))
4. **Generate outputs**:

```bash
make all    # Generates both PDF and HTML
```

5. **Find outputs** in the `build/` directory:
   - `build/icd-template.pdf`
   - `build/icd-template.html`

## Generating Output

### Available Commands

```bash
make all       # Build both PDF and HTML (default)
make pdf       # Build PDF only
make html      # Build HTML only
make verify    # Verify AsciiDoc syntax
make clean     # Remove build artifacts
make watch     # Auto-rebuild on changes (requires inotifywait or entr)
make help      # Show all available commands
```

### Manual Generation

If you prefer to run `asciidoctor` commands directly:

#### Generate HTML

```bash
asciidoctor icd-template.adoc -o build/icd-template.html
```

#### Generate PDF

```bash
asciidoctor-pdf icd-template.adoc -o build/icd-template.pdf
```

#### With Bundler

```bash
bundle exec asciidoctor icd-template.adoc -o build/icd-template.html
bundle exec asciidoctor-pdf icd-template.adoc -o build/icd-template.pdf
```

### Advanced Options

#### Custom Output Directory

```bash
asciidoctor icd-template.adoc -o /path/to/output.html
asciidoctor-pdf icd-template.adoc -o /path/to/output.pdf
```

#### Custom PDF Theme

```bash
asciidoctor-pdf icd-template.adoc -a pdf-theme=custom-theme.yml -o build/icd-template.pdf
```

#### Verbose Output

```bash
asciidoctor -v icd-template.adoc
```

## Template Structure

### Document Organization

```
icd-template.adoc
├── Document Metadata & Attributes
├── Cover Page
├── Document Status
├── Abstract
├── Document Control
│   ├── Revision History
│   ├── Applicable Documents
│   ├── Reference Documents
│   └── Terms, Definitions and Abbreviations
├── Introduction
│   ├── Purpose
│   ├── Scope
│   └── Document Overview
├── Interface Overview
│   ├── System Context
│   ├── Interface Summary
│   └── Interface Architecture
├── Interface Requirements
│   ├── General Requirements
│   └── Interface-specific Requirements (IF-001, IF-002, ...)
│       ├── Description
│       ├── Interface Type
│       ├── Interface Characteristics
│       ├── Functional Requirements
│       ├── Performance Requirements
│       └── Design Constraints
├── Detailed Interface Specifications
│   └── Per-interface Specifications (IF-001, IF-002, ...)
│       ├── Protocol Specification
│       ├── Message Format Specification
│       ├── Timing Requirements
│       └── Interface States and Modes
├── Data Element Definitions
│   ├── Primitive Data Types
│   ├── Data Element Definitions
│   ├── Enumerated Types
│   ├── Bit Field Definitions
│   └── Composite Data Types
├── Interface Control
│   ├── Interface Change Control
│   ├── Interface Verification
│   └── Interface Validation
└── Appendices
    ├── A: Interface Change Request Form
    ├── B: Interface Diagrams
    ├── C: Test Procedures
    ├── D: Compliance Matrix
    └── E: Glossary
```

### Key Sections Explained

#### Document Metadata (Lines 1-31)
Document attributes control formatting, versioning, and metadata. Customize these for your project:
- `:author:` - Document author name
- `:revnumber:` - Current revision (e.g., 1.0)
- `:revdate:` - Revision date
- `:document-id:` - Unique document identifier
- `:project-name:` - Your project name
- `:classification:` - Security classification level
- `:organization:` - Your organization name

#### Interface Requirements (Section 4)
Defines both general and interface-specific requirements with:
- Unique requirement IDs (e.g., GEN-REQ-001, IF001-FREQ-001)
- Traceability to parent requirements
- Priority levels (Mandatory/Desirable)
- Functional, performance, and design constraint requirements

#### Interface Specifications (Section 5)
Detailed technical specifications including:
- Protocol definitions and connection management
- Message formats with byte-level layouts
- Timing requirements and constraints
- State machines and operational modes

#### Data Element Definitions (Section 6)
Comprehensive data dictionaries with:
- Primitive types (uint8, int16, float32, etc.)
- Individual data element definitions (DE-001, DE-002, ...)
- Enumerated types with valid value sets
- Bit field definitions for configuration flags
- Composite types for structured data

#### Interface Control (Section 7)
Change management and validation procedures:
- Change control process and classification
- Verification and validation approaches
- Test procedures and acceptance criteria

## Customization Guide

### Step 1: Update Document Metadata

Edit the header section (lines 1-31) in `icd-template.adoc`:

```asciidoc
:title: Interface Control Document
:author: Your Name
:revnumber: 1.0
:revdate: 2024-01-15
:document-id: PRJ-ICD-001
:document-type: ICD
:project-name: Your Project Name
:classification: Unclassified
:distribution: Distribution Statement A
:contract-number: CONTRACT-12345
:organization: Your Organization
```

### Step 2: Customize Cover Page and Status

Update sections 1 (Cover Page) and 2 (Document Status):
- Replace `[Organization Name]` with your organization
- Update `[Project Name]` with your project
- Set document status (Draft/Review/Approved/Released)

### Step 3: Write Your Abstract

Replace the placeholder text in section 3 (Abstract) with a brief overview of:
- The interfaces being documented
- The systems involved
- The purpose and scope of the ICD

### Step 4: Update Document Control

#### Revision History (Section 4.1)
Add entries for each document revision with date, author, description, and approver.

#### Applicable Documents (Section 4.2)
List documents that contain binding requirements for your interfaces.

#### Reference Documents (Section 4.3)
List documents referenced but not containing binding requirements. The template includes ECSS standards as examples.

#### Terms and Abbreviations (Section 4.4)
Add project-specific terms, definitions, and acronyms.

### Step 5: Define Your Interfaces

For each interface in your system:

1. **Add Interface Summary Entry** (Section 5.2):
   ```asciidoc
   |IF-003
   |Telemetry Data Interface
   |Spacecraft Bus
   |Ground Station
   |Data
   ```

2. **Create Requirements Section** (Section 6.X):
   - Copy the IF-001 template
   - Rename to IF-003 (or your interface ID)
   - Update description, type, and characteristics
   - Define functional, performance, and design requirements

3. **Create Detailed Specification** (Section 7.X):
   - Copy the IF-001 specification template
   - Define protocol details
   - Specify message formats
   - Document timing requirements

### Step 6: Define Data Elements

In Section 8 (Data Element Definitions):

1. **Update Primitive Types** if needed (usually standard)
2. **Define Data Elements** (Section 8.2):
   ```asciidoc
   |DE-021
   |Thruster Command
   |uint8
   |N/A
   |0-15
   |1
   |Thruster selection: 0=None, 1-15=Thruster ID
   ```

3. **Add Enumerated Types** (Section 8.3):
   ```asciidoc
   ==== Thruster State (DE-021)
   [cols="1,2,3", options="header"]
   |===
   |Value|Name|Description
   |0|OFF|Thruster disabled
   |1|ARMED|Thruster armed and ready
   |2|FIRING|Thruster actively firing
   |===
   ```

4. **Define Composite Types** (Section 8.5) for structured data

### Step 7: Customize Interface Control Procedures

Update Section 9 (Interface Control) with:
- Your change control process and approval authorities
- Verification and validation procedures specific to your project
- Test requirements and acceptance criteria

### Step 8: Update Appendices

- **Appendix A**: Customize the Interface Change Request form with your process
- **Appendix B**: Add actual interface diagrams
- **Appendix C**: Write specific test procedures for your interfaces
- **Appendix D**: Populate the compliance matrix with your requirements
- **Appendix E**: Add project-specific glossary terms

### Step 9: Remove Unused Sections

If your ICD doesn't need certain sections:
1. Delete or comment out the section
2. Remove references to it from cross-references
3. Update the table of contents (regenerates automatically)

### Tips for Customization

- **Keep Requirement IDs Consistent**: Use a numbering scheme like `<INTERFACE>-<TYPE>-<NUMBER>`
  - Example: `IF001-FREQ-001`, `IF001-PREQ-001`
- **Maintain Traceability**: Always link requirements to parent requirements
- **Use Cross-references**: Link between sections using `<<section-id>>`
- **Add Notes and Warnings**: Use `NOTE:`, `TIP:`, `IMPORTANT:`, `WARNING:`, `CAUTION:` admonitions
- **Include Diagrams**: Use PlantUML for UML diagrams or include image files

## ECSS Compliance

### ECSS Standards Overview

The European Cooperation for Space Standardization (ECSS) develops and maintains standards for space systems. This template supports documentation compliant with ECSS standards, particularly:

- **ECSS-E-ST-70C**: Space engineering - Ground systems and operations
- **ECSS-E-ST-70-41C**: Space engineering - Telemetry and telecommand packet utilization
- **ECSS-M-ST-40C**: Space project management - Configuration and information management

### ECSS Compliance Features

This template includes features that support ECSS compliance:

1. **Document Control** (ECSS-M-ST-40C):
   - Revision history with clear change tracking
   - Document status and approval tracking
   - Configuration management baseline tracking
   - Formal change control process (ICR form)

2. **Requirements Management**:
   - Unique requirement identifiers
   - Requirements traceability matrices
   - Priority levels (Mandatory/Desirable)
   - Parent-child requirement relationships

3. **Interface Documentation** (ECSS-E-ST-70C):
   - Clear interface identification (IF-XXX)
   - Provider/Consumer relationship documentation
   - Protocol specifications
   - Timing and performance requirements

4. **Data Element Definitions**:
   - Comprehensive data dictionaries
   - Data type specifications with encoding
   - Range and precision definitions
   - Enumerated types for standardized values

5. **Verification and Validation**:
   - Verification methods (Analysis, Inspection, Demonstration, Test)
   - Test procedures and acceptance criteria
   - Requirements compliance matrix

### ECSS Reference Documents

The template includes standard ECSS references in Section 4.3 (Reference Documents):

```asciidoc
|[RD1]
|ECSS-E-ST-70-41C Space engineering - Telemetry and telecommand packet utilization
|ECSS-E-ST-70-41C
|Rev. C

|[RD2]
|ECSS-E-ST-70C Space engineering - Ground systems and operations
|ECSS-E-ST-70C
|Rev. C
```

Add additional ECSS standards relevant to your project.

### ECSS Compliance Considerations

When using this template for ECSS-compliant projects:

#### Data Element Encoding
- **Byte Order**: The template defaults to big-endian (network byte order), which is common in space systems
- **Time Format**: Uses milliseconds since Unix epoch; consider adapting to CCSDS time formats if required
- **Data Types**: Primitive types are defined in Section 8.1; ensure they match your ECSS-mandated formats

#### Packet Structure
If implementing ECSS packet structures:
- Adapt message format sections to include CCSDS/ECSS packet headers
- Include Application Process ID (APID) definitions
- Document packet versioning and type codes
- Define packet secondary headers if used

#### Requirements Traceability
ECSS requires traceability from system requirements through verification:
- Maintain the "Traceability" column in requirement tables
- Use the Compliance Matrix (Appendix D) to track verification status
- Link each requirement to a parent system requirement

#### Change Control
The ICR form (Appendix A) implements basic ECSS change control:
- Customize approval levels to match your project's governance
- Add fields for RID (Review Item Discrepancy) if applicable
- Consider integrating with your project's configuration management system

#### Testing and Verification
ECSS emphasizes formal verification:
- Test procedures in Appendix C should be detailed and repeatable
- Use the four verification methods: Analysis, Inspection, Demonstration, Test
- Document all test results and link to requirement verification

### Adapting for Non-ECSS Projects

This template works well for non-space projects too:
- Remove ECSS references from Section 4.3
- Simplify change control procedures if formal ICWG is not needed
- Adapt terminology (e.g., "interface" may be "API" in software projects)
- Keep the structure but customize content to your domain

## Development Workflow

### Recommended Workflow

1. **Edit** `icd-template.adoc` with your favorite text editor
2. **Build** outputs: `make all`
3. **Review** generated PDF/HTML in the `build/` directory
4. **Iterate** until complete

### Using Watch Mode

For rapid iteration, use watch mode to auto-rebuild on changes:

```bash
make watch
```

This requires either `inotifywait` (Linux) or `entr` (macOS/Linux):

```bash
# Linux
sudo apt install inotify-tools

# macOS
brew install entr
```

### Version Control

The `.gitignore` is configured to exclude:
- `build/` directory (generated outputs)
- `vendor/bundle/` (Bundler dependencies)
- Editor temporary files

**Commit to version control**:
- `icd-template.adoc` (main source)
- `Makefile`, `Gemfile`, `setup.sh`
- Any custom themes or configuration files
- Images or diagrams referenced by the document

**Do NOT commit**:
- Generated PDF/HTML files (rebuild from source)
- `vendor/bundle/` directory
- Editor temporary files

### Collaborative Editing

For team environments:
- **Use branches** for major interface changes
- **Review AsciiDoc diffs** carefully (they're human-readable)
- **Track requirement IDs** to avoid conflicts
- **Maintain consistent formatting** (2-space indentation)
- **Run `make verify`** before committing to catch syntax errors

## Troubleshooting

### Installation Issues

#### "asciidoctor: command not found"

**Problem**: AsciiDoctor is not installed or not in PATH.

**Solution**:
```bash
# Check if installed
which asciidoctor

# If not found, install via Homebrew
brew install asciidoctor

# Or via RubyGems
gem install asciidoctor asciidoctor-pdf
```

#### "gem install" requires sudo

**Problem**: System Ruby installation requires root privileges.

**Solution**: Use Bundler for local installation:
```bash
bundle config set --local path 'vendor/bundle'
bundle install
bundle exec make all
```

#### "Could not locate Gemfile"

**Problem**: Running `bundle` commands outside the project directory.

**Solution**: Change to the project directory first:
```bash
cd /path/to/icd-template
bundle install
```

### Build Errors

#### "Failed to load AsciiDoc document"

**Problem**: Syntax error in `icd-template.adoc`.

**Solution**: Run verification to identify the error:
```bash
make verify
```

Common syntax issues:
- Missing closing `====` or `----` delimiters
- Unbalanced table column definitions
- Invalid cross-reference syntax

#### "undefined method 'pdf'"

**Problem**: `asciidoctor-pdf` is not installed.

**Solution**:
```bash
gem install asciidoctor-pdf

# Or with bundler
bundle install
```

#### PlantUML diagrams not rendering

**Problem**: PlantUML is not configured.

**Solution**: Either:
1. **Remove PlantUML diagrams** (comment out or delete diagram blocks)
2. **Install PlantUML**:
   ```bash
   brew install plantuml
   ```
   And use `asciidoctor-diagram`:
   ```bash
   gem install asciidoctor-diagram
   asciidoctor -r asciidoctor-diagram icd-template.adoc
   ```

### Output Issues

#### PDF has incorrect fonts or formatting

**Problem**: Missing fonts or theme issues.

**Solution**:
- Ensure `asciidoctor-pdf` is up to date: `gem update asciidoctor-pdf`
- Try a different PDF theme: `-a pdf-theme=default-with-font-fallbacks`
- Check PDF theme documentation: https://docs.asciidoctor.org/pdf-converter/latest/theme/

#### Cross-references showing as "[???]"

**Problem**: Invalid cross-reference target.

**Solution**: Ensure the target anchor exists:
```asciidoc
[[my-section]]
== My Section

See <<my-section>> for details.  # Correct
See <<wrong-section>> for details. # Will show [???]
```

#### Images not appearing in PDF

**Problem**: Image paths are incorrect or images are missing.

**Solution**:
- Verify image paths relative to the `.adoc` file
- Check `:imagesdir:` attribute (default: `images`)
- Ensure images exist in the specified directory

### Performance Issues

#### Build is very slow

**Problem**: Large document or many diagrams.

**Solution**:
- Build only what you need: `make pdf` or `make html`
- Use watch mode to avoid manual rebuilds: `make watch`
- Consider splitting very large documents into multiple files

## Project Structure

```
.
├── icd-template.adoc       # Main AsciiDoc source document
├── Makefile                # Build automation
├── Gemfile                 # Ruby gem dependencies
├── Gemfile.lock            # Locked gem versions
├── setup.sh                # Setup verification script
├── AGENTS.md               # Agent/automation context file
├── README.md               # This file
├── .gitignore              # Git ignore patterns
├── build/                  # Generated outputs (gitignored)
│   ├── icd-template.pdf
│   └── icd-template.html
├── images/                 # Image assets (create if needed)
│   └── [your-images.png]
├── scripts/                # Helper scripts (if any)
└── vendor/                 # Bundler dependencies (gitignored)
    └── bundle/
```

## Additional Resources

### AsciiDoc Documentation
- **AsciiDoc Syntax Quick Reference**: https://docs.asciidoctor.org/asciidoc/latest/syntax-quick-reference/
- **AsciiDoc Writer's Guide**: https://asciidoctor.org/docs/asciidoc-writers-guide/
- **AsciiDoctor User Manual**: https://asciidoctor.org/docs/user-manual/

### AsciiDoctor PDF
- **PDF Converter Documentation**: https://docs.asciidoctor.org/pdf-converter/latest/
- **Theming Guide**: https://docs.asciidoctor.org/pdf-converter/latest/theme/
- **Font Configuration**: https://docs.asciidoctor.org/pdf-converter/latest/theme/font-support/

### ECSS Standards
- **ECSS Portal**: https://ecss.nl/
- **ECSS Standards Library**: Available to ECSS members and ESA projects
- **CCSDS Standards**: https://public.ccsds.org/default.aspx (complementary to ECSS)

### Interface Control Documents
- **ICD Best Practices**: IEEE Std 1220 (Systems Engineering)
- **DoD Interface Control**: MIL-STD-961E (Technical Data Packages)

## Contributing

Contributions to improve this template are welcome:
1. Fork the repository
2. Make your improvements
3. Test thoroughly (`make all` and `make verify`)
4. Submit a pull request

Areas for potential improvement:
- Additional example interfaces (CAN bus, SpaceWire, etc.)
- Custom PDF themes
- Additional ECSS-compliant sections
- Sample diagrams and templates
- Automated testing scripts

## License

This template is provided as-is for use in your projects. Customize freely to meet your requirements.

## Support

For issues specific to this template:
- Check the [Troubleshooting](#troubleshooting) section
- Review AsciiDoctor documentation
- Open an issue in the repository

For AsciiDoctor issues:
- AsciiDoctor Discussion Forum: https://discuss.asciidoctor.org/
- GitHub Issues: https://github.com/asciidoctor/asciidoctor/issues

---

**Version**: 1.0  
**Last Updated**: 2024
