# Repository Restructuring - Quick Start

This repository has been prepared for restructuring into a framework-based multi-template system.

## Migration Scripts

Two migration scripts are provided:

### Option 1: Shell Script (Recommended for Unix/Linux/macOS)

```bash
chmod +x restructure.sh
./restructure.sh
```

### Option 2: Python Script (Cross-platform)

```bash
python3 restructure.py
```

## What the Scripts Do

Both scripts perform the same operations:

1. **Create directory structure:**
   - `framework/scripts/` - Build and verification scripts
   - `framework/themes/html/` - HTML themes
   - `framework/themes/pdf/` - PDF themes
   - `templates/icd/` - ICD template directory
   - `templates/ssdlc/` - SSDLC template directory
   - `templates/generic/` - Generic template directory

2. **Copy existing files:**
   - Scripts from `scripts/` to `framework/scripts/`
   - Themes from `themes/` to `framework/themes/`
   - Docker files to `framework/`
   - ICD template to `templates/icd/`

3. **Create new files:**
   - `framework/Makefile.include` - Shared Makefile rules
   - `templates/icd/Makefile` - ICD-specific Makefile
   - `templates/ssdlc/ssdlc-template.adoc` - SSDLC template
   - `templates/ssdlc/Makefile` - SSDLC-specific Makefile
   - `templates/generic/generic-template.adoc` - Generic template
   - `templates/generic/Makefile` - Generic-specific Makefile
   - `Makefile.new` - New root Makefile

## After Running the Script

1. **Review the new structure:**
   ```bash
   tree framework templates
   ```

2. **Test building templates:**
   ```bash
   # Build ICD template
   cd templates/icd
   make all
   
   # Build SSDLC template
   cd ../ssdlc
   make all
   
   # Build generic template
   cd ../generic
   make all
   ```

3. **Check outputs:**
   ```bash
   ls -l ../../build/
   ```
   You should see:
   - `icd-template.pdf` and `icd-template.html`
   - `ssdlc-template.pdf` and `ssdlc-template.html`
   - `generic-template.pdf` and `generic-template.html`

4. **Replace root Makefile (optional):**
   ```bash
   # Review the new Makefile first
   cat Makefile.new
   
   # If satisfied, replace the old one
   mv Makefile Makefile.old
   mv Makefile.new Makefile
   ```

5. **Build from root (after replacing Makefile):**
   ```bash
   make all      # Build all templates
   make icd      # Build ICD only
   make ssdlc    # Build SSDLC only
   make generic  # Build generic only
   make clean    # Clean build artifacts
   ```

## New Directory Structure

```
.
├── framework/                          # Shared framework
│   ├── scripts/                        # Build scripts
│   │   ├── compile.sh                  # Compilation script
│   │   └── verify.sh                   # Verification script
│   ├── themes/                         # Visual themes
│   │   ├── html/                       # HTML themes
│   │   │   ├── ecss-default.css
│   │   │   ├── minimal.css
│   │   │   ├── dark.css
│   │   │   └── corporate.css
│   │   ├── pdf/                        # PDF themes
│   │   │   ├── ecss-default-theme.yml
│   │   │   ├── minimal-theme.yml
│   │   │   ├── dark-theme.yml
│   │   │   └── corporate-theme.yml
│   │   └── README.md
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── Makefile.include                # Shared Makefile rules
│
├── templates/                          # Document templates
│   ├── icd/
│   │   ├── icd-template.adoc
│   │   └── Makefile
│   ├── ssdlc/
│   │   ├── ssdlc-template.adoc
│   │   └── Makefile
│   └── generic/
│       ├── generic-template.adoc
│       └── Makefile
│
├── build/                              # Build outputs (gitignored)
│   ├── icd-template.pdf
│   ├── icd-template.html
│   ├── ssdlc-template.pdf
│   ├── ssdlc-template.html
│   ├── generic-template.pdf
│   └── generic-template.html
│
├── Gemfile
├── Makefile (or Makefile.new)
└── README.md
```

## Benefits

- **Separation of Concerns**: Framework separate from templates
- **Reusability**: Shared scripts and themes across all templates
- **Scalability**: Easy to add new document types
- **Maintainability**: Changes to build system in one place
- **Organization**: Clear structure for finding components

## Cleanup (Optional)

After verifying the migration worked:

```bash
# Backup old directories
mkdir old_structure
mv scripts themes old_structure/
mv icd-template.adoc old_structure/

# OR remove them entirely (after confirming everything works!)
# rm -rf scripts themes
# rm icd-template.adoc
```

## Documentation

- **RESTRUCTURE_GUIDE.md** - Detailed migration guide
- **framework/themes/README.md** - Theme customization guide
- **AGENTS.md** - AI agent configuration (needs updating for new paths)

## Troubleshooting

### Scripts not executable
```bash
chmod +x framework/scripts/*.sh
```

### Theme files not found
Update theme paths in your .adoc files:
```asciidoc
:pdf-theme: ../../framework/themes/pdf/ecss-default-theme.yml
:stylesheet: ../../framework/themes/html/ecss-default.css
```

### Makefile.include not found
Verify the include path in template Makefiles:
```makefile
include ../../framework/Makefile.include
```

## Getting Help

If you encounter issues:
1. Check the RESTRUCTURE_GUIDE.md for detailed instructions
2. Verify all files were copied correctly
3. Check file permissions on scripts
4. Review the example Makefiles in template directories

## Next Steps

1. Update AGENTS.md with new paths and structure
2. Update CI/CD pipelines to use new paths
3. Update documentation references
4. Create additional templates as needed
5. Customize themes for your organization
