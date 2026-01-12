# Project Initialization Guide

This guide explains how to use the `init-project.sh` script to initialize new AsciiDoc documentation projects.

## Overview

The `init-project.sh` script automates the process of setting up a new documentation project by:

1. Prompting for project type (ICD/SSDLC/Generic)
2. Collecting document metadata
3. Copying the appropriate template
4. Replacing placeholders with your values
5. Generating a customized Makefile
6. Setting up GitLab CI configuration
7. Creating project directory structure

## Quick Start

```bash
# Make the script executable (if not already)
chmod +x init-project.sh

# Run the script
./init-project.sh
```

Follow the interactive prompts to configure your new project.

## Features

### Interactive Prompts

The script guides you through project initialization with clear, colorful prompts:

- **Project Type Selection**: Choose between ICD, SSDLC, or Generic documentation
- **Document Metadata**: Provide title, author, organization, and other metadata
- **Configuration Summary**: Review all settings before proceeding
- **Overwrite Confirmation**: Safely handles existing files with confirmation prompts

### Automatic Template Customization

All template placeholders are automatically replaced:

- `[Author Name]` → Your author name
- `[Document ID]` → Your document ID
- `[Project Name]` → Your project name
- `[Organization Name]` → Your organization
- `[Classification Level]` → Security classification
- `[Distribution Statement]` → Distribution restrictions
- `[Contract Number]` → Contract/project number
- And many more...

### Project Structure Creation

The script creates a complete project structure:

```
your-project/
├── my-document.adoc          # Your customized document
├── Makefile                  # Build automation
├── .gitlab-ci.yml           # CI/CD configuration
├── build/                    # Build output directory
├── images/                   # Image resources
└── scripts/                  # Additional scripts
```

## Usage

### Step 1: Run the Script

```bash
./init-project.sh
```

### Step 2: Select Project Type

You'll see:

```
════════════════════════════════════════════════════════════════
  Project Type Selection
════════════════════════════════════════════════════════════════

  1) ICD     - Interface Control Document
  2) SSDLC   - Secure Software Development Lifecycle
  3) Generic - General AsciiDoc documentation

Select project type [1-3]:
```

Enter `1`, `2`, or `3` based on your documentation needs.

### Step 3: Provide Document Metadata

The script will prompt for various metadata fields with sensible defaults:

```
════════════════════════════════════════════════════════════════
  Document Metadata
════════════════════════════════════════════════════════════════

Document name (without extension) [my-document]: system-interface-spec
Document title [system-interface-spec]: System Interface Specification
Document ID [DOC-20240115-001]: SYS-ICD-001
Author name [john]: John Doe
Organization name [My Organization]: Acme Corporation
Project name [system-interface-spec]: Acme System Integration
Initial revision [0.1]: 0.1
Revision date [2024-01-15]: 2024-01-15
Classification level [UNCLASSIFIED]: UNCLASSIFIED
Distribution statement [Approved for public release]: Internal Use Only
Contract number (optional) [N/A]: CONTRACT-2024-001
Document status [Draft]: Draft
```

**Tips:**
- Press Enter to accept default values shown in brackets
- Provide your own values to override defaults
- The document name becomes the filename (e.g., `system-interface-spec.adoc`)

### Step 4: Review and Confirm

The script displays a summary:

```
════════════════════════════════════════════════════════════════
  Configuration Summary
════════════════════════════════════════════════════════════════

  Project Type:      ICD
  Document Name:     system-interface-spec
  Document Title:    System Interface Specification
  Document ID:       SYS-ICD-001
  Author:            John Doe
  Organization:      Acme Corporation
  Project Name:      Acme System Integration
  Revision:          0.1
  Date:              2024-01-15
  Classification:    UNCLASSIFIED
  Distribution:      Internal Use Only
  Contract Number:   CONTRACT-2024-001
  Status:            Draft

Proceed with these settings? [Y/n]:
```

Type `Y` or press Enter to proceed, or `N` to cancel.

### Step 5: Completion

After successful initialization:

