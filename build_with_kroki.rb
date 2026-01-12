#!/usr/bin/env ruby
# encoding: UTF-8

require 'asciidoctor'
require 'asciidoctor-diagram'

# Set encoding
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Build HTML
puts "Building HTML..."
Asciidoctor.convert_file(
  'icd-template.adoc',
  to_file: 'build/icd-template.html',
  safe: :unsafe,
  mkdirs: true,
  attributes: {
    'kroki-fetch-diagram' => true,
    'kroki-server-url' => 'https://kroki.io'
  }
)
puts "HTML generated: build/icd-template.html"

puts "Build complete!"
