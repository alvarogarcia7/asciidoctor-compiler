#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Support DOCUMENT_FILE via environment variable or command-line argument
# Priority: CLI argument > environment variable > default
DOCUMENT_FILE="${DOCUMENT_FILE:-}"
DEFAULT_INPUT_FILE="icd-template.adoc"
DEFAULT_THEME="default"
DEFAULT_ATTRIBUTES=""

# Generate unique build ID for concurrent builds
BUILD_ID="${BUILD_ID:-$(date +"%Y%m%d_%H%M%S")_$$}"
BUILD_DIR="${BUILD_DIR:-${PROJECT_ROOT}/build}"
BUILD_OUTPUT_DIR="${BUILD_DIR}/${BUILD_ID}"
LOG_DIR="${BUILD_OUTPUT_DIR}/logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/compile_${TIMESTAMP}.log"

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [INPUT_FILE]

Compile AsciiDoc files to PDF and HTML formats using asciidoctor and asciidoctor-pdf.
Supports concurrent builds via unique BUILD_ID and document type detection from template-config.yml.

OPTIONS:
    -p, --pdf-only          Generate PDF only
    -h, --html-only         Generate HTML only
    -t, --theme THEME       PDF theme to use (default: ${DEFAULT_THEME})
    -a, --attribute ATTR    Additional attributes (can be used multiple times)
                            Format: key=value or key (for boolean)
    -o, --output-dir DIR    Output directory (default: ${BUILD_DIR})
    --build-id ID           Unique build identifier for concurrent builds (default: auto-generated)
    --help                  Show this help message

ARGUMENTS:
    INPUT_FILE              AsciiDoc input file (default: ${DEFAULT_INPUT_FILE})
                            Can also be set via DOCUMENT_FILE environment variable

ENVIRONMENT VARIABLES:
    DOCUMENT_FILE           Path to the document file to compile
    BUILD_ID                Unique identifier for this build (supports concurrent builds)
    BUILD_DIR               Base build directory (default: ${PROJECT_ROOT}/build)

EXAMPLES:
    $(basename "$0")
    $(basename "$0") document.adoc
    $(basename "$0") -p document.adoc
    $(basename "$0") -t custom-theme document.adoc
    $(basename "$0") -a revnumber=2.0 -a status=draft document.adoc
    DOCUMENT_FILE=my-doc.adoc $(basename "$0")
    BUILD_ID=custom-123 $(basename "$0") document.adoc

CONCURRENT BUILDS:
    Multiple builds can run simultaneously by using unique BUILD_ID values:
    BUILD_ID=build1 $(basename "$0") doc1.adoc &
    BUILD_ID=build2 $(basename "$0") doc2.adoc &

EOF
}

log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$LOG_FILE"
}

error() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $message" | tee -a "$LOG_FILE" >&2
}

check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        error "Required command '$cmd' not found. Please install it."
        return 1
    fi
    return 0
}

validate_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        error "Input file not found: $file"
        return 1
    fi
    
    if [[ ! -r "$file" ]]; then
        error "Input file not readable: $file"
        return 1
    fi
    
    if [[ ! "$file" =~ \.adoc$ ]]; then
        error "Input file must have .adoc extension: $file"
        return 1
    fi
    
    return 0
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
            break
        fi
        search_dir="$(dirname "$search_dir")"
    done
    
    # Parse document type from template-config.yml
    if [[ -f "$config_file" ]]; then
        log "Found template config: $config_file"
        
        # Try to extract document-type from the YAML config
        # Look for build.custom-attributes.document-type or metadata.document-type
        if command -v grep &> /dev/null; then
            local extracted_type=""
            
            # Try custom-attributes.document-type first
            extracted_type=$(grep -A 50 "custom-attributes:" "$config_file" | grep "document-type:" | head -1 | sed 's/.*document-type:[[:space:]]*//;s/[[:space:]]*$//' | tr -d '"' || true)
            
            # If not found, try template.name
            if [[ -z "$extracted_type" ]]; then
                extracted_type=$(grep "name:" "$config_file" | grep -i "template" | head -1 | sed 's/.*name:[[:space:]]*//;s/[[:space:]]*$//' | tr -d '"' | awk '{print $1}' || true)
            fi
            
            if [[ -n "$extracted_type" ]]; then
                doc_type=$(echo "$extracted_type" | tr '[:upper:]' '[:lower:]')
                log "Detected document type: $doc_type"
            fi
        fi
    else
        log "No template-config.yml found, using default document type: $doc_type"
    fi
    
    echo "$doc_type"
}

