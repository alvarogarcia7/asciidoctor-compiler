# GitLab CI Templates for AsciiDoc Documentation

This directory contains reusable GitLab CI/CD pipeline templates for building AsciiDoc documentation projects.

## Available Templates

### 1. `.gitlab-ci-icd.yml` - Interface Control Document Template
Specialized template for ICD (Interface Control Document) projects with comprehensive verification and build stages.

**Features:**
- Syntax and structure verification
- PDF and HTML generation
- Matrix build strategy for multiple document configurations
- Branch-specific artifact expiration
- Manual deployment controls

**Usage:**
```yaml
include:
  - local: 'ci-templates/.gitlab-ci-icd.yml'

variables:
  DOCUMENT_FILE: "your-icd.adoc"
  OUTPUT_NAME: "your-icd"
  ARTIFACT_EXPIRATION: "7 days"
```

### 2. `.gitlab-ci-ssdlc.yml` - Secure Software Development Lifecycle Template
Extended template with security scanning and compliance validation for SSDLC documentation.

**Features:**
- All features from ICD template
- Security scanning for sensitive data
- Secrets detection
- SSDLC compliance validation
- Requirements traceability checking
- Compliance reporting
- Audit trail for deployments

**Usage:**
```yaml
include:
  - local: 'ci-templates/.gitlab-ci-ssdlc.yml'

variables:
  DOCUMENT_FILE: "your-ssdlc-doc.adoc"
  OUTPUT_NAME: "your-ssdlc-doc"
  SECURITY_SCAN_ENABLED: "true"
  COMPLIANCE_CHECK_ENABLED: "true"
```

### 3. `.gitlab-ci-generic.yml` - Generic AsciiDoc Template
Flexible, general-purpose template for any AsciiDoc documentation project.

**Features:**
- Modular stages (verify, build, deploy)
- Multiple output formats (PDF, HTML, DocBook)
- Matrix builds with theme variations
- Docker-based build option
- GitLab Pages deployment
- Flexible artifact management
- Branch-specific expiration policies

**Usage:**
```yaml
include:
  - local: 'ci-templates/.gitlab-ci-generic.yml'

variables:
  DOCUMENT_FILE: "your-document.adoc"
  OUTPUT_NAME: "your-document"
  ENABLE_VERIFY: "true"
  ENABLE_BUILD: "true"
  ENABLE_DEPLOY: "false"
```

## Template Features

### Parameterized Variables

All templates support the following configurable variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `DOCUMENT_FILE` | `icd-template.adoc` | Source AsciiDoc file to build |
| `OUTPUT_NAME` | `icd-template` or `document` | Name for generated outputs |
| `BUILD_DIR` | `build` | Directory for build artifacts |
| `ARTIFACT_EXPIRATION` | `7 days` | Default artifact retention period |

### YAML Anchors

Templates use YAML anchors for code reuse:

- `.ruby_setup` - Ruby and Bundler environment setup
- `.asciidoctor_setup` - AsciiDoctor Docker image setup
- `.artifact_policy` - Standard artifact configuration
- `.branch_rules` - Rules for all branches
- `.master_rules` - Rules for master/main branches only

### Matrix Strategy

All templates support GitLab CI matrix builds for generating multiple document variants:

```yaml
build:matrix:
  parallel:
    matrix:
      - DOCUMENT_FILE: ["doc1.adoc", "doc2.adoc"]
        OUTPUT_NAME: ["doc1", "doc2"]
        FORMAT: ["pdf", "html"]
```

### Branch-Specific Artifact Expiration

Templates implement intelligent artifact retention:

- **Feature branches**: 3 days (short expiration)
- **Master/main branch**: 30 days (long expiration)
- **Tags/releases**: Never expire (permanent)
- **Custom**: Configurable via `ARTIFACT_EXPIRATION` variable

## Pipeline Stages

### Verify Stage
- Syntax validation
- Structure validation
- Link checking
- Cross-reference validation

### Build Stage
- PDF generation
- HTML generation
- DocBook generation (generic template)
- Matrix builds with multiple configurations

### Security Stage (SSDLC only)
- Sensitive data scanning
- Secrets detection
- Security issue reporting

### Compliance Stage (SSDLC only)
- SSDLC compliance validation
- Requirements traceability
- Compliance reporting

### Deploy Stage
- Artifact deployment
- GitLab Pages publishing (generic template)
- Long-term archival
- Release packaging

## Advanced Usage

### Extending Templates

You can extend templates with additional jobs:

```yaml
include:
  - local: 'ci-templates/.gitlab-ci-icd.yml'

# Add custom job
custom:validation:
  stage: verify
  script:
    - echo "Running custom validation"
  needs:
    - verify:syntax
```

### Overriding Jobs

Override specific jobs from the template:

```yaml
include:
  - local: 'ci-templates/.gitlab-ci-icd.yml'

# Override build:pdf with custom configuration
build:pdf:
  variables:
    DOCUMENT_FILE: "custom.adoc"
  script:
    - echo "Custom PDF build"
    - asciidoctor-pdf ${DOCUMENT_FILE} -a custom-attr=value
```

### Multiple Document Pipeline

Build multiple documents in a single pipeline:

```yaml
include:
  - local: 'ci-templates/.gitlab-ci-generic.yml'

build:doc1:
  extends: build:pdf
  variables:
    DOCUMENT_FILE: "doc1.adoc"
    OUTPUT_NAME: "doc1"

build:doc2:
  extends: build:pdf
  variables:
    DOCUMENT_FILE: "doc2.adoc"
    OUTPUT_NAME: "doc2"
```

## Environment Requirements

### Ruby Jobs
- Ruby 3.2 image
- Bundler for dependency management
- Local gem installation in `vendor/bundle`

### AsciiDoctor Jobs
- `asciidoctor/docker-asciidoctor:latest` image
- Includes asciidoctor, asciidoctor-pdf, asciidoctor-diagram
- PlantUML and Graphviz support

### Security Jobs (SSDLC)
- Alpine Linux image
- Git and Bash tools
- Grep-based pattern scanning

## Artifact Management

### Artifact Structure
```
build/
├── <output-name>.pdf
├── <output-name>.html
├── logs/
│   ├── pdf-build.log
│   └── html-build.log
└── reports/
    ├── compliance-issues.log
    └── security-scan.log
```

### Artifact Naming
Artifacts are named with context:
```
<output-name>-<branch>-<commit-sha>
```

Example: `icd-template-master-a1b2c3d4`

## Best Practices

1. **Set appropriate expiration times** - Use longer retention for important branches
2. **Use matrix builds judiciously** - They multiply pipeline duration
3. **Enable caching** - Cache gems with `vendor/bundle` for faster builds
4. **Use manual triggers** - For expensive or optional jobs (deploy, matrix builds)
5. **Review security scans** - Check reports in SSDLC template regularly
6. **Customize deployment** - Adapt deploy jobs to your infrastructure

## Troubleshooting

### Build Failures
- Check `build/logs/` for detailed error messages
- Verify AsciiDoc syntax with `bundle exec make verify`
- Ensure all required gems are in Gemfile

### Artifact Issues
- Confirm `BUILD_DIR` matches your build output location
- Check artifact paths in job configuration
- Verify expiration settings don't delete needed artifacts

### Permission Errors
- Ensure scripts have execute permissions (`chmod +x`)
- Check Docker service availability for docker builds
- Verify GitLab Runner has necessary permissions

## Support

For issues or questions:
1. Check build logs in `build/logs/`
2. Review pipeline job output in GitLab UI
3. Verify template variable configuration
4. Consult AsciiDoctor documentation for syntax issues
