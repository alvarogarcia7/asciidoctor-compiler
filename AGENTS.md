# AGENTS.md

## Setup
```bash
bundle install --path vendor/bundle
```

## Commands
- **Build**: `make all` (or `make pdf` for PDF only, `make html` for HTML only)
- **Lint**: N/A
- **Test**: `make verify`
- **Dev Server**: `make watch` (requires inotifywait or entr)

## Tech Stack
- AsciiDoc document format
- Asciidoctor (Ruby gem) for HTML generation
- Asciidoctor PDF (Ruby gem) for PDF generation
- Bundler for Ruby dependency management

## Architecture
- Single AsciiDoc template file (`icd-template.adoc`) for Interface Control Document
- Makefile-based build system
- Outputs generated to `build/` directory

## Code Style
- Follow existing conventions in codebase
- Standard AsciiDoc formatting