load_config_attributes() {
    local input_file="$1"
    local input_dir="$(dirname "$input_file")"
    local config_file="${input_dir}/template-config.yml"
    
    # Search for template-config.yml
    local search_dir="$input_dir"
    while [[ "$search_dir" != "/" && "$search_dir" != "." ]]; do
        if [[ -f "${search_dir}/template-config.yml" ]]; then
            config_file="${search_dir}/template-config.yml"
            break
        fi
        search_dir="$(dirname "$search_dir")"
    done
    
    declare -a config_attrs=()
    
    if [[ -f "$config_file" ]]; then
        log "Loading attributes from config: $config_file"
        
        # Extract common attributes from config
        # This is a basic extraction; for complex configs, consider using yq or similar
        local in_attributes=false
        while IFS= read -r line; do
            if [[ "$line" =~ ^[[:space:]]*custom-attributes: ]]; then
                in_attributes=true
                continue
            elif [[ "$in_attributes" == true ]]; then
                if [[ "$line" =~ ^[[:space:]]{2,}[a-zA-Z] ]]; then
                    # Extract key: value pairs
                    local key=$(echo "$line" | sed 's/^[[:space:]]*//;s/:.*//')
                    local value=$(echo "$line" | sed 's/^[^:]*:[[:space:]]*//;s/[[:space:]]*$//' | tr -d '"')
                    if [[ -n "$key" && -n "$value" && "$value" != "true" && "$value" != "false" ]]; then
                        config_attrs+=("${key}=${value}")
                    fi
                elif [[ "$line" =~ ^[[:space:]]*[a-zA-Z-]+: ]] && [[ ! "$line" =~ ^[[:space:]]{2,} ]]; then
                    # End of custom-attributes section
                    break
                fi
            fi
        done < "$config_file"
    fi
    
    printf '%s\n' "${config_attrs[@]}"
}

setup_directories() {
    mkdir -p "$BUILD_OUTPUT_DIR"
    mkdir -p "$LOG_DIR"
    log "Build output directory: $BUILD_OUTPUT_DIR"
}

build_attribute_args() {
    local args=""
    for attr in "${ATTRIBUTES[@]}"; do
        args="${args} -a ${attr}"
    done
    echo "$args"
}

compile_pdf() {
    local input_file="$1"
    local output_file="$2"
    local theme="$3"
    local attr_args="$4"
    
    log "Starting PDF compilation..."
    log "Input: $input_file"
    log "Output: $output_file"
    log "Theme: $theme"
    
    if ! check_command "asciidoctor-pdf"; then
        return 1
    fi
    
    local cmd="asciidoctor-pdf"
    cmd="${cmd} -r asciidoctor-diagram"
    cmd="${cmd} -a pdf-theme=${theme}"
    cmd="${cmd}${attr_args}"
    cmd="${cmd} -o \"${output_file}\""
    cmd="${cmd} \"${input_file}\""
    
    log "Executing: $cmd"
    
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        log "PDF compilation successful: $output_file"
        return 0
    else
        local exit_code=$?
        error "PDF compilation failed with exit code $exit_code"
        error "Check log file for details: $LOG_FILE"
        return $exit_code
    fi
}

compile_html() {
    local input_file="$1"
    local output_file="$2"
    local attr_args="$3"
    
    log "Starting HTML compilation..."
    log "Input: $input_file"
    log "Output: $output_file"
    
    if ! check_command "asciidoctor"; then
        return 1
    fi
    
    local cmd="asciidoctor"
    cmd="${cmd} -r asciidoctor-diagram"
    cmd="${cmd}${attr_args}"
    cmd="${cmd} -o \"${output_file}\""
    cmd="${cmd} \"${input_file}\""
    
    log "Executing: $cmd"
    
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        log "HTML compilation successful: $output_file"
        return 0
    else
        local exit_code=$?
        error "HTML compilation failed with exit code $exit_code"
        error "Check log file for details: $LOG_FILE"
        return $exit_code
    fi
}

create_symlink_to_latest() {
    local basename="$1"
    local latest_dir="${BUILD_DIR}/latest"
    
    # Create latest directory
    mkdir -p "$latest_dir"
    
    # Create symlinks to the latest build outputs
    if [[ -f "${BUILD_OUTPUT_DIR}/${basename}.pdf" ]]; then
        ln -sf "../${BUILD_ID}/${basename}.pdf" "${latest_dir}/${basename}.pdf"
        log "Created symlink: ${latest_dir}/${basename}.pdf -> ${BUILD_OUTPUT_DIR}/${basename}.pdf"
    fi
    
    if [[ -f "${BUILD_OUTPUT_DIR}/${basename}.html" ]]; then
        ln -sf "../${BUILD_ID}/${basename}.html" "${latest_dir}/${basename}.html"
        log "Created symlink: ${latest_dir}/${basename}.html -> ${BUILD_OUTPUT_DIR}/${basename}.html"
    fi
}

