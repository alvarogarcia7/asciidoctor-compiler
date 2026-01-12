# Repository Restructuring Checklist

Use this checklist to guide you through the repository restructuring process.

## Pre-Migration

- [ ] Read RESTRUCTURE_GUIDE.md
- [ ] Read MIGRATION_README.md  
- [ ] Review IMPLEMENTATION_SUMMARY.md
- [ ] Backup your repository (git commit or copy)
- [ ] Verify bundler and asciidoctor are working: `bundle exec asciidoctor --version`
- [ ] Check current build works: `make all`

## Migration

### Choose Your Migration Method

#### Option A: Shell Script (Recommended for Unix/Linux/macOS)
- [ ] Make script executable: `chmod +x restructure.sh`
- [ ] Run the script: `./restructure.sh`
- [ ] Review output for errors

#### Option B: Python Script (Cross-platform)
- [ ] Run the script: `python3 restructure.py`
- [ ] Review output for errors

## Post-Migration Verification

### Directory Structure
- [ ] Verify `framework/` directory exists
- [ ] Verify `framework/scripts/` contains compile.sh and verify.sh
- [ ] Verify `framework/themes/html/` contains CSS files
- [ ] Verify `framework/themes/pdf/` contains YAML files
- [ ] Verify `framework/Makefile.include` exists
- [ ] Verify `framework/Dockerfile` exists
- [ ] Verify `framework/docker-compose.yml` exists
- [ ] Verify `templates/icd/` directory exists
- [ ] Verify `templates/icd/icd-template.adoc` exists
- [ ] Verify `templates/icd/Makefile` exists
- [ ] Verify `templates/ssdlc/` directory exists
- [ ] Verify `templates/ssdlc/ssdlc-template.adoc` exists
- [ ] Verify `templates/ssdlc/Makefile` exists
- [ ] Verify `templates/generic/` directory exists
- [ ] Verify `templates/generic/generic-template.adoc` exists
- [ ] Verify `templates/generic/Makefile` exists
- [ ] Verify `Makefile.new` exists at root

### File Permissions
- [ ] Check scripts are executable: `ls -l framework/scripts/*.sh`
- [ ] If not, fix: `chmod +x framework/scripts/*.sh`

### Build Testing - ICD Template
- [ ] Navigate to ICD template: `cd templates/icd`
- [ ] Build PDF and HTML: `make all`
- [ ] Check for errors in output
- [ ] Verify `../../build/icd-template.pdf` exists
- [ ] Verify `../../build/icd-template.html` exists
- [ ] Open PDF and verify it looks correct
- [ ] Open HTML and verify it looks correct
- [ ] Return to root: `cd ../..`

### Build Testing - SSDLC Template
- [ ] Navigate to SSDLC template: `cd templates/ssdlc`
- [ ] Build PDF and HTML: `make all`
- [ ] Check for errors in output
- [ ] Verify `../../build/ssdlc-template.pdf` exists
- [ ] Verify `../../build/ssdlc-template.html` exists
- [ ] Open PDF and verify it looks correct
- [ ] Open HTML and verify it looks correct
- [ ] Return to root: `cd ../..`

### Build Testing - Generic Template
- [ ] Navigate to generic template: `cd templates/generic`
- [ ] Build PDF and HTML: `make all`
- [ ] Check for errors in output
- [ ] Verify `../../build/generic-template.pdf` exists
- [ ] Verify `../../build/generic-template.html` exists
- [ ] Open PDF and verify it looks correct
- [ ] Open HTML and verify it looks correct
- [ ] Return to root: `cd ../..`

### Theme Verification
- [ ] Check ICD PDF uses correct theme (blue headers, professional style)
- [ ] Check SSDLC PDF uses correct theme
- [ ] Check generic PDF uses correct theme
- [ ] Check ICD HTML uses correct stylesheet
- [ ] Check SSDLC HTML uses correct stylesheet
- [ ] Check generic HTML uses correct stylesheet

### Verification Scripts
- [ ] Test verification from ICD: `cd templates/icd && make verify`
- [ ] Check for no critical errors
- [ ] Return to root: `cd ../..`

## Root Makefile Update (Optional but Recommended)

- [ ] Review new Makefile: `cat Makefile.new`
- [ ] Backup old Makefile: `cp Makefile Makefile.old`
- [ ] Replace with new: `mv Makefile.new Makefile`
- [ ] Test root builds: `make icd`
- [ ] Test root builds: `make ssdlc`
- [ ] Test root builds: `make generic`
- [ ] Test build all: `make all`
- [ ] Test clean: `make clean`
- [ ] Verify build directory is removed
- [ ] Test help: `make help`

