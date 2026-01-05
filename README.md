# ICD Template - AsciiDoc

This repository contains an Interface Control Document (ICD) template written in AsciiDoc format.

## Prerequisites

This project requires the following tools:
- **asciidoctor** - For generating HTML output
- **asciidoctor-pdf** - For generating PDF output

## Setup

### Option 1: Using Homebrew (macOS/Linux - Recommended)

```bash
brew install asciidoctor
```

### Option 2: Using RubyGems (All platforms)

```bash
gem install asciidoctor asciidoctor-pdf
```

### Option 3: Using Bundler (Project-local installation)

If you prefer to keep dependencies local to the project:

```bash
# Install gems to vendor/bundle
bundle config set --local path 'vendor/bundle'
bundle install

# Then use bundle exec for all commands
bundle exec make all
```

### Verification

Run the setup script to check if everything is installed correctly:

```bash
./setup.sh
```

## Usage

Once setup is complete, you can use the following commands:

```bash
make all       # Build both PDF and HTML
make pdf       # Build PDF only
make html      # Build HTML only
make verify    # Verify the setup and AsciiDoc syntax
make clean     # Remove build artifacts
make watch     # Auto-rebuild on file changes (requires inotifywait or entr)
make help      # Show all available commands
```

If you installed via bundler, prefix commands with `bundle exec`:

```bash
bundle exec make all
```

## Output

Generated files will be placed in the `build/` directory:
- `build/icd-template.pdf`
- `build/icd-template.html`

## Project Structure

```
.
├── icd-template.adoc    # Main AsciiDoc source file
├── Makefile             # Build automation
├── Gemfile              # Ruby gem dependencies
├── setup.sh             # Setup verification script
└── build/               # Generated output (gitignored)
```
