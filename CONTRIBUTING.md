# Contributing Guide

Thank you for your interest in improving the AsciiDoc Compiler! This guide will help you contribute new templates, themes, features, and improvements.

## Table of Contents

- [Getting Started](#getting-started)
- [Types of Contributions](#types-of-contributions)
- [Contributing Templates](#contributing-templates)
- [Contributing Themes](#contributing-themes)
- [Contributing Build Scripts](#contributing-build-scripts)
- [Contributing Documentation](#contributing-documentation)
- [Code Style and Conventions](#code-style-and-conventions)
- [Testing Your Contributions](#testing-your-contributions)
- [Submitting Your Contribution](#submitting-your-contribution)

## Getting Started

### Development Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/your-username/asciidoc-compiler.git
   cd asciidoc-compiler
   ```

2. **Install dependencies**
   ```bash
   bundle config set --local path 'vendor/bundle'
   bundle install
   ```

3. **Verify installation**
   ```bash
   ./setup.sh
   make verify
   ```

4. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Understanding the Repository Structure

```
.
├── templates/           # Document templates
├── ci-templates/        # CI/CD configurations
├── themes/             # Visual themes (HTML/PDF)
├── scripts/            # Build and verification scripts
├── init-project.sh     # Project initialization script
└── Makefile            # Build automation
```

## Types of Contributions

We welcome the following types of contributions:

### 1. New Document Templates
Add templates for new document types (e.g., API documentation, system design, requirements specification)

### 2. Theme Improvements
Create new visual themes or improve existing ones for better readability and branding

### 3. Build Script Enhancements
Improve automation, add validation rules, enhance error reporting

### 4. Documentation Updates
Improve guides, add examples, fix typos, clarify instructions

### 5. Bug Fixes
Fix issues in templates, scripts, or documentation

### 6. Feature Requests
Propose new features through GitHub issues (discuss before implementing)

## Contributing Templates

### Creating a New Template

Follow these steps to add a new document template:

#### Step 1: Create the Template File

Create your template in the `templates/` directory:

```bash
templates/your-template-type-template.adoc
```

#### Step 2: Template Structure

Follow this standard structure for consistency:

```asciidoc
= Document Title
:author: [Author Name]
:email: [Email Address]
:revnumber: 0.1
:revdate: [Date]
:revremark: Initial draft
:version-label: Version
:title: Document Title
:document-title: Document Title
:document-id: [Document ID]
:document-type: YOUR_TYPE
:project-name: [Project Name]
:classification: [Classification Level]
:distribution: [Distribution Statement]
:contract-number: [Contract Number]
:organization: [Organization Name]
:doctype: book
:sectnums:
:toc: left
:toclevels: 4
:icons: font
:source-highlighter: rouge
:imagesdir: images
:pdf-theme: themes/pdf/ecss-default-theme.yml
:stylesheet: themes/html/ecss-default.css

// Enable diagram support
:diagram-svg-type: svg

<<<

[.cover-page]
== Cover Page

*{document-title}*

*Document ID:* {document-id}

*Project:* {project-name}

*Classification:* {classification}

*Organization:* [Organization Name]

*Date:* {revdate}

<<<

== Document Status

[cols="1,3", options="header"]
|===
|Status|Value

|Document Status
|[Draft/Review/Approved/Released]

|Classification
|{classification}

|Distribution
|{distribution}

|Contract Number
|{contract-number}

|Version
|{revnumber}

|Date
|{revdate}
|===

<<<

== Abstract

[Provide a brief overview of the document purpose and content]

<<<

== Document Control

=== Revision History

[cols="1,1,2,3,2", options="header"]
|===
|Version|Date|Author|Description|Approver

|{revnumber}
|{revdate}
|[Author]
|Initial draft
|[Approver]
|===

=== Applicable Documents

[cols="1,3,2,1", options="header"]
|===
|Reference|Document Title|Document Number|Version

|[AD1]
|[Applicable Document Title]
|DOC-001
|1.0
|===

=== Reference Documents

[cols="1,3,2,1", options="header"]
|===
|Reference|Document Title|Document Number|Version

|[RD1]
|[Reference Document Title]
|DOC-002
|1.0
|===

=== Terms, Definitions and Abbreviations

==== Terms and Definitions

[cols="1,3", options="header"]
|===
|Term|Definition

|Term 1
|Definition of term 1

|Term 2
|Definition of term 2
|===

==== Abbreviations and Acronyms

[cols="1,3", options="header"]
|===
|Abbreviation|Meaning

|ABC
|Abbreviation Meaning

|XYZ
|Another Abbreviation
|===

<<<

// Add your custom sections here

== Introduction

=== Purpose

[Describe the purpose of this document]

=== Scope

[Define what is covered and what is excluded]

=== Document Overview

[Provide an overview of the document structure]

// Add more sections specific to your document type

<<<

[appendix]
== Appendix A: Additional Information

[Add supplementary information]

<<<

== Glossary

[cols="1,3", options="header"]
|===
|Term|Definition

|Glossary Term
|Glossary definition
|===
```

#### Step 3: Add Placeholders

Use consistent placeholder patterns:

| Placeholder | Purpose |
|-------------|---------|
| `[Author Name]` | Document author |
| `[Email Address]` | Author's email |
| `[Document ID]` | Document identifier |
| `[Project Name]` | Project name |
| `[Organization Name]` | Organization name |
| `[Classification Level]` | Security classification |
| `[Distribution Statement]` | Distribution restrictions |
| `[Contract Number]` | Contract or project number |
| `[Date]` | Date values |
| `[Approver]` | Approval authority |
| `[Draft/Review/Approved/Released]` | Document status |

The `init-project.sh` script automatically replaces these placeholders.

#### Step 4: Update init-project.sh

Add your template to the project initialization script:

1. Open `init-project.sh`
2. Find the `prompt_project_type()` function
3. Add your template option:

```bash
prompt_project_type() {
    echo ""
    print_header "Project Type Selection"
    echo ""
    echo "  1) ICD     - Interface Control Document"
    echo "  2) SSDLC   - Secure Software Development Lifecycle"
    echo "  3) Generic - General AsciiDoc documentation"
    echo "  4) YourType - Your New Document Type"  # Add this
    echo ""
    
    while true; do
        read -p "$(echo -e ${CYAN}Select project type${NC} [1-4]: )" project_type_input
        
        case $project_type_input in
            # ... existing cases ...
            4|YourType|yourtype)  # Add this case
                PROJECT_TYPE="YourType"
                TEMPLATE_FILE="yourtype-template.adoc"
                CI_TEMPLATE="ci-templates/.gitlab-ci-yourtype.yml"
                break
                ;;
            *)
                print_error "Invalid selection. Please choose 1-4."
                ;;
        esac
    done
    
    print_success "Selected project type: $PROJECT_TYPE"
}
```

#### Step 5: Create CI Template (Optional)

Create a GitLab CI configuration for your template:

```yaml
# ci-templates/.gitlab-ci-yourtype.yml

stages:
  - verify
  - build
  - deploy

variables:
  DOCUMENT_FILE: "your-document.adoc"
  OUTPUT_NAME: "your-document"

verify:
  stage: verify
  image: asciidoctor/docker-asciidoctor:latest
  script:
    - asciidoctor --version
    - bundle exec asciidoctor -o /dev/null ${DOCUMENT_FILE}
    - echo "Document syntax is valid"
  only:
    - branches

build:pdf:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  script:
    - bundle exec asciidoctor-pdf -r asciidoctor-diagram ${DOCUMENT_FILE} -o build/${OUTPUT_NAME}.pdf
  artifacts:
    paths:
      - build/${OUTPUT_NAME}.pdf
    expire_in: 1 week
  only:
    - main
    - master

build:html:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  script:
    - bundle exec asciidoctor -r asciidoctor-diagram ${DOCUMENT_FILE} -o build/${OUTPUT_NAME}.html
  artifacts:
    paths:
      - build/${OUTPUT_NAME}.html
    expire_in: 1 week
  only:
    - main
    - master
```

#### Step 6: Document Your Template

Update `templates/README.md` to document your new template:

```markdown
### Your Template Name

**Purpose**: Brief description

**Best for**:
- Use case 1
- Use case 2
- Use case 3

**Includes**:
- Feature 1
- Feature 2
- Feature 3

**Template location**: `templates/yourtype-template.adoc`
```

#### Step 7: Test Your Template

```bash
# Test the initialization script
./init-project.sh

# Select your new template type
# Verify it creates files correctly
# Build the output
make all

# Check generated PDF and HTML
ls -l build/
```

### Template Best Practices

- **Follow ECSS standards** for aerospace/space documentation
- **Include comprehensive examples** in template sections
- **Add helpful comments** to guide users
- **Use semantic section markers** (`==`, `===`, etc.)
- **Maintain consistent formatting** (2-space indentation)
- **Include cross-reference examples**
- **Add sample tables and lists**
- **Document required vs. optional sections**

## Contributing Themes

### Creating a New Theme

Themes control the visual appearance of generated documents.

#### PDF Themes

PDF themes are YAML files located in `themes/pdf/`:

```yaml
# themes/pdf/my-theme.yml

font:
  catalog:
    # Define font families
    MyFont:
      normal: fonts/myfont-regular.ttf
      bold: fonts/myfont-bold.ttf
      italic: fonts/myfont-italic.ttf
      bold_italic: fonts/myfont-bolditalic.ttf
    Mono:
      normal: fonts/mono-regular.ttf

page:
  layout: portrait
  margin: [0.75in, 1in, 0.75in, 1in]  # [top, right, bottom, left]
  size: Letter

base:
  font_family: MyFont
  font_color: 333333
  font_size: 11
  line_height_length: 14
  line_height: $base_line_height_length / $base_font_size

heading:
  font_family: MyFont
  font_color: 0000FF
  font_style: bold
  h1_font_size: 24
  h2_font_size: 20
  h3_font_size: 16
  h4_font_size: 14
  h5_font_size: 12
  h6_font_size: 11

link:
  font_color: 0000FF

code:
  font_family: Mono
  font_size: 10
  background_color: F5F5F5
  border_color: CCCCCC
  border_width: 0.5

table:
  border_color: DDDDDD
  border_width: 0.5
  head_background_color: E8E8E8
  head_font_style: bold
```

See the [Asciidoctor PDF Theming Guide](https://docs.asciidoctor.org/pdf-converter/latest/theme/) for comprehensive documentation.

#### HTML Themes

HTML themes are CSS files located in `themes/html/`:

```css
/* themes/html/my-theme.css */

/* Body and base styles */
body {
  font-family: "Your Font", Arial, sans-serif;
  font-size: 16px;
  line-height: 1.6;
  color: #333;
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

/* Headings */
h1, h2, h3, h4, h5, h6 {
  font-weight: bold;
  margin-top: 1.5em;
  margin-bottom: 0.5em;
  color: #0066cc;
}

h1 { font-size: 2.5em; }
h2 { font-size: 2em; }
h3 { font-size: 1.5em; }

/* Links */
a {
  color: #0066cc;
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}

/* Tables */
table {
  border-collapse: collapse;
  width: 100%;
  margin: 1em 0;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

th {
  background-color: #f0f0f0;
  font-weight: bold;
}

/* Code blocks */
pre, code {
  font-family: "Courier New", monospace;
  background-color: #f5f5f5;
  border: 1px solid #ccc;
}

pre {
  padding: 10px;
  overflow-x: auto;
}

code {
  padding: 2px 4px;
}
```

#### Theme Testing

Test themes by specifying them in a document:

```asciidoc
:pdf-theme: themes/pdf/my-theme.yml
:stylesheet: themes/html/my-theme.css
```

Build and review:
```bash
make all
```

### Theme Best Practices

- **Test with all template types** to ensure compatibility
- **Use web-safe fonts** or embed custom fonts
- **Consider accessibility** (contrast ratios, font sizes)
- **Test PDF page breaks** and margins
- **Document theme features** in `themes/README.md`
- **Provide before/after examples** when submitting

## Contributing Build Scripts

### Improving Existing Scripts

Scripts are located in `scripts/`:
- `compile.sh`: Advanced compilation with logging
- `verify.sh`: Document structure validation

When contributing script improvements:

1. **Maintain backward compatibility**
2. **Add clear error messages**
3. **Document new options**
4. **Test on multiple platforms** (Linux, macOS)
5. **Follow shell script best practices**

Example improvement:

```bash
#!/bin/bash

# Add a new feature with documentation
# Usage: ./compile.sh [options] <input-file>
# Options:
#   -t, --theme    Specify PDF theme
#   -o, --output   Specify output directory
#   -v, --verbose  Enable verbose output

set -e

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--theme)
      PDF_THEME="$2"
      shift 2
      ;;
    -o|--output)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    *)
      INPUT_FILE="$1"
      shift
      ;;
  esac
done

# Validate inputs
if [ -z "$INPUT_FILE" ]; then
  echo "Error: No input file specified"
  exit 1
fi

# Continue with compilation...
```

### Creating New Scripts

When adding new scripts:

1. Place in `scripts/` directory
2. Make executable: `chmod +x scripts/your-script.sh`
3. Add usage documentation in script header
4. Update `Makefile` if integrating with build system
5. Document in `README.md` or `AGENTS.md`

## Contributing Documentation

### Documentation Types

- **README.md**: Main repository documentation
- **CONTRIBUTING.md**: This file
- **AGENTS.md**: AI agent and build configuration
- **templates/README.md**: Template documentation
- **themes/README.md**: Theme documentation
- **MIGRATION_README.md**: Migration guide

### Documentation Style

- Use clear, concise language
- Include code examples
- Add step-by-step instructions
- Use proper markdown formatting
- Test all code examples
- Keep structure consistent

### Adding Examples

When adding examples:

```markdown
#### Example: Creating a Custom Section

1. Define an anchor:
   ```asciidoc
   [[custom-section]]
   == My Custom Section
   ```

2. Reference it:
   ```asciidoc
   See <<custom-section>> for details.
   ```

3. Build and verify:
   ```bash
   make verify
   make all
   ```
```

## Code Style and Conventions

### AsciiDoc Style

- **2-space indentation** for nested structures
- **Semantic section markers**: `=` (title), `==` (level 1), `===` (level 2)
- **Consistent heading hierarchy** (don't skip levels)
- **Line length**: Prefer <120 characters
- **Use anchors for cross-references**: `[[anchor-name]]`
- **Reference anchors**: `<<anchor-name>>`

### Shell Script Style

- **Use `#!/bin/bash`** shebang
- **Enable strict mode**: `set -e`, `set -u`, `set -o pipefail`
- **Quote variables**: `"$VAR"` not `$VAR`
- **Use functions** for reusable code
- **Add comments** for complex logic
- **Error handling**: Check exit codes, provide clear error messages

### YAML Style

- **2-space indentation**
- **No tabs**
- **Quote strings** with special characters
- **Consistent key naming** (lowercase with underscores)

## Testing Your Contributions

### Before Submitting

Run these tests:

1. **Syntax validation**
   ```bash
   make verify
   ```

2. **Build all templates**
   ```bash
   make all
   ```

3. **Test with init-project.sh** (for template contributions)
   ```bash
   ./init-project.sh
   # Select your template
   # Verify initialization
   make all
   ```

4. **Test on clean environment**
   ```bash
   # Start fresh Docker container
   docker-compose run --rm asciidoctor bash
   make all
   ```

5. **Check generated outputs**
   - Review PDF formatting, page breaks, fonts
   - Review HTML styling, navigation
   - Verify diagrams render correctly
   - Check all cross-references work

### Automated Tests

If adding automated tests:
- Place in `tests/` directory
- Document how to run tests
- Ensure tests are reproducible

## Submitting Your Contribution

### Pull Request Process

1. **Ensure all tests pass**
   ```bash
   make verify
   make all
   ```

2. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: Brief description of changes"
   ```

   Commit message format:
   - `Add: <description>` for new features
   - `Fix: <description>` for bug fixes
   - `Update: <description>` for improvements
   - `Docs: <description>` for documentation

3. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create Pull Request**
   - Go to GitHub repository
   - Click "New Pull Request"
   - Select your feature branch
   - Fill out the PR template

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New template
- [ ] New theme
- [ ] Build script improvement
- [ ] Documentation update
- [ ] Bug fix
- [ ] Other (describe)

## Testing Done
- [ ] Ran `make verify`
- [ ] Ran `make all`
- [ ] Tested with `init-project.sh`
- [ ] Reviewed PDF output
- [ ] Reviewed HTML output
- [ ] Tested on clean environment

## Screenshots (if applicable)
[Add screenshots of PDF/HTML output]

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] All tests pass
- [ ] Changes are backward compatible
```

### Review Process

1. Maintainers review your PR
2. Address any feedback or requested changes
3. Once approved, your contribution will be merged
4. Your name will be added to contributors list

## Getting Help

- **Documentation**: Read existing docs in the repository
- **Issues**: Search existing issues or open a new one
- **Discussions**: Use GitHub Discussions for questions
- **Examples**: Look at existing templates and themes

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Focus on what's best for the project

## Recognition

Contributors are recognized in:
- GitHub contributors list
- Repository README.md
- Release notes for significant contributions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to the AsciiDoc Compiler! Your efforts help make technical documentation better for everyone. 🎉
