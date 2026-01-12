# Document Templates

This directory contains AsciiDoc templates for different document types. These templates are used by the `init-project.sh` script to initialize new documentation projects.

## Available Templates

### ICD Template (`icd-template.adoc`)
**Interface Control Document (ICD)** template for documenting system interfaces.

**Features:**
- Comprehensive interface specifications
- Data element definitions with types and ranges
- Protocol specifications and message formats
- Timing requirements and performance specifications
- Verification and validation procedures
- ECSS-compliant structure

**Use Cases:**
- Defining interfaces between systems or subsystems
- Communication protocol documentation
- Data format specifications
- Integration documentation

### SSDLC Template (`ssdlc-template.adoc`)
**Secure Software Development Lifecycle** template for documenting security processes.

**Features:**
- Security requirements definition
- Threat modeling and risk assessment
- Security controls documentation
- Secure coding practices
- Security testing procedures
- Compliance tracking

**Use Cases:**
- Security planning documents
- Secure development guidelines
- Security assessment reports
- Compliance documentation

### Generic Template (`generic-template.adoc`)
**General-purpose documentation** template for any type of technical document.

**Features:**
- Flexible structure
- Standard document control sections
- Revision history tracking
- Reference documentation sections
- Appendices support

**Use Cases:**
- Technical specifications
- Design documents
- User manuals
- Process documentation
- Any other technical documentation

## Using Templates

### With init-project.sh (Recommended)

The easiest way to use these templates is with the `init-project.sh` script:

```bash
./init-project.sh
```

The script will:
1. Prompt you to select a template type
2. Ask for document metadata (title, author, organization, etc.)
3. Copy the appropriate template to your project
4. Replace all placeholders with your provided values
5. Generate a customized Makefile
6. Set up the GitLab CI configuration

### Manual Usage

You can also manually copy and customize templates:

```bash
# Copy a template
cp templates/icd-template.adoc my-document.adoc

# Edit the document and replace placeholders
# - [Author Name] → Your name
# - [Document ID] → Your document ID
# - [Project Name] → Your project name
# - [Organization Name] → Your organization
# etc.
```

## Template Structure

All templates follow a consistent structure:

1. **Document Header**: Title and AsciiDoc attributes
2. **Cover Page**: Professional document cover with metadata
3. **Document Status**: Status table with classification
4. **Abstract**: Brief document overview
5. **Document Control**: 
   - Revision History
   - Applicable Documents
   - Reference Documents
   - Terms, Definitions and Abbreviations
6. **Main Content**: Template-specific sections
7. **Appendices**: Supplementary information

## Customization

### Adding New Templates

To add a new template:

1. Create a new `.adoc` file in this directory
2. Follow the existing template structure
3. Add appropriate placeholders (e.g., `[Author Name]`, `[Project Name]`)
4. Update `init-project.sh` to support the new template type
5. Update this README with template documentation

### Placeholder Conventions

Use these placeholder patterns consistently:

- `[Author Name]` - Document author
- `[Document ID]` - Document identifier
- `[Project Name]` - Project name
- `[Organization Name]` - Organization name
- `[Classification Level]` - Security classification
- `[Distribution Statement]` - Distribution restrictions
- `[Contract Number]` - Contract or project number
- `[Date]` - Date values
- `[Approver]` - Approval authority

The `init-project.sh` script will automatically replace these placeholders.

## AsciiDoc Attributes

All templates use consistent AsciiDoc attributes:

```asciidoc
:document-title: Document Title
:document-id: Document ID
:document-type: Document Type
:project-name: Project Name
:classification: Classification Level
:distribution: Distribution Statement
:contract-number: Contract Number
:organization: Organization Name
```

These attributes can be referenced throughout the document using `{attribute-name}` syntax.

## Themes and Styling

Templates reference theme files in the `themes/` directory:

- PDF: `themes/pdf/ecss-default-theme.yml`
- HTML: `themes/html/ecss-default.css`

You can customize the appearance by modifying these theme files or creating new ones.

## Building Documents

After creating a document from a template:

```bash
# Build both PDF and HTML
make all

# Build PDF only
make pdf

# Build HTML only
make html

# Verify document syntax
make verify

# Clean build artifacts
make clean
```

## CI/CD Integration

Each template type has a corresponding GitLab CI template in `ci-templates/`:

- `ci-templates/.gitlab-ci-icd.yml` → ICD projects
- `ci-templates/.gitlab-ci-ssdlc.yml` → SSDLC projects
- `ci-templates/.gitlab-ci-generic.yml` → Generic projects

The `init-project.sh` script automatically copies the appropriate CI template to `.gitlab-ci.yml`.

## Support

For questions or issues with templates:

1. Check the AGENTS.md file for build and setup instructions
2. Review existing documents for examples
3. Consult the AsciiDoc documentation: https://docs.asciidoctor.org/
