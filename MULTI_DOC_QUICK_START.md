# Multi-Document Project - Quick Start Guide

This is a quick reference for the multi-document project pattern. For complete documentation, see `MULTI_DOC_PROJECT_GUIDE.md`.

## Setup (First Time Only)

```bash
# Run setup script to create example project
./setup-multi-doc-example.sh

# Navigate to example project
cd examples/multi-doc-project
```

## Common Commands

### Building

```bash
make all                # Build all PDFs and HTMLs
make pdf                # Build all PDFs only
make html               # Build all HTMLs only
make verify             # Verify AsciiDoc syntax
make clean              # Remove build artifacts
make watch              # Auto-rebuild on changes
make help               # Show all available targets
```

### Build Specific Documents

```bash
make system             # Build system-icd.*
make component          # Build component-icd.*
make ssdlc              # Build ssdlc.*
```

## Project Structure

```
examples/multi-doc-project/
├── Makefile                   # Build configuration
├── .gitlab-ci.yml            # CI/CD with matrix strategy
├── README.md                  # Project documentation
├── system-icd.adoc            # System ICD document
├── component-icd.adoc         # Component ICD document
├── ssdlc.adoc                 # SSDLC document
└── build/                     # Generated files (gitignored)
    ├── *.pdf
    └── *.html
```

## Adding a New Document

1. **Create the file:**
   ```bash
   touch new-doc.adoc
   ```

2. **Edit Makefile** - Add to DOCUMENTS list:
   ```makefile
   DOCUMENTS = system-icd component-icd ssdlc new-doc
   ```

3. **Edit .gitlab-ci.yml** - Add to matrix:
   ```yaml
   - DOCUMENT: new-doc
   ```

4. **Build:**
   ```bash
   make all
   ```

## Creating Your Own Multi-Document Project

1. **Copy example structure:**
   ```bash
   cp -r examples/multi-doc-project examples/my-project
   cd examples/my-project
   ```

2. **Update files:**
   - Edit `Makefile` - Change DOCUMENTS list
   - Edit `.gitlab-ci.yml` - Update matrix
   - Edit `README.md` - Describe your project
   - Replace `.adoc` files with your documents

3. **Build and verify:**
   ```bash
   make verify
   make all
   ```

## How It Works

```
┌─────────────────────────────────────────────────┐
│ examples/multi-doc-project/Makefile             │
│ - Lists documents to build                      │
│ - Includes framework/Makefile.include          │
│ - Defines build targets                         │
└──────────────────┬──────────────────────────────┘
                   │ includes
                   ▼
┌─────────────────────────────────────────────────┐
│ framework/Makefile.include                      │
│ - Common build rules (PDF, HTML)                │
│ - Verify, clean, watch targets                  │
│ - Pattern rules for all documents               │
└─────────────────────────────────────────────────┘

When you run: make all

1. Project Makefile includes framework rules
2. Framework provides pattern: %.pdf: %.adoc
3. Make builds each document in DOCUMENTS list
4. Outputs go to build/ directory
```

## GitLab CI/CD Matrix Strategy

```yaml
build:
  parallel:
    matrix:
      - DOCUMENT: system-icd      # Job 1
      - DOCUMENT: component-icd   # Job 2
      - DOCUMENT: ssdlc           # Job 3
  script:
    - asciidoctor-pdf ${DOCUMENT}.adoc -o build/${DOCUMENT}.pdf
    - asciidoctor ${DOCUMENT}.adoc -o build/${DOCUMENT}.html
```

**Result:** Three parallel jobs, faster pipeline, individual artifacts.

## Key Features

### Shared Framework
- Common build logic in one place
- Reusable across multiple projects
- Update once, benefit everywhere

### Multiple Documents
- Manage related docs together
- Consistent tooling and processes
- Coordinated versioning

### Parallel Builds
- GitLab matrix strategy
- Faster CI/CD execution
- Individual artifact downloads

### Simple Maintenance
- Minimal project Makefile
- Clear configuration
- Easy to extend

## Troubleshooting

### "framework/Makefile.include: No such file"
```bash
./setup-multi-doc-example.sh
```

### "command not found: asciidoctor"
```bash
bundle install           # If using Bundler
# OR
gem install asciidoctor asciidoctor-pdf
```

### Build fails for one document
```bash
make verify                           # Check syntax
asciidoctor-pdf problematic-doc.adoc  # Build directly
```

### Watch mode not working
```bash
# Linux
sudo apt install inotify-tools

# macOS
brew install entr
```

## Example Project Files

### Makefile (Minimal)
```makefile
DOCUMENTS = system-icd component-icd ssdlc
ADOC_FILES = $(addsuffix .adoc,$(DOCUMENTS))
PDF_TARGETS = $(addprefix $(BUILD_DIR)/,$(addsuffix .pdf,$(DOCUMENTS)))
HTML_TARGETS = $(addprefix $(BUILD_DIR)/,$(addsuffix .html,$(DOCUMENTS)))

include ../../framework/Makefile.include

pdf: $(PDF_TARGETS)
html: $(HTML_TARGETS)
```

### .gitlab-ci.yml (With Matrix)
```yaml
stages:
  - verify
  - build

verify:
  stage: verify
  image: asciidoctor/docker-asciidoctor:latest
  script:
    - make verify

build:
  stage: build
  image: asciidoctor/docker-asciidoctor:latest
  parallel:
    matrix:
      - DOCUMENT: system-icd
      - DOCUMENT: component-icd
      - DOCUMENT: ssdlc
  script:
    - mkdir -p build
    - asciidoctor-pdf ${DOCUMENT}.adoc -o build/${DOCUMENT}.pdf
    - asciidoctor ${DOCUMENT}.adoc -o build/${DOCUMENT}.html
  artifacts:
    paths:
      - build/${DOCUMENT}.pdf
      - build/${DOCUMENT}.html
```

## Resources

- **Complete Guide:** `MULTI_DOC_PROJECT_GUIDE.md`
- **Example Project:** `examples/multi-doc-project/`
- **Setup Script:** `setup-multi-doc-example.sh`
- **Framework Rules:** `framework/Makefile.include`

## Next Steps

1. ✓ Run `./setup-multi-doc-example.sh`
2. ✓ Explore `examples/multi-doc-project/`
3. ✓ Build examples: `cd examples/multi-doc-project && make all`
4. ✓ Read `MULTI_DOC_PROJECT_GUIDE.md` for details
5. ✓ Create your own project following the pattern

---

**Need Help?** See `MULTI_DOC_PROJECT_GUIDE.md` for comprehensive documentation and troubleshooting.
