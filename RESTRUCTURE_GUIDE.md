# Repository Restructuring Guide

This document describes the new repository structure and provides instructions for migrating to it.

## New Directory Structure

```
.
├── framework/                      # Shared build framework
│   ├── scripts/                    # Build and verification scripts
│   │   ├── compile.sh             # Advanced compilation script
│   │   └── verify.sh              # Document verification script
│   ├── themes/                     # Visual themes
│   │   ├── html/                   # HTML/CSS themes
│   │   │   ├── ecss-default.css
│   │   │   ├── minimal.css
│   │   │   ├── dark.css
│   │   │   └── corporate.css
│   │   ├── pdf/                    # PDF/YAML themes
│   │   │   ├── ecss-default-theme.yml
│   │   │   ├── minimal-theme.yml
│   │   │   ├── dark-theme.yml
│   │   │   └── corporate-theme.yml
│   │   └── README.md              # Theme documentation
│   ├── Dockerfile                  # Docker image definition
│   ├── docker-compose.yml          # Docker Compose configuration
│   └── Makefile.include           # Shared Makefile rules
│
├── templates/                      # Document templates
│   ├── icd/                        # Interface Control Document templates
│   │   ├── icd-template.adoc      # Main ICD template
│   │   └── Makefile               # ICD-specific build rules
│   ├── ssdlc/                      # SSDLC document templates
│   │   ├── ssdlc-template.adoc    # Main SSDLC template
│   │   └── Makefile               # SSDLC-specific build rules
│   └── generic/                    # Generic document templates
│       ├── generic-template.adoc   # Generic document template
│       └── Makefile               # Generic-specific build rules
│
├── build/                          # Build output (gitignored)
├── Gemfile                         # Ruby dependencies
├── Gemfile.lock                    # Locked Ruby dependencies
├── Makefile                        # Root Makefile (delegates to templates)
└── README.md                       # Main documentation
```

## Migration Steps

### Automated Migration

Run the provided migration script:

```bash
# Using shell script
chmod +x migrate_structure.sh
./migrate_structure.sh

# OR using Python script
python3 migrate_structure.py
```

### Manual Migration

If you prefer to migrate manually:

1. **Create directory structure:**
   ```bash
   mkdir -p framework/scripts
   mkdir -p framework/themes/html
   mkdir -p framework/themes/pdf
   mkdir -p templates/icd
   mkdir -p templates/ssdlc
   mkdir -p templates/generic
   ```

2. **Move scripts:**
   ```bash
   cp scripts/compile.sh framework/scripts/
   cp scripts/verify.sh framework/scripts/
   ```

3. **Move themes:**
   ```bash
   cp themes/html/* framework/themes/html/
   cp themes/pdf/* framework/themes/pdf/
   cp themes/README.md framework/themes/
   ```

4. **Move Docker files:**
   ```bash
   cp Dockerfile framework/
   cp docker-compose.yml framework/
   ```

5. **Move ICD template:**
   ```bash
   cp icd-template.adoc templates/icd/
   ```

6. **Create framework Makefile.include** (see section below)

7. **Create template-specific Makefiles** (see section below)

8. **Create placeholder templates** (see section below)

## Framework Components

### Makefile.include

Create `framework/Makefile.include` with shared build rules that can be included by all templates.

### Scripts

The compilation and verification scripts are now in `framework/scripts/` and can be used by all templates.

- **compile.sh**: Advanced compilation with custom themes and attributes
- **verify.sh**: Comprehensive document structure validation

### Themes

All visual themes (both PDF and HTML) are centralized in `framework/themes/` for reuse across all document types.

### Docker Configuration

Docker-related files are in the framework directory:
- **Dockerfile**: Defines the build environment
- **docker-compose.yml**: Orchestrates the containerized build

## Template Structure

Each template directory (`templates/icd/`, `templates/ssdlc/`, `templates/generic/`) should contain:

