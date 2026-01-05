# AsciiDoc Theme System Documentation

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Theme Selection](#theme-selection)
- [Customization Guide](#customization-guide)
- [Common Customizations](#common-customizations)
- [Available Themes](#available-themes)
- [Creating Custom Themes](#creating-custom-themes)

---

## Architecture Overview

The theme system consists of two separate but parallel theming mechanisms:

### PDF Themes (YAML-based)
- Location: `themes/pdf/`
- Format: YAML files compatible with `asciidoctor-pdf`
- Controls: Page layout, typography, colors, spacing, borders, and all visual aspects of PDF output
- Engine: Uses the `asciidoctor-pdf-theming-guide` specification

### HTML Themes (CSS-based)
- Location: `themes/html/`
- Format: Standard CSS files
- Controls: All visual styling for HTML output including layout, colors, typography, and responsive design
- Engine: Standard CSS applied to AsciiDoc-generated HTML

Both systems work independently and must be configured separately for consistent branding across output formats.

---

## Theme Selection

### Method 1: Document Attributes (Recommended)

Add attributes at the top of your `.adoc` file:

```asciidoc
= Document Title
:pdf-theme: themes/pdf/ecss-default-theme.yml
:stylesheet: themes/html/ecss-default.css

// Rest of your document...
```

**For PDF themes:**
```asciidoc
:pdf-theme: themes/pdf/ecss-default-theme.yml
```

**For HTML themes:**
```asciidoc
:stylesheet: themes/html/ecss-default.css
```

### Method 2: Command-Line Flags

Override themes without modifying the document:

**PDF generation:**
```bash
bundle exec asciidoctor-pdf -a pdf-theme=themes/pdf/minimal-theme.yml icd-template.adoc
```

**HTML generation:**
```bash
bundle exec asciidoctor -a stylesheet=themes/html/dark.css icd-template.adoc
```

**Combined (if using a custom build script):**
```bash
bundle exec asciidoctor-pdf -a pdf-theme=themes/pdf/corporate-theme.yml icd-template.adoc -o output.pdf
bundle exec asciidoctor -a stylesheet=themes/html/corporate.css icd-template.adoc -o output.html
```

### Method 3: Makefile Integration

Modify the `Makefile` to use specific themes by default:

```makefile
$(BUILD_DIR)/$(PDF_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating PDF..."
	@$(ASCIIDOCTOR_PDF) -a pdf-theme=themes/pdf/ecss-default-theme.yml $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(PDF_OUTPUT)

$(BUILD_DIR)/$(HTML_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating HTML..."
	@$(ASCIIDOCTOR) -a stylesheet=themes/html/ecss-default.css $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(HTML_OUTPUT)
```

---

## Customization Guide

### PDF Theme Customization (YAML)

PDF themes use YAML files with hierarchical key-value pairs. The structure follows the `asciidoctor-pdf` theming API.

#### Basic Structure

```yaml
# Page configuration
page:
  background_color: ffffff
  layout: portrait
  margin: [2cm, 2.5cm, 2cm, 2.5cm]  # top, right, bottom, left
  size: A4

# Base typography
base:
  font_color: 333333
  font_family: Helvetica
  font_size: 10
  line_height: 1.6

# Headings
heading:
  font_color: 1a5490
  font_family: $base_font_family
  font_style: bold
  h1_font_size: 24
  h2_font_size: 18
```

#### Key Sections

| Section | Purpose | Common Properties |
|---------|---------|-------------------|
| `page` | Page dimensions and margins | `size`, `layout`, `margin`, `background_color` |
| `base` | Default text styling | `font_color`, `font_family`, `font_size`, `line_height` |
| `heading` | Heading hierarchy (h1-h6) | `h1_font_size`, `font_color`, `font_style` |
| `link` | Hyperlink appearance | `font_color`, `font_style` |
| `code` | Code block styling | `background_color`, `border_color`, `padding` |
| `table` | Table formatting | `border_color`, `cell_padding`, `stripe_background_color` |
| `admonition` | Note/Warning boxes | `background_color`, `border_color`, `padding` |
| `footer` | Page footer content | `font_size`, `height`, `recto`, `verso` |
| `header` | Page header content | `font_size`, `height`, `recto`, `verso` |

#### Variables and References

Use variables to maintain consistency:

```yaml
base:
  font_size: 10
  line_height_length: 12
  
vertical_rhythm: $base_line_height_length
vertical_spacing: $vertical_rhythm

heading:
  margin_top: $vertical_rhythm * 0.8
  margin_bottom: $vertical_rhythm * 0.4
```

#### Color Format

Colors are specified as 6-digit hex without the `#` prefix:

```yaml
base:
  font_color: 333333          # Dark gray
  border_color: dddddd        # Light gray

heading:
  font_color: 1a5490          # Professional blue
```

### HTML Theme Customization (CSS)

HTML themes use standard CSS with CSS custom properties (variables) for easy customization.

#### Basic Structure

```css
:root {
  /* Color palette */
  --color-primary: #003366;
  --color-secondary: #0066cc;
  --color-text: #1a1a1a;
  --color-background: #ffffff;
  
  /* Typography */
  --font-family-base: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  --font-size-base: 11pt;
  --line-height-base: 1.6;
  
  /* Spacing */
  --spacing-md: 1rem;
  --spacing-lg: 1.5rem;
}

body {
  font-family: var(--font-family-base);
  font-size: var(--font-size-base);
  color: var(--color-text);
}

h1, h2, h3 {
  color: var(--color-primary);
}
```

#### Key Sections

| Section | Purpose | Selectors |
|---------|---------|-----------|
| `:root` | CSS variables | `--color-*`, `--font-*`, `--spacing-*` |
| `body` | Base document styling | `font-family`, `color`, `background` |
| `h1-h6` | Heading styles | `font-size`, `color`, `border-bottom` |
| `table` | Table formatting | `border`, `padding`, `background-color` |
| `.admonitionblock` | Note/Warning boxes | `background`, `border-left`, `padding` |
| `#toc` | Table of contents | `position`, `width`, `background` |
| `code`, `pre` | Code styling | `font-family`, `background`, `border` |
| `@media print` | Print-specific styles | Print optimizations |

---

## Common Customizations

### Changing Colors

#### PDF (YAML):
```yaml
# Change primary heading color
heading:
  font_color: 2c5aa0  # New blue shade

# Change table header background
table:
  head:
    background_color: 2c5aa0
    font_color: ffffff
```

#### HTML (CSS):
```css
:root {
  --color-primary: #2c5aa0;        /* Headings */
  --color-secondary: #5b9bd5;      /* Links */
  --color-table-header: #2c5aa0;   /* Table headers */
}
```

### Changing Fonts

#### PDF (YAML):
```yaml
base:
  font_family: Times-Roman  # Built-in fonts: Helvetica, Times-Roman, Courier

heading:
  font_family: Helvetica

code:
  font_family: Courier
```

**Built-in PDF fonts:**
- `Helvetica` (sans-serif)
- `Times-Roman` (serif)
- `Courier` (monospace)
- Font variants: `Helvetica-Bold`, `Times-Italic`, etc.

#### HTML (CSS):
```css
:root {
  --font-family-base: Georgia, 'Times New Roman', serif;
  --font-family-heading: 'Segoe UI', Tahoma, sans-serif;
  --font-family-mono: 'Fira Code', 'Consolas', monospace;
}
```

### Adjusting Spacing

#### PDF (YAML):
```yaml
base:
  line_height_length: 14  # Increase line spacing

vertical_rhythm: $base_line_height_length
vertical_spacing: $vertical_rhythm

heading:
  margin_top: $vertical_rhythm * 1.2    # More space above
  margin_bottom: $vertical_rhythm * 0.6  # More space below

prose:
  margin_bottom: $vertical_rhythm * 1.5  # More paragraph spacing
```

#### HTML (CSS):
```css
:root {
  --line-height-base: 1.8;     /* Increase from 1.6 */
  --spacing-md: 1.25rem;       /* Increase medium spacing */
  --spacing-lg: 2rem;          /* Increase large spacing */
}

p {
  margin-bottom: var(--spacing-lg);  /* More paragraph spacing */
}
```

### Modifying Page Layout (PDF)

```yaml
page:
  size: Letter              # Change from A4 to US Letter
  layout: landscape         # Change to landscape
  margin: [1.5cm, 2cm, 1.5cm, 2cm]  # Adjust margins

# Two-column layout (advanced)
base:
  columns: 2
  column_gap: 12
```

### Customizing Tables

#### PDF (YAML):
```yaml
table:
  border_color: 4a4a4a
  border_width: 1
  cell_padding: [6, 8, 6, 8]    # top, right, bottom, left
  head:
    font_style: bold
    font_color: ffffff
    background_color: 2c5aa0
    border_bottom_width: 2
  body:
    stripe_background_color: f5f5f5  # Alternating row color
    background_color: ffffff
  foot:
    font_style: bold
    background_color: e9e9e9
```

#### HTML (CSS):
```css
:root {
  --color-table-header: #2c5aa0;
  --color-table-row-odd: #fafafa;
  --color-table-row-even: #ffffff;
  --color-border: #d0d0d0;
}

table {
  border: 2px solid var(--color-border);
}

th {
  background-color: var(--color-table-header);
  color: white;
  padding: 0.75rem 1rem;
}

td {
  padding: 0.5rem 1rem;
}
```

### Styling Admonition Blocks

#### PDF (YAML):
```yaml
admonition:
  padding: [10, 12, 10, 12]
  border_width: 2
  border_radius: 4

admonition-note:
  background_color: e3f2fd
  border_color: 2196f3

admonition-warning:
  background_color: fff3e0
  border_color: ff9800

admonition-important:
  background_color: ffebee
  border_color: f44336
```

#### HTML (CSS):
```css
:root {
  --color-note: #e3f2fd;
  --color-note-border: #2196f3;
  --color-warning: #fff3e0;
  --color-warning-border: #ff9800;
  --color-important: #ffebee;
  --color-important-border: #f44336;
}

.admonitionblock {
  border-left: 5px solid;
  padding: 1rem 1.25rem;
  margin: 1.5rem 0;
  border-radius: 4px;
}

.admonitionblock.note {
  background-color: var(--color-note);
  border-left-color: var(--color-note-border);
}
```

### Adjusting Code Block Styling

#### PDF (YAML):
```yaml
code:
  font_family: Courier
  font_size: 9
  font_color: 2a2a2a
  background_color: f5f5f5
  border_color: d0d0d0
  border_width: 1
  border_radius: 3
  padding: [10, 12, 10, 12]
  line_height: 1.4

codespan:  # Inline code
  font_color: c7254e
  font_family: Courier
  background_color: f9f2f4
```

#### HTML (CSS):
```css
:root {
  --color-code-bg: #f5f5f5;
  --color-code-border: #d0d0d0;
  --color-code-text: #2a2a2a;
}

code {
  font-family: var(--font-family-mono);
  font-size: 0.9em;
  background-color: var(--color-code-bg);
  padding: 0.2em 0.4em;
  border-radius: 3px;
  color: var(--color-code-text);
}

pre {
  background-color: var(--color-code-bg);
  border: 1px solid var(--color-code-border);
  border-radius: 4px;
  padding: 1rem;
  overflow-x: auto;
}

pre code {
  background: transparent;
  padding: 0;
}
```

### Header and Footer Customization (PDF)

```yaml
footer:
  font_size: 9
  font_color: 666666
  border_color: cccccc
  border_width: 0.5
  height: 24
  padding: [6, 0, 0, 0]
  recto:
    right:
      content: 'Page {page-number} of {page-count}'
    left:
      content: '{document-title}'
  verso:
    left:
      content: 'Page {page-number} of {page-count}'
    right:
      content: '{document-title}'

header:
  font_size: 9
  font_color: 666666
  border_color: cccccc
  border_width: 0.5
  height: 24
  padding: [0, 0, 6, 0]
  recto:
    left:
      content: '{document-title}'
    right:
      content: '{section-or-chapter-title}'
  verso:
    left:
      content: '{section-or-chapter-title}'
    right:
      content: '{document-title}'
```

**Available placeholders:**
- `{page-number}` - Current page number
- `{page-count}` - Total number of pages
- `{document-title}` - Document title
- `{section-or-chapter-title}` - Current section title
- `{chapter-title}` - Current chapter title
- `{revnumber}` - Document revision number

---

## Available Themes

### ECSS Default Theme
**Files:** `themes/pdf/ecss-default-theme.yml`, `themes/html/ecss-default.css`

Professional theme compliant with European Cooperation for Space Standardization guidelines:
- Professional blue/gray color palette
- Clear heading hierarchy
- Striped tables with blue headers
- Color-coded admonition blocks
- Optimized for technical documentation

**Best for:** Official documentation, ICDs, technical specifications

### Minimal Theme
**Files:** `themes/pdf/minimal-theme.yml`, `themes/html/minimal.css`

Clean, monochrome design with minimal visual elements:
- Black/gray color scheme
- Thin borders or no borders
- Maximum readability
- Elegant simplicity

**Best for:** Internal documentation, drafts, print-optimized documents

### Dark Theme
**Files:** `themes/pdf/dark-theme.yml`, `themes/html/dark.css`

High-contrast dark mode for reduced eye strain:
- Dark background (#1e1e1e)
- Light text (#e0e0e0)
- Muted accent colors
- Optimized for screen reading

**Best for:** HTML documentation for developers, night-time reading

### Corporate Theme
**Files:** `themes/pdf/corporate-theme.yml`, `themes/html/corporate.css`

Professional business styling:
- Sophisticated color palette
- Professional typography
- Enhanced spacing and hierarchy
- Business-appropriate admonition styling

**Best for:** Business documents, proposals, client-facing documentation

---

## Creating Custom Themes

### Creating a Custom PDF Theme

1. **Copy an existing theme:**
   ```bash
   cp themes/pdf/ecss-default-theme.yml themes/pdf/my-custom-theme.yml
   ```

2. **Edit the YAML file:**
   - Modify colors (remember: 6-digit hex without `#`)
   - Adjust font sizes and families
   - Customize spacing and margins
   - Configure headers/footers

3. **Test your theme:**
   ```bash
   bundle exec asciidoctor-pdf -a pdf-theme=themes/pdf/my-custom-theme.yml icd-template.adoc
   ```

4. **Validate and refine:**
   - Check all page types (title page, TOC, content, etc.)
   - Verify tables, code blocks, and admonitions
   - Test with different content structures

### Creating a Custom HTML Theme

1. **Copy an existing theme:**
   ```bash
   cp themes/html/ecss-default.css themes/html/my-custom.css
   ```

2. **Modify CSS variables in `:root`:**
   ```css
   :root {
     --color-primary: #your-color;
     --font-family-base: 'Your Font', fallback;
     --spacing-md: your-spacing;
   }
   ```

3. **Customize specific elements:**
   - Adjust selectors for specific needs
   - Add custom classes
   - Modify responsive breakpoints
   - Customize print styles

4. **Test your theme:**
   ```bash
   bundle exec asciidoctor -a stylesheet=themes/html/my-custom.css icd-template.adoc
   ```

5. **Test across browsers and devices:**
   - Desktop browsers (Chrome, Firefox, Safari, Edge)
   - Mobile/tablet responsive layouts
   - Print preview

### Theme Development Tips

**PDF Themes:**
- Use variables (`$variable_name`) for consistency
- Test with `--trace` flag for debugging: `asciidoctor-pdf --trace ...`
- Reference the [asciidoctor-pdf theming guide](https://docs.asciidoctor.org/pdf-converter/latest/theme/)
- Keep colors web-safe and professional
- Test print output from actual PDF

**HTML Themes:**
- Use CSS custom properties for maintainability
- Test with different content lengths
- Ensure print styles work well
- Consider accessibility (contrast ratios, font sizes)
- Test TOC navigation and internal links
- Validate CSS with tools like [W3C CSS Validator](https://jigsaw.w3.org/css-validator/)

### Advanced Customization

**Using custom fonts in PDF:**
```yaml
font:
  catalog:
    CustomFont:
      normal: path/to/font-regular.ttf
      bold: path/to/font-bold.ttf
      italic: path/to/font-italic.ttf
      bold_italic: path/to/font-bolditalic.ttf

base:
  font_family: CustomFont
```

**Responsive HTML design:**
```css
@media screen and (max-width: 768px) {
  :root {
    --font-size-base: 10pt;
    --spacing-md: 0.75rem;
  }
  
  #toc {
    position: static;
    width: 100%;
  }
  
  #content {
    margin-left: 0;
  }
}
```

---

## Troubleshooting

### Common Issues

**PDF theme not applying:**
- Check file path is correct (relative to document or absolute)
- Verify YAML syntax (no tabs, correct indentation)
- Look for error messages in console output

**HTML stylesheet not loading:**
- Verify CSS file path
- Check for syntax errors in CSS
- Ensure `:stylesheet:` attribute is set correctly

**Colors not showing correctly:**
- PDF: Remove `#` prefix from hex colors
- HTML: Include `#` prefix in hex colors
- Verify hex values are 6 digits

**Fonts not working in PDF:**
- Use built-in fonts: Helvetica, Times-Roman, Courier
- For custom fonts, ensure TTF files are accessible
- Check font catalog configuration

**Layout issues:**
- Check margin and padding values
- Verify page size settings
- Test with minimal content first

### Getting Help

- [AsciiDoc Documentation](https://docs.asciidoctor.org/)
- [AsciiDoc PDF Theming Guide](https://docs.asciidoctor.org/pdf-converter/latest/theme/)
- [CSS Reference](https://developer.mozilla.org/en-US/docs/Web/CSS)

---

## Quick Reference

### PDF Theme Command
```bash
bundle exec asciidoctor-pdf -a pdf-theme=themes/pdf/THEME-NAME.yml document.adoc
```

### HTML Theme Command
```bash
bundle exec asciidoctor -a stylesheet=themes/html/THEME-NAME.css document.adoc
```

### Document Attributes
```asciidoc
:pdf-theme: themes/pdf/THEME-NAME.yml
:stylesheet: themes/html/THEME-NAME.css
```

### Theme File Locations
- **PDF themes:** `themes/pdf/*.yml`
- **HTML themes:** `themes/html/*.css`