```
════════════════════════════════════════════════════════════════
  Project Initialization Complete!
════════════════════════════════════════════════════════════════

  Document file:     system-interface-spec.adoc
  Makefile:          Makefile
  GitLab CI:         .gitlab-ci.yml

ℹ Next steps:

  1. Review and edit system-interface-spec.adoc
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

## Project Types

### ICD (Interface Control Document)

**Best For:**
- System interface specifications
- Communication protocol documentation
- Data format definitions
- Integration specifications

**Template Features:**
- Interface overview and architecture
- Detailed interface requirements
- Protocol specifications
- Message format definitions
- Data element catalog
- Timing requirements
- Verification procedures

**CI Pipeline:**
- Syntax verification
- Structure validation
- PDF and HTML generation
- Artifact archiving

### SSDLC (Secure Software Development Lifecycle)

**Best For:**
- Security planning documents
- Secure development guidelines
- Security assessment reports
- Compliance documentation

**Template Features:**
- Security requirements
- Threat modeling
- Risk assessment
- Security controls
- Secure coding practices
- Security testing procedures

**CI Pipeline:**
- Security scanning
- Sensitive data detection
- Compliance checking
- Requirements traceability
- Secure artifact handling

### Generic

**Best For:**
- Technical specifications
- Design documents
- User manuals
- Process documentation
- General technical writing

**Template Features:**
- Flexible structure
- Standard document control sections
- Revision tracking
- Reference management
- Appendices support

**CI Pipeline:**
- Flexible build options
- Multiple format support (PDF, HTML, DocBook)
- Customizable verification
- Optional deployment stages

## Advanced Usage

### Running Non-Interactively

While the script is designed for interactive use, you can prepare a template directory in advance:

```bash
# Ensure templates exist
ls templates/

# Run the script
./init-project.sh
```

### Customizing Generated Files

After initialization, you can customize:

1. **Document Content**: Edit the generated `.adoc` file
2. **Makefile**: Adjust build settings if needed
3. **CI Configuration**: Modify `.gitlab-ci.yml` for your pipeline
4. **Themes**: Customize PDF/HTML appearance in `themes/` directory

### Handling Existing Files

The script safely handles existing files:

- If a file exists, you'll be prompted to overwrite
- Choose `Y` to overwrite or `N` to skip
- No data is lost without confirmation

Example:

```
⚠ File system-interface-spec.adoc already exists
Overwrite? [y/N]: y
ℹ Overwriting system-interface-spec.adoc...
```

## Makefile Usage

The generated Makefile provides several targets:

```bash
# Build both PDF and HTML (default)
make all

# Build individual formats
make pdf        # Generate PDF only
make html       # Generate HTML only

# Verification
make verify     # Validate AsciiDoc syntax

# Cleanup
make clean      # Remove build artifacts

# Development
make watch      # Auto-rebuild on file changes

# Docker
make docker-build  # Build Docker image

# Help
make help       # Show available targets
```

## GitLab CI Integration

The generated `.gitlab-ci.yml` is configured for your project type:

### Pipeline Stages

**All Types:**
- `verify`: Syntax and structure validation
- `build`: PDF and HTML generation
- `deploy`: Artifact deployment (manual)

**SSDLC Type Only:**
- `security`: Security scanning and sensitive data detection
- `compliance`: Compliance validation

### CI Variables

The script automatically configures:

```yaml
variables:
  DOCUMENT_FILE: "your-document.adoc"
  OUTPUT_NAME: "your-document"
  BUILD_DIR: "build"
  ARTIFACT_EXPIRATION: "7 days"
