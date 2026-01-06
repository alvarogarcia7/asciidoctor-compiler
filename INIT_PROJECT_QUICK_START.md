# init-project.sh Quick Start

Quick reference for using the project initialization script.

## One-Line Start

```bash
./init-project.sh
```

Follow the prompts to create your new documentation project.

## Project Types

| Type | Number | Use For |
|------|--------|---------|
| ICD | 1 | Interface Control Documents, protocol specs, API docs |
| SSDLC | 2 | Security documentation, threat models, compliance |
| Generic | 3 | User guides, design docs, any technical documentation |

## Common Workflows

### Quick ICD Project

```bash
./init-project.sh
# 1 (ICD)
# my-interface-spec
# [fill in other prompts]
# Y (confirm)
```

### Quick SSDLC Project

```bash
./init-project.sh
# 2 (SSDLC)
# security-plan
# [fill in other prompts]
# Y (confirm)
```

### Quick Generic Project

```bash
./init-project.sh
# 3 (Generic)
# user-guide
# [fill in other prompts]
# Y (confirm)
```

## After Initialization

```bash
# Build your document
make all         # Build PDF and HTML
make pdf         # Build PDF only
make html        # Build HTML only

# Verify syntax
make verify

# Watch for changes
make watch

# Clean up
make clean
```

## Output Files

After running the script, you'll have:

```
your-document.adoc    # Your customized document
Makefile              # Build automation
.gitlab-ci.yml        # CI/CD configuration
build/                # Build output directory
images/               # Image resources
scripts/              # Additional scripts
```

## Default Values

Press Enter to accept defaults (shown in brackets):

| Field | Default Value |
|-------|---------------|
| Document name | `my-document` |
| Author | Current username |
| Organization | `My Organization` |
| Revision | `0.1` |
| Date | Current date |
| Classification | `UNCLASSIFIED` |
| Status | `Draft` |

## Quick Tips

✅ **DO:**
- Use descriptive document names (e.g., `system-interface-spec`)
- Follow consistent ID patterns (e.g., `SYS-ICD-001`)
- Review the summary before confirming
- Test build immediately after initialization

❌ **DON'T:**
- Use spaces in document names
- Skip metadata fields (defaults are provided)
- Forget to commit to version control
- Modify template files directly

## Need Help?

- Full guide: `INIT_PROJECT_GUIDE.md`
- Template details: `templates/README.md`
- Build instructions: `AGENTS.md`
- Repository overview: `README.md`

## Common Issues

**Script not executable?**
```bash
chmod +x init-project.sh
```

**Templates missing?**
```bash
ls templates/  # Should show icd, ssdlc, generic templates
```

**File already exists?**
- Choose 'y' to overwrite
- Choose 'n' to cancel
- Or use a different document name

## Version

Script version: 1.0.0

Last updated: 2024-01-06
