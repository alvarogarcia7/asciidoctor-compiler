# Multi-Document Project Example - Setup Instructions

This document explains the multi-document project example that demonstrates how to manage multiple AsciiDoc documents in a single project.

## Quick Setup

To set up the multi-document project example, run the setup script:

```bash
./setup-multi-doc-example.sh
```

This will create:
- `framework/` directory with shared Makefile
- `examples/multi-doc-project/` directory with example documents
- All necessary files for a complete multi-document project

## What Gets Created

### Directory Structure

```
.
├── framework/
│   └── Makefile.include          # Shared build rules
└── examples/
    └── multi-doc-project/
        ├── Makefile               # Project-specific Makefile
        ├── .gitlab-ci.yml        # CI/CD with matrix strategy
        ├── README.md              # Project documentation
        ├── system-icd.adoc        # System ICD document
        ├── component-icd.adoc     # Component ICD document
        ├── ssdlc.adoc             # SSDLC document
        └── build/                 # Generated outputs (created on first build)
```

### Key Files

**framework/Makefile.include**
- Shared build rules for all AsciiDoc projects
- Common targets: all, pdf, html, verify, clean, watch, help
- Automatic detection of bundler vs system asciidoctor
- Reusable across multiple projects

**examples/multi-doc-project/Makefile**
- Includes framework/Makefile.include
- Defines project documents
- Provides document-specific build targets
- Simple and maintainable

**examples/multi-doc-project/.gitlab-ci.yml**
- CI/CD configuration with matrix strategy
- Parallel document builds
- Automatic artifact generation
- Verify, build, and deploy stages

**Example Documents**
- **system-icd.adoc**: System-level Interface Control Document
- **component-icd.adoc**: Component-level ICD
- **ssdlc.adoc**: Secure Software Development Lifecycle document

## Usage After Setup

### Build All Documents

```bash
cd examples/multi-doc-project
make all
```

This generates all PDF and HTML files in the `build/` directory.

### Build Specific Documents

```bash
make pdf                # Build all PDFs
make html               # Build all HTMLs
make system             # Build system-icd.pdf and system-icd.html
make component          # Build component-icd.pdf and component-icd.html
make ssdlc              # Build ssdlc.pdf and ssdlc.html
```

### Verify Syntax

```bash
make verify
```

### Development Mode

```bash
make watch
```

Auto-rebuilds documents when files change (requires `inotifywait` or `entr`).

### Clean Build Artifacts

```bash
make clean
```

## Multi-Document Pattern Explained

### 1. Shared Framework

The `framework/Makefile.include` provides common build logic that can be reused across multiple projects. Benefits:

- **Consistency**: All projects use the same build rules
- **Maintainability**: Update once, apply everywhere
- **Simplicity**: Project Makefiles are minimal

### 2. Project-Specific Makefile

Each multi-document project has its own Makefile that:
- Lists the documents to build
- Includes the framework Makefile
- Optionally adds project-specific rules

Example:
```makefile
# List documents
DOCUMENTS = system-icd component-icd ssdlc
ADOC_FILES = $(addsuffix .adoc,$(DOCUMENTS))

# Include framework
include ../../framework/Makefile.include

# Define targets
PDF_TARGETS = $(addprefix $(BUILD_DIR)/,$(addsuffix .pdf,$(DOCUMENTS)))
HTML_TARGETS = $(addprefix $(BUILD_DIR)/,$(addsuffix .html,$(DOCUMENTS)))

pdf: $(PDF_TARGETS)
html: $(HTML_TARGETS)
```

### 3. GitLab CI/CD Matrix Strategy

The `.gitlab-ci.yml` uses GitLab's matrix feature to build documents in parallel:

