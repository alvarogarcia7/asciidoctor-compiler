#!/bin/bash
set -e
echo "Verifying AsciiDoc syntax..."
if command -v bundle &> /dev/null && [ -f Gemfile.lock ] && bundle exec asciidoctor --version &> /dev/null; then
    bundle exec asciidoctor -o /dev/null icd-template.adoc && echo "✓ AsciiDoc syntax is valid"
elif command -v asciidoctor &> /dev/null; then
    asciidoctor -o /dev/null icd-template.adoc && echo "✓ AsciiDoc syntax is valid"
else
    echo "✗ asciidoctor not found, skipping syntax check"
    exit 1
fi
echo "Verification complete!"
