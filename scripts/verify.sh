#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Support DOCUMENT_FILE via environment variable or command-line argument
# Priority: CLI argument > environment variable > default
DOCUMENT_FILE="${DOCUMENT_FILE:-}"
DEFAULT_ASCIIDOC_FILE="icd-template.adoc"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERROR_COUNT=0
WARNING_COUNT=0

# Document type and configuration
DOCUMENT_TYPE="generic"
CONFIG_FILE=""

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [INPUT_FILE]

Verify AsciiDoc document syntax, structure, and compliance with template standards.
Supports document type detection from template-config.yml for type-specific validation.

OPTIONS:
    --help                  Show this help message
    --strict                Treat warnings as errors
    --no-color              Disable colored output

ARGUMENTS:
    INPUT_FILE              AsciiDoc input file (default: ${DEFAULT_ASCIIDOC_FILE})
                            Can also be set via DOCUMENT_FILE environment variable

ENVIRONMENT VARIABLES:
    DOCUMENT_FILE           Path to the document file to verify

EXAMPLES:
    $(basename "$0")
    $(basename "$0") document.adoc
    $(basename "$0") --strict document.adoc
    DOCUMENT_FILE=my-doc.adoc $(basename "$0")

DOCUMENT TYPE DETECTION:
    The script automatically detects document type from template-config.yml
    and applies type-specific validation rules:
    - ICD: Interface Control Document validation (ECSS compliance)
    - SSDLC: Secure Software Development Lifecycle validation (security focus)
    - Generic: Basic document structure validation (flexible)

EOF
}

log_error() {
    echo -e "${RED}✗ ERROR:${NC} $1" >&2
    ((ERROR_COUNT++))
}

log_warning() {
    echo -e "${YELLOW}⚠ WARNING:${NC} $1"
    ((WARNING_COUNT++))
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

detect_document_type() {
    local input_file="$1"
    local input_dir="$(dirname "$input_file")"
    local config_file="${input_dir}/template-config.yml"
    local doc_type="generic"
    
    # Try to find template-config.yml in input directory or parent directories
    local search_dir="$input_dir"
    while [[ "$search_dir" != "/" && "$search_dir" != "." ]]; do
        if [[ -f "${search_dir}/template-config.yml" ]]; then
            config_file="${search_dir}/template-config.yml"
            CONFIG_FILE="$config_file"
            break
        fi
        search_dir="$(dirname "$search_dir")"
    done
    
    # Parse document type from template-config.yml
    if [[ -f "$config_file" ]]; then
        # Try to extract document-type from the YAML config
        if command -v grep &> /dev/null; then
            local extracted_type=""
            
            # Try custom-attributes.document-type first
            extracted_type=$(grep -A 50 "custom-attributes:" "$config_file" | grep "document-type:" | head -1 | sed 's/.*document-type:[[:space:]]*//;s/[[:space:]]*$//' | tr -d '"' || true)
            
            # If not found, try template.name and extract type
            if [[ -z "$extracted_type" ]]; then
                local template_name=$(grep "name:" "$config_file" | grep -i "template" | head -1 | sed 's/.*name:[[:space:]]*//;s/[[:space:]]*$//' | tr -d '"' || true)
                if [[ -n "$template_name" ]]; then
                    # Extract first word and convert to lowercase
                    extracted_type=$(echo "$template_name" | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
                fi
            fi
            
            if [[ -n "$extracted_type" ]]; then
                doc_type=$(echo "$extracted_type" | tr '[:upper:]' '[:lower:]')
            fi
        fi
    fi
    
    echo "$doc_type"
}

get_required_sections() {
    local doc_type="$1"
    
    case "$doc_type" in
        icd)
            echo "Revision History"
            echo "Applicable Documents"
            echo "Terms, Definitions and Abbreviations"
            echo "Introduction"
            echo "Interface Overview"
            ;;
        ssdlc)
            echo "Revision History"
            echo "Applicable Documents"
            echo "Terms, Definitions and Abbreviations"
            echo "Introduction"
            echo "Security Requirements"
            echo "Threat Model"
            ;;
        generic)
            echo "Revision History"
            echo "Introduction"
            ;;
        *)
            echo "Revision History"
            echo "Introduction"
            ;;
    esac
}

