# AI Agent Configuration

## Environment

- **Docker**: Not running in Docker container
- **Bundler**: Available (version 1.17.2) with local dependencies installed in `vendor/bundle`
- **Ruby**: Version 2.6.10 (system Ruby)
- **Ruby Dependencies**: Managed via Bundler with local installation
- **Limitation**: PDF generation requires Ruby >= 2.7. With Ruby 2.6, only HTML generation is available via `bundle exec asciidoctor`. For PDF generation, use Docker or upgrade Ruby to 2.7+.

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
- **asciidoctor-diagram**: Diagram rendering support (PlantUML, Mermaid, Graphviz, etc.)
- **PlantUML**: UML diagram generation tool
- **Mermaid**: Modern diagram and flowchart tool
- **Graphviz**: Graph visualization software (required dependency for PlantUML)
- **Java**: Runtime environment for PlantUML
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
gem 'asciidoctor-diagram', '~> 2.2'
```

### System Requirements
- Ruby (for running asciidoctor)
- Java (for running PlantUML)
- PlantUML (for PlantUML diagram rendering)
- Mermaid CLI (for Mermaid diagram rendering)
- Graphviz (required dependency for PlantUML)
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

## Diagram Support

The project supports multiple diagram types through asciidoctor-diagram, which automatically detects and renders diagrams based on the block type.

### PlantUML Diagrams

PlantUML diagrams use the `[plantuml]` block type and support UML diagrams, sequence diagrams, component diagrams, and more.

**Syntax Example:**

```asciidoc
[plantuml, diagram-name, format=svg]
----
@startuml
actor User
participant "System A" as A
participant "System B" as B

User -> A: Request
A -> B: Forward Request
B --> A: Response
A --> User: Final Response
@enduml
----
```

**Requirements:**
- Java runtime (8+)
- PlantUML jar or system package
- Graphviz (for certain diagram types)

### Mermaid Diagrams

Mermaid diagrams use the `[mermaid]` block type and provide a modern syntax for flowcharts, sequence diagrams, Gantt charts, and more.

**Syntax Example:**

```asciidoc
[mermaid, diagram-name, format=svg]
----
sequenceDiagram
    participant User
    participant SystemA
    participant SystemB
    
    User->>SystemA: Request
    SystemA->>SystemB: Forward Request
    SystemB-->>SystemA: Response
    SystemA-->>User: Final Response
----
```

**Additional Mermaid Examples:**

Flowchart:
```asciidoc
[mermaid]
----
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Action 1]
    B -->|No| D[Action 2]
    C --> E[End]
    D --> E
----
```

Class Diagram:
```asciidoc
[mermaid]
----
classDiagram
    class Interface {
        +String name
        +String type
        +connect()
        +disconnect()
    }
    class DataElement {
        +String id
        +String dataType
        +validate()
    }
    Interface --> DataElement : uses
----
```

**Requirements:**
- Mermaid CLI (`npm install -g @mermaid-js/mermaid-cli` or `mmdc` command available)
- Node.js (for running Mermaid CLI)

### Automatic Detection

The asciidoctor-diagram extension automatically:
1. Detects the diagram type from the block attribute (`[plantuml]`, `[mermaid]`, etc.)
2. Invokes the appropriate rendering tool
3. Generates the diagram image (SVG, PNG, etc.)
4. Embeds the result in the output document

**Format Options:**
- `format=svg` - Scalable Vector Graphics (recommended)
- `format=png` - Portable Network Graphics

**Block Attributes:**
- First positional parameter: diagram name/ID (used for caching)
- `format` parameter: output format (svg, png, etc.)

### Using Diagrams in Documents

Simply include diagram blocks in your AsciiDoc file and run the build commands:

```bash
bundle exec make all
```

The diagrams will be automatically rendered during document generation.