main() {
    local input_file=""
    local pdf_only=false
    local html_only=false
    local theme="$DEFAULT_THEME"
    local output_dir=""
    local custom_build_id=""
    declare -a ATTRIBUTES=()
    
    # Parse command-line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--pdf-only)
                pdf_only=true
                shift
                ;;
            -h|--html-only)
                html_only=true
                shift
                ;;
            -t|--theme)
                theme="$2"
                shift 2
                ;;
            -a|--attribute)
                ATTRIBUTES+=("$2")
                shift 2
                ;;
            -o|--output-dir)
                output_dir="$2"
                shift 2
                ;;
            --build-id)
                custom_build_id="$2"
                shift 2
                ;;
            --help)
                show_usage
                exit 0
                ;;
            -*)
                error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                if [[ -z "$input_file" ]]; then
                    input_file="$1"
                else
                    error "Multiple input files specified"
                    show_usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Update BUILD_ID if custom one provided
    if [[ -n "$custom_build_id" ]]; then
        BUILD_ID="$custom_build_id"
        BUILD_OUTPUT_DIR="${BUILD_DIR}/${BUILD_ID}"
        LOG_DIR="${BUILD_OUTPUT_DIR}/logs"
        LOG_FILE="${LOG_DIR}/compile_${TIMESTAMP}.log"
    fi
    
    # Update BUILD_DIR if custom output directory provided
    if [[ -n "$output_dir" ]]; then
        BUILD_DIR="$output_dir"
        BUILD_OUTPUT_DIR="${BUILD_DIR}/${BUILD_ID}"
        LOG_DIR="${BUILD_OUTPUT_DIR}/logs"
        LOG_FILE="${LOG_DIR}/compile_${TIMESTAMP}.log"
    fi
    
    # Determine input file: CLI arg > DOCUMENT_FILE env var > default
    if [[ -z "$input_file" ]]; then
        if [[ -n "$DOCUMENT_FILE" ]]; then
            input_file="$DOCUMENT_FILE"
            log "Using DOCUMENT_FILE environment variable: $input_file"
        else
            input_file="${PROJECT_ROOT}/${DEFAULT_INPUT_FILE}"
        fi
    fi
    
    # Convert relative path to absolute
    if [[ ! "$input_file" =~ ^/ ]]; then
        input_file="${PROJECT_ROOT}/${input_file}"
    fi
    
    setup_directories
    
    log "============================================"
    log "AsciiDoc Compilation Script"
    log "============================================"
    log "Timestamp: $(date)"
    log "Build ID: $BUILD_ID"
    log "Input file: $input_file"
    log "Output directory: $BUILD_OUTPUT_DIR"
    log "Log file: $LOG_FILE"
    log "============================================"
    
    if ! validate_file "$input_file"; then
        exit 1
    fi
    
    # Detect document type
    local doc_type=$(detect_document_type "$input_file")
    log "Document type: $doc_type"
    
    # Load configuration attributes
    local config_attrs=$(load_config_attributes "$input_file")
    if [[ -n "$config_attrs" ]]; then
        log "Loaded configuration attributes:"
        while IFS= read -r attr; do
            if [[ -n "$attr" ]]; then
                ATTRIBUTES+=("$attr")
                log "  - $attr"
            fi
        done <<< "$config_attrs"
    fi
    
    local basename=$(basename "$input_file" .adoc)
    local pdf_output="${BUILD_OUTPUT_DIR}/${basename}.pdf"
    local html_output="${BUILD_OUTPUT_DIR}/${basename}.html"
    
    local attr_args=$(build_attribute_args)
    
    local pdf_exit=0
    local html_exit=0
    
    if [[ "$html_only" == false ]]; then
        if ! compile_pdf "$input_file" "$pdf_output" "$theme" "$attr_args"; then
            pdf_exit=$?
        fi
    fi
    
    if [[ "$pdf_only" == false ]]; then
        if ! compile_html "$input_file" "$html_output" "$attr_args"; then
            html_exit=$?
        fi
    fi
    
    # Create symlinks to latest build
    create_symlink_to_latest "$basename"
    
    log "============================================"
    
    if [[ $pdf_exit -ne 0 ]] || [[ $html_exit -ne 0 ]]; then
        error "Compilation completed with errors"
        log "PDF exit code: $pdf_exit"
        log "HTML exit code: $html_exit"
        log "Log file: $LOG_FILE"
        exit 1
    else
        log "Compilation completed successfully"
        log "Build ID: $BUILD_ID"
        log "Log file: $LOG_FILE"
        
        if [[ "$html_only" == false ]]; then
            log "PDF output: $pdf_output"
        fi
        
        if [[ "$pdf_only" == false ]]; then
            log "HTML output: $html_output"
        fi
        
        exit 0
    fi
}

main "$@"
