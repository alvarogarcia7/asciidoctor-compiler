# AsciiDoc Compiler

A comprehensive framework for creating professional technical documentation using AsciiDoc, featuring multiple document templates, automated builds, and enterprise-ready tooling.

## 🎯 What is This Repository?

This is a **template repository** designed to help you quickly create professional technical documentation. Instead of creating documents from scratch, you can initialize new documentation projects from pre-built templates that follow industry best practices and standards.

### Key Features

- **Multiple Document Templates**: ICD, SSDLC, Generic documentation templates
- **Automated Project Initialization**: One-command setup with `init-project.sh`
- **Professional Formatting**: ECSS-compliant styling for aerospace/space systems
- **CI/CD Ready**: GitLab CI templates included
- **Diagram Support**: Built-in PlantUML and Graphviz integration
- **Multi-format Output**: Generate both PDF and HTML from single source
- **Reusable Framework**: Shared build scripts, themes, and configurations

## 🚀 Quick Start

### Prerequisites

Choose one of the following installation methods:

<details>
<summary><b>Option 1: Homebrew (macOS/Linux) - Recommended</b></summary>

```bash
brew install asciidoctor plantuml graphviz
```
</details>

<details>
<summary><b>Option 2: RubyGems (All Platforms)</b></summary>

```bash
gem install asciidoctor asciidoctor-pdf asciidoctor-diagram

# Also install PlantUML and Graphviz
# macOS: brew install plantuml graphviz
# Ubuntu: sudo apt-get install plantuml graphviz default-jre
```
</details>

<details>
<summary><b>Option 3: Bundler (Project-local)</b></summary>

```bash
bundle config set --local path 'vendor/bundle'
bundle install
```
</details>

<details>
<summary><b>Option 4: Docker (No Local Installation)</b></summary>

```bash
make docker-build
docker-compose run --rm asciidoctor make all
```
</details>

### Initialize a New Project

Use the initialization script to create a new documentation project:

```bash
./init-project.sh
```

The script will:
1. ✨ Ask you to choose a document type (ICD, SSDLC, or Generic)
2. 📝 Prompt for document metadata (title, author, organization, etc.)
3. 📋 Copy the appropriate template and customize it with your information
4. ⚙️ Generate a customized Makefile for building
5. 🔧 Set up GitLab CI configuration (optional)
6. 📁 Create project directory structure

### Build Your Document

```bash
make all          # Build both PDF and HTML
make pdf          # Build PDF only
make html         # Build HTML only
make verify       # Verify document syntax
make watch        # Auto-rebuild on changes
make clean        # Remove build artifacts
```

Find your generated documents in the `build/` directory.

## 📚 Available Document Types & Templates

### 🔌 Interface Control Document (ICD)

**Purpose**: Document system interfaces, protocols, and data formats

**Best for**:
- Defining interfaces between systems or subsystems
- Communication protocol documentation
- Data format and message specifications
- Integration documentation for complex systems

**Includes**:
- Complete ICD structure following ECSS standards
- Interface requirements and specifications
- Data element definitions with types and ranges
- Protocol specifications and message formats
- Timing and performance requirements
- Verification and validation procedures
- Interface change control process

**Template location**: `templates/icd-template.adoc`

### 🔒 Secure Software Development Lifecycle (SSDLC)

**Purpose**: Document security processes and secure development practices

**Best for**:
- Security planning and requirements documentation
- Secure development lifecycle documentation
- Security assessment and audit reports
- Compliance documentation (FedRAMP, NIST, etc.)

**Includes**:
- Security requirements definition
- Threat modeling and risk assessment
- Security controls documentation
- Secure coding practices and standards
- Security testing procedures
- Compliance tracking matrices

**Template location**: `templates/ssdlc-template.adoc`

### 📄 Generic Documentation

**Purpose**: General-purpose technical documentation template

**Best for**:
- Technical specifications
- Design documents
- User manuals and guides
- Process documentation
- Architecture documentation
- Any technical documentation that doesn't fit ICD or SSDLC

**Includes**:
- Flexible document structure
- Standard document control sections
- Revision history tracking
- Reference documentation sections
- Appendices support
- Professional formatting

**Template location**: `templates/generic-template.adoc`

## 🏗️ Framework Components Overview

### Directory Structure