1. **Template AsciiDoc file(s)** - The document template(s)
2. **Makefile** - Template-specific build configuration that includes `framework/Makefile.include`
3. **README.md** (optional) - Template-specific documentation

### Example Template Makefile

```makefile
# Include shared framework rules
include ../../framework/Makefile.include

# Template-specific configuration
ASCIIDOC_FILE = icd-template.adoc
PDF_OUTPUT = icd-template.pdf
HTML_OUTPUT = icd-template.html

# Override build directory if needed
# BUILD_DIR = ../../build

.PHONY: all pdf html

all: pdf html

pdf: $(BUILD_DIR)/$(PDF_OUTPUT)

html: $(BUILD_DIR)/$(HTML_OUTPUT)

$(BUILD_DIR)/$(PDF_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating PDF..."
	@$(ASCIIDOCTOR_PDF) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(PDF_OUTPUT)
	@echo "PDF generated: $(BUILD_DIR)/$(PDF_OUTPUT)"

$(BUILD_DIR)/$(HTML_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating HTML..."
	@$(ASCIIDOCTOR) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(HTML_OUTPUT)
	@echo "HTML generated: $(BUILD_DIR)/$(HTML_OUTPUT)"
```

## Benefits of New Structure

1. **Separation of Concerns**: Framework code is separate from content templates
2. **Reusability**: Scripts, themes, and build rules are shared across all templates
3. **Scalability**: Easy to add new document types without duplicating infrastructure
4. **Maintainability**: Updates to build system only need to be made in one place
5. **Organization**: Clear structure makes it easy to find and manage components

## Building Documents After Migration

### Building from Template Directory

```bash
cd templates/icd
make all        # Build PDF and HTML
make pdf        # Build PDF only
make html       # Build HTML only
make verify     # Verify document structure
make clean      # Clean build artifacts
```

### Building from Root

```bash
make icd        # Build ICD template
make ssdlc      # Build SSDLC template
make generic    # Build generic template
make all        # Build all templates
```

## Updating Theme Paths

After migration, update theme paths in your AsciiDoc files:

**Before:**
```asciidoc
:pdf-theme: themes/pdf/ecss-default-theme.yml
:stylesheet: themes/html/ecss-default.css
```

**After (from template directory):**
```asciidoc
:pdf-theme: ../../framework/themes/pdf/ecss-default-theme.yml
:stylesheet: ../../framework/themes/html/ecss-default.css
```

## Updating Script Paths

Scripts are now referenced via the shared framework:

**Before:**
```bash
./scripts/verify.sh
```

**After (from template directory):**
```bash
../../framework/scripts/verify.sh
```

Or use via Makefile:
```bash
make verify
```

## Docker Usage After Migration

Docker configuration is now in the framework directory:

```bash
# Build Docker image
cd framework
docker build -t asciidoctor-docs:latest .

# OR use docker-compose
docker-compose build

# Run compilation in container
docker-compose run --rm asciidoctor bash
```

## Troubleshooting

### Issue: Theme files not found

**Solution**: Check that theme paths in your `.adoc` files are correct relative to the template directory.

### Issue: Scripts not executable

**Solution**: Ensure scripts have execute permissions:
```bash
chmod +x framework/scripts/*.sh
```

### Issue: Makefile.include not found

**Solution**: Verify the `include` path in your template Makefile points to the correct location of `framework/Makefile.include`.

### Issue: Build directory conflicts

**Solution**: All templates share the same build directory (`build/`) at the root. Each template should name its outputs uniquely (e.g., `icd-template.pdf`, `ssdlc-template.pdf`).

## Next Steps

1. Run the migration script or perform manual migration
2. Test building each template
3. Update any custom scripts or CI/CD pipelines to use new paths
4. Update documentation with new structure
5. Remove old directories after verifying migration success

## Questions or Issues?

If you encounter issues during migration, please:
1. Check this guide thoroughly
2. Verify all paths are correct
3. Ensure all files were copied successfully
4. Check file permissions on scripts
5. Review the example Makefiles in each template directory
