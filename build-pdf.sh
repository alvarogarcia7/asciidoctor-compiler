#!/bin/bash
# PDF build script with Ruby version check

set -e

echo "Checking Ruby version for PDF generation..."
RUBY_VERSION=$(ruby -e 'puts RUBY_VERSION')
RUBY_MAJOR=$(echo $RUBY_VERSION | cut -d. -f1)
RUBY_MINOR=$(echo $RUBY_VERSION | cut -d. -f2)

if [ "$RUBY_MAJOR" -lt 2 ] || ([ "$RUBY_MAJOR" -eq 2 ] && [ "$RUBY_MINOR" -lt 7 ]); then
    echo "Error: PDF generation requires Ruby >= 2.7"
    echo "Current Ruby version: $RUBY_VERSION"
    echo ""
    echo "Options:"
    echo "1. Use Docker: docker-compose run asciidoctor make pdf"
    echo "2. Upgrade Ruby to version 2.7 or later"
    echo "3. Use rbenv or rvm to install Ruby 2.7+"
    echo ""
    exit 1
fi

echo "Ruby version $RUBY_VERSION is compatible"
echo "Building PDF..."

bundle exec asciidoctor-pdf -r asciidoctor-kroki icd-template.adoc -o build/icd-template.pdf

echo "PDF generated: build/icd-template.pdf"
