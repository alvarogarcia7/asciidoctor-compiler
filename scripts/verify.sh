#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ASCIIDOC_FILE="${PROJECT_ROOT}/icd-template.adoc"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERROR_COUNT=0
WARNING_COUNT=0

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

check_file_exists() {
    if [[ ! -f "$ASCIIDOC_FILE" ]]; then
        log_error "AsciiDoc file not found: $ASCIIDOC_FILE"
        exit 1
    fi
    log_success "AsciiDoc file found: $ASCIIDOC_FILE"
}

check_required_ecss_sections() {
    log_info "Checking for required ECSS sections..."
    
    local required_sections=(
        "Revision History"
        "Applicable Documents"
        "Terms, Definitions and Abbreviations"
        "Terms and Definitions"
        "Abbreviations and Acronyms"
    )
    
    local section_found=false
    
    if grep -q "^=== Revision History" "$ASCIIDOC_FILE"; then
        log_success "Found section: Revision History"
    else
        log_error "Missing required section: Revision History"
    fi
    
    if grep -q "^=== Applicable Documents" "$ASCIIDOC_FILE"; then
        log_success "Found section: Applicable Documents"
    else
        log_error "Missing required section: Applicable Documents"
    fi
    
    if grep -q "^=== Terms, Definitions and Abbreviations" "$ASCIIDOC_FILE"; then
        log_success "Found section: Terms, Definitions and Abbreviations"
        
        if grep -q "^==== Terms and Definitions" "$ASCIIDOC_FILE"; then
            log_success "Found subsection: Terms and Definitions"
        else
            log_error "Missing required subsection: Terms and Definitions"
        fi
        
        if grep -q "^==== Abbreviations and Acronyms" "$ASCIIDOC_FILE"; then
            log_success "Found subsection: Abbreviations and Acronyms"
        else
            log_error "Missing required subsection: Abbreviations and Acronyms"
        fi
    else
        log_error "Missing required section: Terms, Definitions and Abbreviations"
    fi
}

check_cross_references() {
    log_info "Checking cross-references and anchors..."
    
    local temp_refs=$(mktemp)
    local temp_anchors=$(mktemp)
    
    grep -oP '<<[^,>]+' "$ASCIIDOC_FILE" | sed 's/<<//g' | sort -u > "$temp_refs" || true
    grep -oP '\[\[[\w-]+\]\]' "$ASCIIDOC_FILE" | sed 's/\[\[\(.*\)\]\]/\1/g' | sort -u > "$temp_anchors" || true
    
    if [[ ! -s "$temp_refs" ]]; then
        log_warning "No cross-references found in document"
    else
        local ref_count=$(wc -l < "$temp_refs")
        log_info "Found $ref_count unique cross-reference(s)"
        
        while IFS= read -r ref; do
            if grep -q "^\[\[$ref\]\]" "$ASCIIDOC_FILE"; then
                log_success "Cross-reference '<<$ref>>' has matching anchor"
            else
                log_error "Cross-reference '<<$ref>>' has no matching anchor [[${ref}]]"
            fi
        done < "$temp_refs"
    fi
    
    rm -f "$temp_refs" "$temp_anchors"
}

check_broken_internal_links() {
    log_info "Checking for broken internal links..."
    
    local broken_link_patterns=(
        '\[.*\]\(#[^)]*\)'
        'xref:[^[]*\['
    )
    
    local found_broken=false
    
    local xref_links=$(grep -oP 'xref:[^[,\]]+' "$ASCIIDOC_FILE" | sed 's/xref://g' || true)
    
    if [[ -n "$xref_links" ]]; then
        while IFS= read -r xref; do
            if grep -q "^\[\[$xref\]\]" "$ASCIIDOC_FILE"; then
                log_success "xref:$xref has matching anchor"
            else
                log_error "xref:$xref has no matching anchor [[${xref}]]"
                found_broken=true
            fi
        done <<< "$xref_links"
    fi
    
    local hash_links=$(grep -oP '\[.*?\]\(#[^)]+\)' "$ASCIIDOC_FILE" || true)
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
    done < "$ASCIIDOC_FILE"
    
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
    
    grep -n '^\[cols=' "$ASCIIDOC_FILE" | while IFS=: read -r linenum cols_def; do
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
    log_info "Checking overall document structure..."
    
    if grep -q "^= .*" "$ASCIIDOC_FILE"; then
        log_success "Document has level 0 title (= ...)"
    else
        log_error "Document missing level 0 title (= ...)"
    fi
    
    local level1_count=$(grep -c "^== [^=]" "$ASCIIDOC_FILE" || true)
    local level2_count=$(grep -c "^=== [^=]" "$ASCIIDOC_FILE" || true)
    local level3_count=$(grep -c "^==== [^=]" "$ASCIIDOC_FILE" || true)
    local level4_count=$(grep -c "^===== [^=]" "$ASCIIDOC_FILE" || true)
    
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
    done < "$ASCIIDOC_FILE"
    
    log_success "Document structure check complete"
}

check_required_attributes() {
    log_info "Checking required document attributes..."
    
    local required_attrs=(
        ":title:"
        ":author:"
        ":revnumber:"
        ":doctype:"
    )
    
    for attr in "${required_attrs[@]}"; do
        if grep -q "^${attr}" "$ASCIIDOC_FILE"; then
            log_success "Found required attribute: $attr"
        else
            log_warning "Missing recommended attribute: $attr"
        fi
    done
}

check_list_formatting() {
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
    done < "$ASCIIDOC_FILE"
    
    log_success "List formatting check complete"
}

check_placeholder_content() {
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
        local matches=$(grep -n "$pattern" "$ASCIIDOC_FILE" || true)
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
        echo "Status: ${YELLOW}PASS WITH WARNINGS${NC}"
        echo "Warnings: $WARNING_COUNT"
    else
        echo ""
        echo "Status: ${RED}FAIL${NC}"
        echo "Errors: $ERROR_COUNT"
        echo "Warnings: $WARNING_COUNT"
    fi
    
    echo "======================================"
}

main() {
    echo "======================================"
    echo "  AsciiDoc Document Verification"
    echo "======================================"
    echo ""
    
    check_file_exists
    echo ""
    
    check_document_structure
    echo ""
    
    check_required_ecss_sections
    echo ""
    
    check_required_attributes
    echo ""
    
    check_cross_references
    echo ""
    
    check_broken_internal_links
    echo ""
    
    check_table_formatting
    echo ""
    
    check_list_formatting
    echo ""
    
    check_placeholder_content
    echo ""
    
    generate_report
    
    if [[ $ERROR_COUNT -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

main "$@"