get_recommended_sections() {
    local doc_type="$1"
    
    case "$doc_type" in
        icd)
            echo "Interface Requirements"
            echo "Detailed Interface Specifications"
            echo "Data Element Definitions"
            ;;
        ssdlc)
            echo "Security Controls"
            echo "Secure Development Practices"
            echo "Security Testing"
            ;;
        generic)
            echo "Applicable Documents"
            echo "Terms, Definitions and Abbreviations"
            echo "Conclusion"
            ;;
        *)
            echo "Applicable Documents"
            echo "Conclusion"
            ;;
    esac
}

check_security_sections() {
    local asciidoc_file="$1"
    
    log_info "Checking security-specific sections for SSDLC document..."
    
    local security_sections=(
        "Threat Model"
        "Risk Assessment"
        "Access Control"
        "Authentication"
        "Data Protection"
        "Security Testing"
    )
    
    local found_count=0
    
    for section in "${security_sections[@]}"; do
        if grep -qi "^===* ${section}" "$asciidoc_file"; then
            log_success "Found security section: $section"
            ((found_count++))
        else
            log_warning "Missing recommended security section: $section"
        fi
    done
    
    if [[ $found_count -ge 3 ]]; then
        log_success "Found adequate security sections ($found_count/${#security_sections[@]})"
    else
        log_warning "Found only $found_count/${#security_sections[@]} security sections"
    fi
}

check_file_exists() {
    local asciidoc_file="$1"
    if [[ ! -f "$asciidoc_file" ]]; then
        log_error "AsciiDoc file not found: $asciidoc_file"
        exit 1
    fi
    log_success "AsciiDoc file found: $asciidoc_file"
}

check_required_sections() {
    local asciidoc_file="$1"
    local doc_type="$2"
    
    log_info "Checking for required sections (document type: $doc_type)..."
    
    # Get required sections for this document type
    local required_sections=()
    while IFS= read -r line; do
        required_sections+=("$line")
    done < <(get_required_sections "$doc_type")
    
    for section in "${required_sections[@]}"; do
        if [[ "$section" == "Terms, Definitions and Abbreviations" ]]; then
            if grep -q "^=== Terms, Definitions and Abbreviations" "$asciidoc_file"; then
                log_success "Found section: $section"
                
                # Check for subsections
                if grep -q "^==== Terms and Definitions" "$asciidoc_file"; then
                    log_success "Found subsection: Terms and Definitions"
                else
                    log_warning "Missing recommended subsection: Terms and Definitions"
                fi
                
                if grep -q "^==== Abbreviations and Acronyms" "$asciidoc_file"; then
                    log_success "Found subsection: Abbreviations and Acronyms"
                else
                    log_warning "Missing recommended subsection: Abbreviations and Acronyms"
                fi
            else
                log_error "Missing required section: $section"
            fi
        elif grep -q "^===* ${section}" "$asciidoc_file"; then
            log_success "Found section: $section"
        else
            log_error "Missing required section: $section"
        fi
    done
    
    # Check recommended sections
    log_info "Checking for recommended sections..."
    local recommended_sections=()
    while IFS= read -r line; do
        recommended_sections+=("$line")
    done < <(get_recommended_sections "$doc_type")
    
    for section in "${recommended_sections[@]}"; do
        if grep -q "^===* ${section}" "$asciidoc_file"; then
            log_success "Found recommended section: $section"
        else
            log_warning "Missing recommended section: $section"
        fi
    done
}