```

### Customizing CI

Edit `.gitlab-ci.yml` to:
- Add custom stages
- Modify artifact expiration
- Configure deployment targets
- Add notifications

## Troubleshooting

### Templates Not Found

**Error:**
```
✗ No icd-template.adoc found. Please create templates manually.
```

**Solution:**
Ensure templates exist in the `templates/` directory:
```bash
ls templates/
# Should show: icd-template.adoc  ssdlc-template.adoc  generic-template.adoc
```

### Script Not Executable

**Error:**
```
bash: ./init-project.sh: Permission denied
```

**Solution:**
```bash
chmod +x init-project.sh
```

### File Already Exists

**Warning:**
```
⚠ File my-document.adoc already exists
```

**Solution:**
- Choose `y` to overwrite
- Choose `n` to cancel and use a different filename
- Manually backup the existing file first if needed

### Makefile Already Exists

**Warning:**
```
⚠ Makefile already exists
```

**Solution:**
- Choose `y` to overwrite with new customized Makefile
- Choose `n` to keep existing Makefile
- The script will still work; you may need to manually update Makefile variables

## Tips and Best Practices

### Document Naming

- Use lowercase with hyphens: `system-interface-spec`
- Be descriptive but concise
- Avoid spaces and special characters
- The name becomes the filename

### Document IDs

Follow a consistent pattern:
- `SYS-ICD-001` for interface documents
- `SEC-SSDLC-001` for security documents
- `DOC-20240115-001` for date-based IDs
- `PROJ-SPEC-001` for project specifications

### Revision Strategy

- Start with `0.1` for initial draft
- Use `0.x` for drafts under review
- Use `1.0` for first approved release
- Increment major version for significant changes

### Classification Guidelines

Common classification levels:
- `UNCLASSIFIED` - Public information
- `INTERNAL` - Company internal use
- `CONFIDENTIAL` - Restricted access
- `SECRET` - Highly restricted

### Organization Workflow

1. **Initialize**: Run `init-project.sh`
2. **Customize**: Edit the generated document
3. **Build**: Run `make all` to test
4. **Commit**: Add to version control
5. **Review**: Share for peer review
6. **Approve**: Get formal approval
7. **Release**: Update status and publish

## Examples

### Example 1: Creating an ICD

```bash
./init-project.sh

# Responses:
# Project type: 1 (ICD)
# Document name: comms-protocol-icd
# Document title: Communications Protocol ICD
# Document ID: SYS-ICD-2024-001
# Author: Jane Smith
# Organization: Space Systems Inc
# Project: Satellite Ground Segment
# ... (accept other defaults)
```

Result: `comms-protocol-icd.adoc` with ICD structure

### Example 2: Creating an SSDLC Document

```bash
./init-project.sh

# Responses:
# Project type: 2 (SSDLC)
# Document name: security-plan
# Document title: Project Security Plan
# Document ID: SEC-PLAN-001
# Classification: CONFIDENTIAL
# ... (fill in other details)
```

Result: `security-plan.adoc` with SSDLC structure

### Example 3: Creating a Generic Document

```bash
./init-project.sh

# Responses:
# Project type: 3 (Generic)
# Document name: user-guide
# Document title: System User Guide
# Document ID: DOC-UG-001
# ... (fill in other details)
```

Result: `user-guide.adoc` with generic structure

## Script Architecture

### Functions

The script is organized into modular functions:

- `check_templates()` - Verify template availability
- `prompt_project_type()` - Select document type
- `prompt_metadata()` - Collect document metadata
- `display_summary()` - Show configuration review
- `copy_template()` - Copy template file
- `update_placeholders()` - Replace template placeholders
- `copy_ci_template()` - Set up CI configuration
- `generate_makefile()` - Create custom Makefile
- `update_ci_variables()` - Update CI variables
- `create_project_structure()` - Create directories
- `display_final_instructions()` - Show next steps

### Color Coding

The script uses colors for clarity:

- 🔵 **Blue (Info)**: Informational messages
- ✅ **Green (Success)**: Successful operations
- ⚠️ **Yellow (Warning)**: Warnings and prompts
- ❌ **Red (Error)**: Error messages
- 🔷 **Cyan (Headers)**: Section headers

## Version History

- **v1.0.0** - Initial release
  - Support for ICD, SSDLC, and Generic templates
  - Interactive metadata collection
  - Automatic placeholder replacement
  - Makefile generation
  - GitLab CI configuration
  - Project structure creation

## Support and Contribution

### Getting Help

1. Review this guide
2. Check `templates/README.md` for template details
3. Consult `AGENTS.md` for build instructions
4. Review example documents in the repository

### Reporting Issues

When reporting issues, include:
- Script version (shown in header)
- Project type selected
- Error messages (copy exact text)
- Operating system and shell version

### Contributing

To improve the script:
1. Test your changes thoroughly
2. Update this documentation
3. Follow existing code style
4. Add comments for complex logic

## See Also

- `templates/README.md` - Template documentation
- `AGENTS.md` - Build and CI/CD instructions
- `README.md` - Repository overview
- AsciiDoc Documentation: https://docs.asciidoctor.org/
