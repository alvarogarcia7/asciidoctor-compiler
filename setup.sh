#!/bin/bash
set -e

echo "Setting up AsciiDoc ICD Template repository..."
echo ""

# Check if asciidoctor is already installed
if command -v asciidoctor &> /dev/null && command -v asciidoctor-pdf &> /dev/null; then
    echo "✓ asciidoctor and asciidoctor-pdf are already installed"
    echo "  asciidoctor: $(which asciidoctor)"
    echo "  asciidoctor-pdf: $(which asciidoctor-pdf)"
    echo ""
    echo "Setup complete! You can now run:"
    echo "  make all    - Build PDF and HTML"
    echo "  make verify - Verify the setup"
    exit 0
fi

echo "asciidoctor tools not found. Installation required."
echo ""

# Check if Gemfile exists and try bundle install
if [ -f "Gemfile" ]; then
    echo "Installing gems from Gemfile..."
    if command -v bundle &> /dev/null; then
        # Try to install to vendor/bundle (local to project)
        bundle config set --local path 'vendor/bundle'
        if bundle install; then
            echo "✓ Gems installed successfully to vendor/bundle"
            echo ""
            echo "Setup complete! Use bundle exec to run commands:"
            echo "  bundle exec make all"
            echo "  bundle exec make verify"
            exit 0
        else
            echo "✗ Bundle install failed"
        fi
    else
        echo "✗ bundler not found"
    fi
fi

echo ""
echo "Manual installation required. Please install asciidoctor tools:"
echo ""
echo "Option 1 - Using Homebrew (recommended for macOS):"
echo "  brew install asciidoctor"
echo ""
echo "Option 2 - Using RubyGems:"
echo "  gem install asciidoctor asciidoctor-pdf"
echo ""
echo "Option 3 - Using bundler (if available):"
echo "  bundle install --path vendor/bundle"
echo "  # Then use: bundle exec make all"
echo ""
echo "After installation, run this script again to verify."
exit 1