check_cross_references() {
    local asciidoc_file="$1"
    
    log_info "Checking cross-references and anchors..."
    
    local temp_refs=$(mktemp)
    local temp_anchors=$(mktemp)
    
    grep -oP '<<[^,>]+' "$asciidoc_file" | sed 's/<<//g' | sort -u > "$temp_refs" || true
    grep -oP '\[\[[\w-]+\]\]' "$asciidoc_file" | sed 's/\[\[\(.*\)\]\]/\1/g' | sort -u > "$temp_anchors" || true
    
    if [[ ! -s "$temp_refs" ]]; then
        log_warning "No cross-references found in document"
    else
        local ref_count=$(wc -l < "$temp_refs")
        log_info "Found $ref_count unique cross-reference(s)"
        
        while IFS= read -r ref; do
            if grep -q "^\[\[$ref\]\]" "$asciidoc_file"; then
                log_success "Cross-reference '<<$ref>>' has matching anchor"
            else
                log_error "Cross-reference '<<$ref>>' has no matching anchor [[${ref}]]"
            fi
        done < "$temp_refs"
    fi
    
    rm -f "$temp_refs" "$temp_anchors"
}

check_broken_internal_links() {
    local asciidoc_file="$1"
    
    log_info "Checking for broken internal links..."
    
    local broken_link_patterns=(
        '\[.*\]\(#[^)]*\)'
        'xref:[^[]*\['
    )
    
    local found_broken=false
    
    local xref_links=$(grep -oP 'xref:[^[,\]]+' "$asciidoc_file" | sed 's/xref://g' || true)
    
    if [[ -n "$xref_links" ]]; then
        while IFS= read -r xref; do
            if grep -q "^\[\[$xref\]\]" "$asciidoc_file"; then
                log_success "xref:$xref has matching anchor"
            else
                log_error "xref:$xref has no matching anchor [[${xref}]]"
                found_broken=true
            fi
        done <<< "$xref_links"
    fi
    
    local hash_links=$(grep -oP '\[.*?\]\(#[^)]+\)' "$asciidoc_file" || true)
    if [[ -n "$hash_links" ]]; then
        log_warning "Found markdown-style hash links which may not work correctly in AsciiDoc:"
        echo "$hash_links" | while IFS= read -r link; do
            log_warning "  $link"
        done
    fi
    
    if [[ "$found_broken" == false ]] && [[ -z "$hash_links" ]]; then
        log_success "No broken internal links detected"
    fi
}

