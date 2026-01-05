# AGENTS.md

## Setup
```bash
# Option 1: Install asciidoctor via Homebrew (recommended for macOS)
brew install asciidoctor

# Option 2: Install via RubyGems
gem install asciidoctor asciidoctor-pdf

# Option 3: Install locally via Bundler (project-local dependencies)
bundle config set --local path 'vendor/bundle'
bundle install
# Then use: bundle exec make <target>

# Verify setup
./setup.sh
```

## Commands
- **Build**: `make all` (builds both PDF and HTML) or `make pdf` / `make html`
- **Lint**: N/A (use `make verify` to check AsciiDoc syntax)
- **Test**: `make verify` (validates AsciiDoc syntax)
- **Dev Server**: `make watch` (auto-rebuilds on file changes, requires inotifywait or entr)

## Tech Stack
- **AsciiDoc**: Documentation markup language
- **asciidoctor**: Ruby-based AsciiDoc processor (HTML generation)
- **asciidoctor-pdf**: PDF generation from AsciiDoc
- **Make**: Build automation
- **Bundler**: Ruby dependency management (optional)

## Architecture
- Single-file AsciiDoc source (`icd-template.adoc`)
- Makefile-based build system
- Output generated to `build/` directory
- Supports PDF and HTML output formats

## Code Style
- AsciiDoc markup follows standard AsciiDoc conventions
- Use 2-space indentation for nested structures
- Keep lines reasonably short for readability
- Use semantic section markers (=, ==, ===, etc.)
