# Multi-Document Project - Documentation Index

This index helps you navigate the multi-document project documentation and implementation.

## Quick Links

### For First-Time Users
1. **Start Here:** [MULTI_DOC_QUICK_START.md](MULTI_DOC_QUICK_START.md) - 5-minute quick start
2. **Setup:** Run `./setup-multi-doc-example.sh` to create the example
3. **Explore:** Check `examples/multi-doc-project/` after setup

### For Detailed Learning
1. **Complete Guide:** [MULTI_DOC_PROJECT_GUIDE.md](MULTI_DOC_PROJECT_GUIDE.md) - Comprehensive documentation
2. **Example Project:** `examples/multi-doc-project/README.md` (created by setup script)
3. **Implementation:** [MULTI_DOC_IMPLEMENTATION_SUMMARY.md](MULTI_DOC_IMPLEMENTATION_SUMMARY.md) - What was built

### For Reference
1. **Quick Reference:** [MULTI_DOC_QUICK_START.md](MULTI_DOC_QUICK_START.md) - Commands and examples
2. **Example README:** [MULTI_DOC_EXAMPLE_README.md](MULTI_DOC_EXAMPLE_README.md) - Pattern overview

## Documentation Files

### Setup and Getting Started

**setup-multi-doc-example.sh** (24KB, 1039 lines)
- Automated setup script
- Creates framework and example project
- Generates all necessary files
- **Action:** Run this first: `./setup-multi-doc-example.sh`

### User Documentation

**MULTI_DOC_QUICK_START.md** (6KB, 249 lines)
- Quick reference card
- Common commands
- Fast setup instructions
- Troubleshooting basics
- **Best for:** Quick reference, daily use

**MULTI_DOC_EXAMPLE_README.md** (8KB, 287 lines)
- Pattern overview
- Usage examples
- Extension patterns
- Best practices
- **Best for:** Understanding the pattern

**MULTI_DOC_PROJECT_GUIDE.md** (19KB, 762 lines)
- Comprehensive documentation
- Detailed explanations
- Complete usage guide
- Advanced topics
- Troubleshooting
- **Best for:** In-depth learning

### Technical Documentation

**MULTI_DOC_IMPLEMENTATION_SUMMARY.md** (14KB, 597 lines)
- Implementation details
- What was created
- Technical highlights
- Testing procedures
- Extension examples
- **Best for:** Understanding implementation

## Project Structure

```
.
├── setup-multi-doc-example.sh     # Run this to create example
├── MULTI_DOC_INDEX.md             # This file - navigation
├── MULTI_DOC_QUICK_START.md       # Quick reference
├── MULTI_DOC_EXAMPLE_README.md    # Pattern overview
├── MULTI_DOC_PROJECT_GUIDE.md     # Complete guide
├── MULTI_DOC_IMPLEMENTATION_SUMMARY.md  # Implementation details
│
├── framework/                      # Created by setup script
│   └── Makefile.include           # Shared build rules
│
└── examples/                       # Created by setup script
    └── multi-doc-project/         # Example project
        ├── Makefile               # Project configuration
        ├── .gitlab-ci.yml        # CI/CD with matrix
        ├── README.md              # Project docs
        ├── system-icd.adoc        # Example doc 1
        ├── component-icd.adoc     # Example doc 2
        ├── ssdlc.adoc             # Example doc 3
        └── build/                 # Generated outputs
```

## Getting Started (Step by Step)

### Step 1: Setup

```bash
# Run the setup script
./setup-multi-doc-example.sh

# This creates:
# - framework/Makefile.include
# - examples/multi-doc-project/ (with all files)
```

### Step 2: Explore

```bash
# Navigate to example
cd examples/multi-doc-project

# Read the project README
cat README.md

# View available commands
make help
```

### Step 3: Build

```bash
# Build all documents
make all

# Check outputs
ls -lh build/

# Expected outputs:
# - system-icd.pdf & .html
# - component-icd.pdf & .html
# - ssdlc.pdf & .html
```

### Step 4: Learn

```bash
# Review documentation
cd ../..
cat MULTI_DOC_QUICK_START.md      # Quick reference
cat MULTI_DOC_PROJECT_GUIDE.md    # Complete guide
```

### Step 5: Adapt

```bash
# Create your own project
cp -r examples/multi-doc-project examples/my-project
cd examples/my-project

# Customize
vim Makefile                      # Update DOCUMENTS
vim .gitlab-ci.yml               # Update matrix
# Create your .adoc files

# Build
make all
```

## Documentation by Use Case

### I Want To...

**...Get started quickly**
→ Read: `MULTI_DOC_QUICK_START.md`
→ Run: `./setup-multi-doc-example.sh`
→ Build: `cd examples/multi-doc-project && make all`

**...Understand the pattern**
→ Read: `MULTI_DOC_EXAMPLE_README.md`
→ Review: `examples/multi-doc-project/README.md` (after setup)
→ Examine: `examples/multi-doc-project/Makefile`

**...Learn all details**
→ Read: `MULTI_DOC_PROJECT_GUIDE.md`
→ Study: Setup script contents
→ Explore: Framework Makefile

**...Understand implementation**
→ Read: `MULTI_DOC_IMPLEMENTATION_SUMMARY.md`
→ Review: All created files
→ Test: Build the examples

**...Create my own project**
→ Read: "Extending the Pattern" in `MULTI_DOC_PROJECT_GUIDE.md`
→ Copy: `examples/multi-doc-project/` structure
→ Customize: Makefile and .gitlab-ci.yml