```
.
├── init-project.sh              # Project initialization script
├── Makefile                     # Root build automation
├── Gemfile                      # Ruby dependencies
│
├── templates/                   # Document templates
│   ├── icd-template.adoc       # Interface Control Document
│   ├── ssdlc-template.adoc     # SSDLC documentation
│   ├── generic-template.adoc   # Generic documentation
│   └── README.md               # Template documentation
│
├── ci-templates/                # GitLab CI configurations
│   ├── .gitlab-ci-icd.yml      # ICD pipeline
│   ├── .gitlab-ci-ssdlc.yml    # SSDLC pipeline
│   └── .gitlab-ci-generic.yml  # Generic pipeline
│
├── themes/                      # Visual themes
│   ├── html/                   # HTML/CSS themes
│   └── pdf/                    # PDF themes
│
├── scripts/                     # Build and verification scripts
│   ├── compile.sh              # Advanced compilation
│   └── verify.sh               # Document verification
│
├── build/                       # Generated outputs (gitignored)
└── vendor/bundle/              # Ruby gems (gitignored)
```

### Core Components

#### Templates (`templates/`)
Pre-built AsciiDoc templates following industry standards and best practices. Each template includes:
- Professional document structure
- Pre-defined sections and formatting
- Placeholder text and examples
- Standard document control sections

#### Themes (`themes/`)
Visual styling for both HTML and PDF outputs:
- **PDF themes**: YAML files controlling fonts, colors, spacing, page layout
- **HTML themes**: CSS files for web-based documentation
- Default themes are ECSS-compliant for aerospace/space systems
- Customizable for corporate branding

#### Scripts (`scripts/`)
Automation and validation tools:
- `compile.sh`: Advanced compilation with logging and error handling
- `verify.sh`: Document structure and content validation
- Cross-reference checking and compliance verification

#### CI/CD Templates (`ci-templates/`)
Ready-to-use GitLab CI configurations for automated builds:
- Automatic PDF/HTML generation on commits
- Syntax verification
- Artifact publishing
- Customizable for different project types

## 🔄 Migrating Existing Projects

Have existing documentation you want to migrate to this framework? Follow the migration guide below.

### Migration Steps

1. **Analyze your existing document structure**
   - Identify document type (ICD, SSDLC, or generic)
   - Note custom sections and formatting requirements
   - List any special diagrams or includes

2. **Choose the appropriate template**
   ```bash
   # Copy the closest matching template
   cp templates/icd-template.adoc my-existing-doc.adoc
   ```

3. **Map your content to template sections**
   - Match your existing sections to template sections
   - Identify content that needs to be preserved
   - Note any sections to add or remove

4. **Transfer content incrementally**
   - Start with document metadata and attributes
   - Move section by section, maintaining structure
   - Preserve custom formatting using AsciiDoc syntax
   - Keep tables, diagrams, and cross-references

5. **Update document attributes**
   ```asciidoc
   :document-title: Your Document Title
   :document-id: YOUR-DOC-ID
   :author: Your Name
   :organization: Your Organization
   ```

6. **Convert formatting to AsciiDoc**
   - **Bold**: `*text*` or `**text**`
   - **Italic**: `_text_` or `__text__`
   - **Code**: `` `code` `` or `[source,language]`
   - **Lists**: `*`, `-`, or `.` for bullets; `1.`, `2.` for numbered
   - **Tables**: Use AsciiDoc table syntax (see templates for examples)
   - **Diagrams**: Convert to PlantUML or include as images

7. **Add cross-references**
   ```asciidoc
   [[section-id]]
   == Section Title
   
   See <<section-id>> for details.
   ```

8. **Migrate images and diagrams**
   - Place images in `images/` directory
   - Update image paths: `image::images/diagram.png[]`
   - Convert diagrams to PlantUML where possible

9. **Validate and build**
   ```bash
   make verify      # Check syntax and structure
   make all         # Build PDF and HTML
   ```

10. **Review output quality**
    - Check formatting and styling
    - Verify all cross-references work
    - Ensure diagrams render correctly
    - Review page breaks in PDF

### Migration Tips

- **Start simple**: Migrate basic content first, then add complexity
- **Use version control**: Commit frequently during migration
- **Test incrementally**: Build after each major section migration
- **Keep original**: Maintain original document until migration is complete
- **Leverage templates**: Use template examples for complex formatting

### Common Migration Scenarios

<details>
<summary><b>From Microsoft Word</b></summary>

1. Save Word document as plain text or Markdown
2. Copy content section by section into AsciiDoc template
3. Reformat tables using AsciiDoc table syntax
4. Export images and reference them in AsciiDoc
5. Recreate formatting with AsciiDoc markup
</details>

<details>
<summary><b>From LaTeX</b></summary>

1. Map LaTeX sections to AsciiDoc sections
2. Convert LaTeX math to AsciiDoc math (STEM support)
3. Convert `\ref{}` to AsciiDoc cross-references `<<>>`
4. Adapt LaTeX tables to AsciiDoc tables
5. Keep existing images or diagrams
</details>

<details>
<summary><b>From Markdown</b></summary>