```yaml
build:
  parallel:
    matrix:
      - DOCUMENT: system-icd
      - DOCUMENT: component-icd
      - DOCUMENT: ssdlc
  script:
    - asciidoctor-pdf ${DOCUMENT}.adoc -o build/${DOCUMENT}.pdf
    - asciidoctor ${DOCUMENT}.adoc -o build/${DOCUMENT}.html
```

Benefits:
- **Parallel Execution**: Faster CI/CD
- **Individual Artifacts**: Per-document downloads
- **Clear Status**: See which documents pass/fail

### 4. Document Organization

All related documents live in one project directory:
- Shared configuration
- Common assets (images, diagrams)
- Unified version control
- Single CI/CD pipeline

## Extending the Example

### Add New Document

1. Create `new-doc.adoc` in the project directory
2. Add to `DOCUMENTS` list in Makefile:
   ```makefile
   DOCUMENTS = system-icd component-icd ssdlc new-doc
   ```
3. Add to CI/CD matrix in `.gitlab-ci.yml`:
   ```yaml
   - DOCUMENT: new-doc
   ```
4. Build:
   ```bash
   make all
   ```

### Customize Build for Specific Document

Add special rules in project Makefile:

```makefile
# Custom options for system-icd
$(BUILD_DIR)/system-icd.pdf: system-icd.adoc
	@echo "Generating system ICD with custom theme..."
	@$(ASCIIDOCTOR_PDF) $(PDF_OPTS) \
		-a pdf-theme=custom-theme.yml \
		$< -o $@
```

### Share Resources Across Documents

Create shared include files:

```
examples/multi-doc-project/
├── includes/
│   ├── common-intro.adoc
│   ├── common-terms.adoc
│   └── company-info.adoc
├── system-icd.adoc
├── component-icd.adoc
└── ssdlc.adoc
```

Include in documents:

```asciidoc
// In system-icd.adoc
include::includes/common-intro.adoc[]
include::includes/common-terms.adoc[]
```

## Best Practices

1. **One Project Per Repository Section**: Keep related documents together
2. **Use Framework**: Don't duplicate build logic
3. **Matrix Strategy**: For 3+ documents, use parallel builds
4. **Consistent Naming**: Use lowercase with hyphens (e.g., `system-icd.adoc`)
5. **Version Documents Together**: Related docs should have synchronized versions
6. **Shared Includes**: Extract common content to include files
7. **Document Dependencies**: Note cross-references between documents

## Advantages of This Pattern

### For Development
- Single build command for all documents
- Consistent tooling and processes
- Easy to add new documents
- Watch mode for rapid iteration

### For CI/CD
- Parallel builds reduce pipeline time
- Individual artifacts for each document
- Clear build status per document
- Easy to extend matrix for new documents

### For Maintenance
- Centralized build logic
- Update framework once, benefit everywhere
- Clear project structure
- Version control integration

### For Collaboration
- Multiple documents in one repository
- Unified review process
- Shared assets and templates
- Clear ownership per document

## Troubleshooting

### "framework/Makefile.include: No such file"
Run the setup script: `./setup-multi-doc-example.sh`

### Build Fails for One Document
- Check syntax: `make verify`
- Build individually: `asciidoctor-pdf system-icd.adoc -o build/system-icd.pdf`
- Check error messages

### CI/CD Matrix Not Working
- Verify GitLab version supports `parallel:matrix` (GitLab 13.3+)
- Check `.gitlab-ci.yml` syntax
- Ensure document names match in Makefile and `.gitlab-ci.yml`

### Watch Mode Not Working
Install file monitoring tool:
- Linux: `apt install inotify-tools`
- macOS: `brew install entr`

## Additional Resources

- AsciiDoctor documentation: https://asciidoctor.org
- GitLab CI/CD matrix: https://docs.gitlab.com/ee/ci/yaml/#parallelmatrix
- Make documentation: https://www.gnu.org/software/make/manual/

## Support

For questions or issues:
1. Check the `examples/multi-doc-project/README.md`
2. Review framework documentation
3. Consult main project README.md
