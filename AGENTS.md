# AI Agent Configuration

## Environment

- **Docker**: Not running in Docker container
- **Bundler**: Available (version 1.17.2) with local dependencies installed in `vendor/bundle`
- **Ruby Dependencies**: Managed via Bundler with local installation

## Setup Instructions

### Using Bundler (Recommended for this project)

Since this project has Bundler configured with local dependencies:

```bash
# Dependencies are already installed in vendor/bundle
# Use bundle exec prefix for all commands:
bundle exec make all
bundle exec make verify
bundle exec asciidoctor icd-template.adoc
```

### Alternative Setup Options

#### Option 1: Homebrew (macOS)
```bash
brew install asciidoctor
```

#### Option 2: RubyGems (System-wide)
```bash
gem install asciidoctor asciidoctor-pdf
```

#### Option 3: Bundler (Fresh Installation)
```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

## Commands

### Build Commands
- `bundle exec make all` - Build both PDF and HTML (default)
- `bundle exec make pdf` - Build PDF only
- `bundle exec make html` - Build HTML only
- `make clean` - Remove build artifacts

### Validation Commands
- `bundle exec make verify` - Run AsciiDoc syntax verification
- `./scripts/verify.sh` - Comprehensive document structure validation

### Development Commands
- `bundle exec make watch` - Auto-rebuild on file changes (requires inotifywait or entr)
- `bundle exec make help` - Show available commands
- `./setup.sh` - Verify installation

## Tech Stack

- **AsciiDoc**: Documentation markup language
- **asciidoctor**: Ruby-based AsciiDoc processor for HTML generation
- **asciidoctor-pdf**: PDF generation from AsciiDoc
- **Make**: Build automation
- **Bundler**: Ruby dependency management (configured for local installation)
- **Ruby**: Runtime environment for asciidoctor tools

## Project Architecture

```
.
├── icd-template.adoc       # Main AsciiDoc source file
├── Makefile                # Build automation
├── Gemfile                 # Ruby gem dependencies
├── setup.sh                # Setup verification script
├── scripts/
│   ├── verify.sh          # Comprehensive validation script
│   └── compile.sh         # Advanced compilation script
├── build/                  # Generated outputs (gitignored)
│   ├── icd-template.pdf
│   ├── icd-template.html
│   └── logs/              # Compilation logs
└── vendor/bundle/         # Local gem installation (gitignored)
```

## Code Style Guidelines

### AsciiDoc Conventions
- Use semantic section markers: `=` (title), `==` (level 1), `===` (level 2), etc.
- Maintain consistent heading hierarchy (don't skip levels)
- Use 2-space indentation for nested structures
- Keep lines reasonably short for readability (<120 characters preferred)
- Use anchors for cross-references: `[[anchor-name]]`
- Reference anchors with: `<<anchor-name>>`

### Document Structure
- Always include required ECSS sections:
  - Revision History
  - Applicable Documents
  - Terms, Definitions and Abbreviations
- Follow standard ICD template structure
- Validate cross-references before committing

## Automation Tools

### Makefile Build System
- Primary automation tool for compilation
- Targets: `all`, `pdf`, `html`, `verify`, `clean`, `watch`, `help`
- Automatically creates `build/` directory
- Uses `bundle exec` internally when needed

### Verification Scripts
- **`scripts/verify.sh`**: Validates document structure, ECSS compliance, cross-references, table formatting, and more
- **`make verify`**: Quick syntax validation wrapper

### Compilation Scripts
- **`scripts/compile.sh`**: Advanced compilation with custom themes, attributes, and logging

## Dependencies

### Ruby Gems (from Gemfile)
```ruby
gem 'asciidoctor', '~> 2.0'
gem 'asciidoctor-pdf', '~> 2.3'
```

### System Requirements
- Ruby (for running asciidoctor)
- Make (for build automation)
- Optional: `inotifywait` or `entr` (for file watching)

## CI/CD Considerations

This project is ready for CI/CD integration. Example GitHub Actions workflow:

```yaml
name: Build and Verify
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.0'
          bundler-cache: true
      - name: Verify document
        run: bundle exec make verify
      - name: Build outputs
        run: bundle exec make all
      - name: Upload artifacts
        uses: actions/upload-artifact@v2
        with:
          name: icd-outputs
          path: build/
```

## Troubleshooting

### Command not found errors
- Ensure you use `bundle exec` prefix for all make and asciidoctor commands
- Verify bundler dependencies: `bundle check` or `bundle install`

### Build failures
- Check logs in `build/logs/` directory
- Run `bundle exec make verify` to check syntax
- Ensure Ruby and bundler are properly installed

### Permission issues
- Bundler may use temporary home directory if user home is not writable
- This is normal and doesn't affect functionality