**...Troubleshoot issues**
→ Check: "Troubleshooting" in `MULTI_DOC_PROJECT_GUIDE.md`
→ Review: "Troubleshooting" in `MULTI_DOC_QUICK_START.md`
→ Verify: Run `make verify`

## Key Concepts

### Shared Framework
- Common build rules in `framework/Makefile.include`
- Reusable across multiple projects
- Single source of truth for build logic
- Update once, benefit everywhere

### Multi-Document Project
- Multiple `.adoc` files in one directory
- Single Makefile lists all documents
- One build command for all
- Shared assets and configuration

### GitLab CI/CD Matrix
- Parallel execution of document builds
- Faster pipeline (3 jobs in parallel vs sequential)
- Individual artifacts per document
- Scales well with more documents

### Pattern Rules
- Makefile patterns: `%.pdf: %.adoc`
- Automatically applies to all documents
- No need to define rules per document
- DRY (Don't Repeat Yourself) principle

## Common Commands

```bash
# Setup
./setup-multi-doc-example.sh       # Create example project

# Navigation
cd examples/multi-doc-project      # Enter project

# Building
make all                           # Build everything
make pdf                           # Build all PDFs
make html                          # Build all HTMLs
make system                        # Build system-icd.*
make verify                        # Check syntax
make clean                         # Remove build outputs
make watch                         # Auto-rebuild on changes
make help                          # Show help

# Development
vim system-icd.adoc                # Edit document
make system                        # Build specific doc
make all                           # Build all

# CI/CD (automatic on git push)
git add .
git commit -m "Update docs"
git push                           # Triggers GitLab CI/CD
```

## Features at a Glance

| Feature | Description | Benefit |
|---------|-------------|---------|
| **Shared Framework** | Common build rules | Consistency, maintainability |
| **Multi-Document** | Multiple docs in one project | Coordinated versioning |
| **Matrix CI/CD** | Parallel builds | Faster pipelines |
| **Pattern Rules** | Automatic build rules | Less configuration |
| **Watch Mode** | Auto-rebuild | Rapid iteration |
| **Verification** | Syntax checking | Early error detection |
| **Artifacts** | Per-document or combined | Flexible downloads |
| **Documentation** | Comprehensive guides | Easy learning |

## Troubleshooting Quick Reference

| Problem | Solution |
|---------|----------|
| Framework not found | Run `./setup-multi-doc-example.sh` |
| Command not found | `bundle install` or install asciidoctor |
| Build fails | `make verify` to check syntax |
| Watch not working | Install `inotifywait` or `entr` |
| Matrix not parallel | Requires GitLab 13.3+ |
| Artifacts missing | Check paths in `.gitlab-ci.yml` |

## Additional Resources

### AsciiDoc
- [AsciiDoctor Documentation](https://asciidoctor.org/docs/)
- [AsciiDoc Syntax Quick Reference](https://docs.asciidoctor.org/asciidoc/latest/syntax-quick-reference/)
- [PDF Theming Guide](https://docs.asciidoctor.org/pdf-converter/latest/theme/)

### GitLab CI/CD
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [Matrix Strategy](https://docs.gitlab.com/ee/ci/yaml/#parallelmatrix)
- [Artifacts](https://docs.gitlab.com/ee/ci/yaml/#artifacts)

### Make
- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Make Tutorial](https://makefiletutorial.com/)

### Project Documentation
- Main README: `README.md`
- Template README: `TEMPLATE-README.md`
- Project README: `examples/multi-doc-project/README.md` (after setup)

## Support

### Documentation
1. Check this index for navigation
2. Read relevant documentation file
3. Review example project
4. Check troubleshooting sections

### Common Questions

**Q: Do I need to run setup every time?**
A: No, setup creates the files once. They persist in your repository.

**Q: Can I modify the example project?**
A: Yes! It's meant to be customized for your needs.

**Q: What if I only have 2 documents?**
A: Pattern works great for 2+ documents. Still beneficial for consistency.

**Q: Can I use GitHub Actions instead of GitLab?**
A: Yes, the pattern works. You'd need to adapt `.gitlab-ci.yml` to GitHub Actions syntax.

**Q: Where are the generated PDFs?**
A: In `build/` directory (created on first build, gitignored).

**Q: Can I use different themes per document?**
A: Yes! Add document-specific rules in project Makefile.

## Next Steps

1. ✅ **Setup:** Run `./setup-multi-doc-example.sh`
2. ✅ **Learn:** Read `MULTI_DOC_QUICK_START.md`
3. ✅ **Build:** `cd examples/multi-doc-project && make all`
4. ✅ **Explore:** Review generated PDFs and source files
5. ✅ **Adapt:** Create your own project following the pattern

## Summary

The multi-document project pattern provides a complete solution for managing multiple related documents with:

✓ Shared build infrastructure (framework)
✓ Parallel CI/CD builds (matrix strategy)
✓ Consistent tooling (same commands everywhere)
✓ Comprehensive documentation (4 levels)
✓ Working examples (3 example documents)
✓ Easy extension (add documents easily)

**Start now:** `./setup-multi-doc-example.sh`

---

**Quick Reference:** `MULTI_DOC_QUICK_START.md`  
**Complete Guide:** `MULTI_DOC_PROJECT_GUIDE.md`  
**Implementation:** `MULTI_DOC_IMPLEMENTATION_SUMMARY.md`
