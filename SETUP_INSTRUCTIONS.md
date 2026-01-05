# Setup Instructions

This document provides step-by-step instructions for setting up the ICD Template repository.

## What Has Been Configured

The repository has been configured with:
- ✅ `Gemfile` - Ruby gem dependencies (asciidoctor, asciidoctor-pdf)
- ✅ `.bundle/config` - Bundler configuration for local installation
- ✅ `.gitignore` - Ignores build artifacts and vendor directory
- ✅ `setup.sh` - Automated setup verification script
- ✅ `README.md` - User documentation
- ✅ `AGENTS.md` - Development documentation

## Required Installation Steps

To complete the setup, you need to install the AsciiDoc tools. Choose one of the following methods:

### Method 1: Homebrew (Recommended for macOS)

```bash
brew install asciidoctor
```

This will install both `asciidoctor` and `asciidoctor-pdf` globally.

### Method 2: Bundler (Project-local installation)

Install gems locally to this project:

```bash
bundle install
```

This will install gems to `vendor/bundle/` (gitignored).

After installation, use `bundle exec` prefix for all commands:
```bash
bundle exec make all
bundle exec make verify
```

### Method 3: RubyGems (Global installation)

```bash
gem install asciidoctor asciidoctor-pdf
```

## Verification

After installation, verify the setup:

```bash
./setup.sh
```

This script will:
1. Check if asciidoctor tools are available
2. Verify they can be executed
3. Confirm the setup is complete

## Testing the Build

Once setup is complete, test the build:

```bash
make all
```

This should generate:
- `build/icd-template.pdf`
- `build/icd-template.html`

## Troubleshooting

### Bundle Install Issues

If you see permission errors with bundler, ensure you're using a modern version:

```bash
gem update --system
gem install bundler
```

Then try again:
```bash
bundle install
```

### System Ruby Issues on macOS

If you're using the system Ruby on macOS and encounter permission issues, consider:

1. **Using Homebrew Ruby** (recommended):
   ```bash
   brew install ruby
   # Add to your shell profile:
   export PATH="/usr/local/opt/ruby/bin:$PATH"
   ```

2. **Using rbenv** (alternative):
   ```bash
   brew install rbenv
   rbenv install 3.2.0
   rbenv local 3.2.0
   ```

### Verification Failures

If `./setup.sh` reports tools are not found:

1. Check your PATH includes gem binary directory:
   ```bash
   echo $PATH | grep -o '/usr/local/bin'
   ```

2. If using bundler, ensure you prefix commands:
   ```bash
   bundle exec asciidoctor --version
   ```

## Next Steps

After successful setup:

1. Edit `icd-template.adoc` with your content
2. Run `make all` to build
3. Use `make watch` for auto-rebuilding during development
4. See `README.md` for complete usage documentation