check_table_formatting() {
    local asciidoc_file="$1"
    
    log_info "Checking table formatting..."
    
    local in_table=false
    local table_start_line=0
    local table_count=0
    local malformed_tables=0
    local line_num=0
    
    while IFS= read -r line; do
        ((line_num++))
        
        if [[ "$line" =~ ^\|=== ]]; then
            if [[ "$in_table" == true ]]; then
                log_success "Table at line $table_start_line is properly closed"
                in_table=false
            else
                in_table=true
                table_start_line=$line_num
                ((table_count++))
            fi
        elif [[ "$in_table" == true ]]; then
            if [[ "$line" =~ ^\[cols= ]]; then
                continue
            elif [[ -n "$line" ]] && [[ ! "$line" =~ ^\| ]] && [[ ! "$line" =~ ^$ ]] && [[ ! "$line" =~ ^// ]]; then
                if [[ ! "$line" =~ ^\*.*\* ]] && [[ ! "$line" =~ ^[[:space:]].*$ ]]; then
                    log_warning "Possible malformed table row at line $line_num (doesn't start with |): $line"
                fi
            fi
        fi
    done < "$asciidoc_file"
    
    if [[ "$in_table" == true ]]; then
        log_error "Unclosed table starting at line $table_start_line"
        ((malformed_tables++))
    fi
    
    log_info "Found $table_count table(s) in document"
    
    if [[ $malformed_tables -eq 0 ]]; then
        log_success "All tables are properly formatted"
    else
        log_error "Found $malformed_tables malformed table(s)"
    fi
    
    grep -n '^\[cols=' "$asciidoc_file" | while IFS=: read -r linenum cols_def; do
        if [[ "$cols_def" =~ ^\[cols=\"([^\"]+)\"\] ]]; then
            log_success "Line $linenum: Valid cols definition: $cols_def"
        elif [[ "$cols_def" =~ ^\[cols=\'([^\']+)\'\] ]]; then
            log_success "Line $linenum: Valid cols definition: $cols_def"
        else
            log_warning "Line $linenum: Potentially invalid cols definition: $cols_def"
        fi
    done || true
}

check_document_structure() {
    local asciidoc_file="$1"
    
    log_info "Checking overall document structure..."
    
    if grep -q "^= .*" "$asciidoc_file"; then
        log_success "Document has level 0 title (= ...)"
    else
        log_error "Document missing level 0 title (= ...)"
    fi
    
    local level1_count=$(grep -c "^== [^=]" "$asciidoc_file" || true)
    local level2_count=$(grep -c "^=== [^=]" "$asciidoc_file" || true)
    local level3_count=$(grep -c "^==== [^=]" "$asciidoc_file" || true)
    local level4_count=$(grep -c "^===== [^=]" "$asciidoc_file" || true)
    
    log_info "Document structure:"
    log_info "  Level 1 sections (==): $level1_count"
    log_info "  Level 2 sections (===): $level2_count"
    log_info "  Level 3 sections (====): $level3_count"
    log_info "  Level 4 sections (=====): $level4_count"
    
    if [[ $level1_count -eq 0 ]]; then
        log_warning "No level 1 sections found"
    fi
    
    local prev_level=0
    local line_num=0
    while IFS= read -r line; do
        ((line_num++))
        if [[ "$line" =~ ^(=+)[[:space:]][^=] ]]; then
            local equals="${BASH_REMATCH[1]}"
            local current_level=${#equals}
            
            if [[ $current_level -gt $((prev_level + 1)) ]] && [[ $prev_level -gt 0 ]]; then
                log_warning "Line $line_num: Section level jump from $prev_level to $current_level (should increment by 1)"
            fi
            
            prev_level=$current_level
        fi
    done < "$asciidoc_file"
    
    log_success "Document structure check complete"
}

check_required_attributes() {
    local asciidoc_file="$1"
    
    log_info "Checking required document attributes..."
    
    local required_attrs=(
        ":title:"
        ":author:"
        ":revnumber:"
        ":doctype:"
    )
    
    for attr in "${required_attrs[@]}"; do
        if grep -q "^${attr}" "$asciidoc_file"; then
            log_success "Found required attribute: $attr"
        else
            log_warning "Missing recommended attribute: $attr"
        fi
    done
}

check_list_formatting() {
    local asciidoc_file="$1"
    
    log_info "Checking list formatting..."
    
    local line_num=0
    local in_list=false
    local list_type=""
    
    while IFS= read -r line; do
        ((line_num++))
        
        if [[ "$line" =~ ^\*[[:space:]] ]] || [[ "$line" =~ ^\*\* ]]; then
            if [[ "$in_list" == false ]]; then
                in_list=true
                list_type="unordered"
            fi
        elif [[ "$line" =~ ^\.[[:space:]] ]] || [[ "$line" =~ ^\.\. ]]; then
            if [[ "$in_list" == false ]]; then
                in_list=true
                list_type="ordered"
            fi
        elif [[ -z "$line" ]] || [[ "$line" =~ ^[^*\.[:space:]] ]]; then
            if [[ "$in_list" == true ]]; then
                in_list=false
            fi
        fi
        
        if [[ "$line" =~ ^\*[^[:space:]*] ]]; then
            log_warning "Line $line_num: List item should have space after asterisk: $line"
        fi
    done < "$asciidoc_file"
    
    log_success "List formatting check complete"
}

check_placeholder_content() {
    local asciidoc_file="$1"
    
    log_info "Checking for placeholder content..."
    
    local placeholders=(
        '\[TBD\]'
        '\[TBC\]'
        '\[TODO\]'
        '\[Author Name\]'
        '\[Document ID\]'
        '\[Project Name\]'
    )
    
    local placeholder_count=0
    
    for pattern in "${placeholders[@]}"; do
        local matches=$(grep -n "$pattern" "$asciidoc_file" || true)
        if [[ -n "$matches" ]]; then
            ((placeholder_count++))
            log_warning "Found placeholder content: $pattern"
            echo "$matches" | while IFS=: read -r linenum content; do
                log_warning "  Line $linenum: $content"
            done
        fi
    done
    
    if [[ $placeholder_count -eq 0 ]]; then
        log_info "No common placeholder markers found"
    else
        log_warning "Found $placeholder_count type(s) of placeholder content that may need updating"
    fi
}

generate_report() {
    local strict_mode="$1"
    
    echo ""
    echo "======================================"
    echo "  Verification Summary"
    echo "======================================"
    
    if [[ $ERROR_COUNT -eq 0 ]] && [[ $WARNING_COUNT -eq 0 ]]; then
        log_success "All checks passed!"
        echo ""
        echo "Status: ${GREEN}PASS${NC}"
    elif [[ $ERROR_COUNT -eq 0 ]]; then
        echo ""
        if [[ "$strict_mode" == "true" ]]; then
            echo "Status: ${RED}FAIL${NC} (strict mode: warnings treated as errors)"
            echo "Warnings: $WARNING_COUNT"
        else
            echo "Status: ${YELLOW}PASS WITH WARNINGS${NC}"
            echo "Warnings: $WARNING_COUNT"
        fi
    else
        echo ""
        echo "Status: ${RED}FAIL${NC}"
        echo "Errors: $ERROR_COUNT"
        echo "Warnings: $WARNING_COUNT"
    fi
    
    echo "======================================"
}

main() {
    local asciidoc_file=""
    local strict_mode=false
    local no_color=false
    
    # Parse command-line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                show_usage
                exit 0
                ;;
            --strict)
                strict_mode=true
                shift
                ;;
            --no-color)
                no_color=true
                RED=''
                GREEN=''
                YELLOW=''
                BLUE=''
                NC=''
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                if [[ -z "$asciidoc_file" ]]; then
                    asciidoc_file="$1"
                else
                    log_error "Multiple input files specified"
                    show_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Determine input file: CLI arg > DOCUMENT_FILE env var > default
    if [[ -z "$asciidoc_file" ]]; then
        if [[ -n "$DOCUMENT_FILE" ]]; then
            asciidoc_file="$DOCUMENT_FILE"
            log_info "Using DOCUMENT_FILE environment variable: $asciidoc_file"
        else
            asciidoc_file="${PROJECT_ROOT}/${DEFAULT_ASCIIDOC_FILE}"
        fi
    fi
    
    # Convert relative path to absolute
    if [[ ! "$asciidoc_file" =~ ^/ ]]; then
        asciidoc_file="${PROJECT_ROOT}/${asciidoc_file}"
    fi
    
    echo "======================================"
    echo "  AsciiDoc Document Verification"
    echo "======================================"
    echo ""
    
    check_file_exists "$asciidoc_file"
    echo ""
    
    # Detect document type
    DOCUMENT_TYPE=$(detect_document_type "$asciidoc_file")
    if [[ -n "$CONFIG_FILE" ]]; then
        log_info "Found template config: $CONFIG_FILE"
        log_info "Detected document type: $DOCUMENT_TYPE"
    else
        log_info "No template-config.yml found, using default document type: $DOCUMENT_TYPE"
    fi
    echo ""
    
    check_document_structure "$asciidoc_file"
    echo ""
    
    check_required_sections "$asciidoc_file" "$DOCUMENT_TYPE"
    echo ""
    
    # Type-specific validations
    if [[ "$DOCUMENT_TYPE" == "ssdlc" ]]; then
        check_security_sections "$asciidoc_file"
        echo ""
    fi
    
    check_required_attributes "$asciidoc_file"
    echo ""
    
    check_cross_references "$asciidoc_file"
    echo ""
    
    check_broken_internal_links "$asciidoc_file"
    echo ""
    
    check_table_formatting "$asciidoc_file"
    echo ""
    
    check_list_formatting "$asciidoc_file"
    echo ""
    
    check_placeholder_content "$asciidoc_file"
    echo ""
    
    generate_report "$strict_mode"
    
    if [[ $ERROR_COUNT -gt 0 ]]; then
        exit 1
    elif [[ "$strict_mode" == "true" ]] && [[ $WARNING_COUNT -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

main "$@"