## Documentation Updates

- [ ] Update AGENTS.md with new paths and commands
- [ ] Update README.md to reference new structure
- [ ] Update any custom documentation with new paths
- [ ] Update CI/CD configuration files (if any) with new paths
- [ ] Update .gitignore if needed (framework/themes/, etc. should not be in .gitignore)

## Cleanup (Optional - Only After Everything Works!)

### Remove Temporary Files
- [ ] Remove create_dirs.sh if it exists: `rm create_dirs.sh`

### Archive Old Structure (Recommended)
- [ ] Create archive directory: `mkdir old_structure`
- [ ] Move old scripts: `mv scripts old_structure/` (only if `framework/scripts/` works)
- [ ] Move old themes: `mv themes old_structure/` (only if `framework/themes/` works)
- [ ] Move old ICD template: `mv icd-template.adoc old_structure/` (only if `templates/icd/icd-template.adoc` works)
- [ ] Move old Dockerfile: `mv Dockerfile old_structure/` (only if `framework/Dockerfile` works)
- [ ] Move old docker-compose: `mv docker-compose.yml old_structure/` (only if `framework/docker-compose.yml` works)
- [ ] Commit changes: `git add -A && git commit -m "Archive old structure after successful migration"`

### OR Delete Old Structure (Use with Caution!)
Only if you're absolutely sure everything works:
- [ ] Delete old scripts: `rm -rf scripts`
- [ ] Delete old themes: `rm -rf themes`
- [ ] Delete old ICD template: `rm icd-template.adoc`
- [ ] Delete old Dockerfile: `rm Dockerfile`
- [ ] Delete old docker-compose: `rm docker-compose.yml`
- [ ] Delete old Makefile: `rm Makefile.old`
- [ ] Keep restructure scripts for reference or remove: `rm restructure.sh restructure.py`
- [ ] Commit changes: `git add -A && git commit -m "Remove old structure after migration"`

## Git Commit Strategy

### After Migration (Before Cleanup)
```bash
git add framework/
git add templates/
git add Makefile.new
git add RESTRUCTURE_GUIDE.md MIGRATION_README.md IMPLEMENTATION_SUMMARY.md RESTRUCTURE_CHECKLIST.md
git add restructure.sh restructure.py
git commit -m "Add framework and templates structure with migration scripts"
```

### After Root Makefile Update
```bash
git add Makefile Makefile.old
git commit -m "Update root Makefile for new structure"
```

### After Cleanup
```bash
git add -A
git commit -m "Complete migration - archive/remove old structure"
```

## Docker Testing (Optional)

- [ ] Navigate to framework: `cd framework`
- [ ] Build Docker image: `docker build -t asciidoctor-docs:latest .`
- [ ] Or use compose: `docker-compose build`
- [ ] Test running container: `docker-compose run --rm asciidoctor bash`
- [ ] Inside container, test building: `cd /documents/templates/icd && make all`
- [ ] Exit container
- [ ] Return to root: `cd ..`

## CI/CD Updates

If you have CI/CD pipelines:
- [ ] Update build script paths
- [ ] Update output paths  
- [ ] Update Docker configuration references
- [ ] Update artifact collection paths
- [ ] Test CI/CD pipeline
- [ ] Update deployment scripts if needed

## Final Verification

- [ ] All templates build successfully
- [ ] All outputs look correct
- [ ] Root Makefile works (if updated)
- [ ] Documentation is updated
- [ ] Git commits are clean
- [ ] Team is informed of new structure
- [ ] Old structure archived or removed

## Troubleshooting Reference

If you encounter issues, refer to:
- RESTRUCTURE_GUIDE.md - Section: "Troubleshooting"
- MIGRATION_README.md - Section: "Troubleshooting"
- IMPLEMENTATION_SUMMARY.md - Section: "Support & Troubleshooting"

## Success!

Once all items are checked:
- [ ] Repository is fully migrated
- [ ] All templates work correctly
- [ ] Documentation is updated
- [ ] Team is notified

**Congratulations!** Your repository is now using the framework-based multi-template structure.

## Notes

Use this space for migration-specific notes:

---

**Migration Date:** _________________

**Performed By:** _________________

**Issues Encountered:** _________________

**Resolution:** _________________

---
