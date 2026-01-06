# Repository Restructuring Implementation

This directory contains everything needed to restructure the repository into a framework-based multi-template system.

## Quick Start

**For Unix/Linux/macOS:**
```bash
chmod +x restructure.sh
./restructure.sh
```

**For any platform (Python):**
```bash
python3 restructure.py
```

## What This Does

Creates a new repository structure with:
- **framework/** - Shared build infrastructure (scripts, themes, Docker config)
- **templates/** - Document templates (ICD, SSDLC, generic)
- **Makefile.new** - New root Makefile for building all templates

## Documentation Files

| File | Purpose |
|------|---------|
| **MIGRATION_README.md** | ⚡ START HERE - Quick start guide |
| **RESTRUCTURE_GUIDE.md** | 📚 Comprehensive migration guide |
| **RESTRUCTURE_CHECKLIST.md** | ☑️ Step-by-step checklist |
| **IMPLEMENTATION_SUMMARY.md** | 🔧 Technical implementation details |
| **FILES_CREATED.md** | 📋 Catalog of all files |
| **RESTRUCTURE_README.md** | 📖 This file |

## Migration Process

1. **Read** MIGRATION_README.md (5 minutes)
2. **Run** restructure.sh or restructure.py (30 seconds)
3. **Verify** using RESTRUCTURE_CHECKLIST.md (15 minutes)
4. **Build** and test each template (5 minutes)
5. **Update** documentation and CI/CD (varies)

## New Structure

```
.
├── framework/              # Shared infrastructure
│   ├── scripts/           # Build and verification scripts
│   ├── themes/            # PDF and HTML themes
│   ├── Dockerfile         # Docker build environment
│   ├── docker-compose.yml # Docker orchestration
│   └── Makefile.include   # Shared Makefile rules
│
├── templates/             # Document templates
│   ├── icd/              # Interface Control Documents
│   ├── ssdlc/            # Security Development Lifecycle
│   └── generic/          # Generic documents
│
└── build/                # Build outputs (all templates)
```

## Key Features

✅ **Separation of Concerns** - Framework code separate from templates
✅ **Reusability** - Shared scripts, themes, and build rules
✅ **Scalability** - Easy to add new document types
✅ **Maintainability** - Update build system in one place
✅ **Multiple Templates** - ICD, SSDLC, and generic templates included

## What Gets Created

### Framework Components
- Shared Makefile with common build rules
- Build and verification scripts
- PDF and HTML themes
- Docker configuration

### Templates
- **ICD** - Interface Control Document (existing template moved)
- **SSDLC** - Secure Software Development Lifecycle (new)
- **Generic** - Flexible generic document (new)

Each template includes:
- AsciiDoc template file
- Template-specific Makefile
- Access to shared framework

## Building After Migration

### Individual Template
```bash
cd templates/icd
make all        # Build PDF and HTML
make pdf        # PDF only
make html       # HTML only
make verify     # Run verification
make clean      # Clean outputs
```

### All Templates (after adopting Makefile.new)
```bash
make all        # Build everything
make icd        # Build ICD only
make ssdlc      # Build SSDLC only
make generic    # Build generic only
make clean      # Clean all outputs
```

## Safety Features

✅ **Non-destructive** - Original files remain untouched
✅ **Easy rollback** - Just delete new directories
✅ **Incremental adoption** - Test before committing
✅ **Preserves history** - Git history intact

## Requirements

- Unix/Linux/macOS with bash OR Python 3.6+
- Existing asciidoctor installation
- Bundler (if using Gemfile)
- Git (optional, for version control)

## Troubleshooting

### Scripts Not Executable
```bash
chmod +x restructure.sh
chmod +x framework/scripts/*.sh
```

### Build Errors
- Check bundler: `bundle install`
- Verify asciidoctor: `bundle exec asciidoctor --version`
- Check Ruby version: `ruby --version`

### Theme Not Found
Update paths in .adoc files:
```asciidoc
:pdf-theme: ../../framework/themes/pdf/ecss-default-theme.yml
:stylesheet: ../../framework/themes/html/ecss-default.css
```

## Success Criteria

Migration is successful when:
- [ ] Framework directory created
- [ ] Templates directory created
- [ ] All three templates build successfully
- [ ] PDFs and HTML files generated
- [ ] Themes apply correctly
- [ ] No build errors

## Getting Help

1. **Quick help:** Check MIGRATION_README.md
2. **Detailed help:** Read RESTRUCTURE_GUIDE.md
3. **Technical details:** See IMPLEMENTATION_SUMMARY.md
4. **Step-by-step:** Follow RESTRUCTURE_CHECKLIST.md
5. **File reference:** Check FILES_CREATED.md

## What's Next?

After successful migration:

1. **Test thoroughly** - Build all templates, check outputs
2. **Update docs** - AGENTS.md, README.md, CI/CD configs
3. **Adopt new Makefile** - Rename Makefile.new to Makefile
4. **Clean up** - Archive or remove old directories
5. **Commit changes** - Git commit the new structure
6. **Notify team** - Inform team of new structure

## Benefits

| Before | After |
|--------|-------|
| Single template | Multiple templates |
| Duplicated build code | Shared framework |
| Hard to add templates | Easy template creation |
| Scripts in root | Organized in framework/ |
| Themes scattered | Centralized themes |

## Support

For issues:
1. Review troubleshooting sections in documentation
2. Check that all steps completed successfully
3. Verify file permissions (especially scripts)
4. Ensure paths are correct in .adoc files

## Contributing

To add new templates:
1. Create directory in templates/
2. Create .adoc file
3. Create Makefile that includes framework/Makefile.include
4. Add target to root Makefile (optional)

## Version History

- **v1.0** - Initial implementation
  - Framework structure
  - Three templates (ICD, SSDLC, generic)
  - Migration scripts (shell and Python)
  - Comprehensive documentation

## License

Same as the repository this is part of.

## Credits

Created as part of repository restructuring to support multiple document types with shared build infrastructure.

---

**Ready to migrate?** Start with [MIGRATION_README.md](MIGRATION_README.md)!