1. Most Markdown syntax is valid AsciiDoc
2. Update image syntax: `![alt](path)` → `image::path[alt]`
3. Add AsciiDoc document header and attributes
4. Use AsciiDoc table syntax for complex tables
5. Add cross-references and document metadata
</details>

<details>
<summary><b>From Plain Text</b></summary>

1. Choose appropriate template based on content type
2. Copy text into template sections
3. Add AsciiDoc formatting markup
4. Structure content with section headers
5. Add tables, lists, and formatting as needed
</details>

### Need Help?

See `MIGRATION_README.md` for detailed migration examples and troubleshooting.

## 🎨 Customization

### Customizing Templates

Templates use placeholders that are automatically replaced by `init-project.sh`:
- `[Author Name]` → Your name
- `[Document ID]` → Document identifier
- `[Project Name]` → Project name
- `[Organization Name]` → Your organization

Manual customization:
1. Edit the generated `.adoc` file
2. Modify sections, add content, remove unused parts
3. Add diagrams with PlantUML or image includes
4. Update document attributes in the header

### Customizing Themes

**PDF themes** (`themes/pdf/*.yml`):
```yaml
font:
  catalog:
    MyFont:
      normal: myfont-regular.ttf
      bold: myfont-bold.ttf
base:
  font_color: 333333
  font_family: MyFont
```

**HTML themes** (`themes/html/*.css`):
```css
body {
  font-family: "Your Font", sans-serif;
  color: #333;
}
```

Specify custom theme in your document:
```asciidoc
:pdf-theme: themes/pdf/my-custom-theme.yml
:stylesheet: themes/html/my-custom.css
```

### Adding Custom Templates

See `CONTRIBUTING.md` for instructions on creating and adding new template types.

## 🔧 Development Workflow

### Recommended Workflow

1. **Initialize project**: `./init-project.sh`
2. **Edit content**: Modify `.adoc` file in your text editor
3. **Build**: `make all`
4. **Review**: Check outputs in `build/` directory
5. **Iterate**: Repeat steps 2-4
6. **Commit**: Use git for version control

### Watch Mode for Live Editing

```bash
make watch
```

Requires `inotifywait` (Linux) or `entr` (macOS):
```bash
# Linux
sudo apt install inotify-tools

# macOS
brew install entr
```

### Version Control Best Practices

**Commit to git**:
- `.adoc` source files
- `Makefile`, `Gemfile`, configuration files
- Custom themes or scripts
- Images and diagrams

**Do NOT commit** (covered by `.gitignore`):
- `build/` directory (generated outputs)
- `vendor/bundle/` (Ruby gems)
- Editor temporary files

## 📖 Documentation

- **AGENTS.md**: AI agent configuration and build instructions
- **templates/README.md**: Detailed template documentation
- **themes/README.md**: Theme customization guide
- **MIGRATION_README.md**: Detailed migration guide with examples
- **CONTRIBUTING.md**: Guide for contributing templates and improvements

## 🔍 Troubleshooting

### Installation Issues

**"asciidoctor: command not found"**
```bash
# Install via Homebrew
brew install asciidoctor

# Or via RubyGems
gem install asciidoctor asciidoctor-pdf
```

**"Could not locate Gemfile"**
```bash
# Run from project directory
cd /path/to/project
bundle install
```

### Build Errors

**"Failed to load AsciiDoc document"**
```bash
# Run verification to find errors
make verify
```

**PlantUML diagrams not rendering**
```bash
# Install PlantUML and Graphviz
brew install plantuml graphviz  # macOS
sudo apt-get install plantuml graphviz default-jre  # Linux
```

### Output Issues

**Cross-references showing as "[???]"**
- Ensure anchor exists: `[[anchor-name]]`
- Reference correctly: `<<anchor-name>>`

**Images not appearing**
- Check image paths relative to `.adoc` file
- Verify `:imagesdir:` attribute
- Ensure images exist in specified directory

See the full troubleshooting guide in the original README sections.

## 🤝 Contributing

We welcome contributions! See `CONTRIBUTING.md` for:
- How to improve existing templates
- Creating new template types
- Adding themes and styles
- Reporting issues and suggesting features

## 📜 License

This template framework is provided as-is for use in your projects. Customize freely to meet your requirements.

## 🆘 Support

- **Documentation**: Check `AGENTS.md`, `templates/README.md`, and `themes/README.md`
- **AsciiDoc Help**: https://docs.asciidoctor.org/
- **Issues**: Open an issue in this repository
- **Community**: AsciiDoctor Discussion Forum at https://discuss.asciidoctor.org/

---

**Version**: 0.1  
**Last Updated**: 2026  
**Status**: Active Development
