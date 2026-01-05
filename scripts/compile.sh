#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/build"
LOG_DIR="${BUILD_DIR}/logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/compile_${TIMESTAMP}.log"

DEFAULT_INPUT_FILE="icd-template.adoc"
DEFAULT_THEME="default"
DEFAULT_ATTRIBUTES=""

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [INPUT_FILE]

Compile AsciiDoc files to PDF and HTML formats using asciidoctor and asciidoctor-pdf.

OPTIONS:
    -p, --pdf-only          Generate PDF only
    -h, --html-only         Generate HTML only
    -t, --theme THEME       PDF theme to use (default: ${DEFAULT_THEME})
    -a, --attribute ATTR    Additional attributes (can be used multiple times)
                            Format: key=value or key (for boolean)
    -o, --output-dir DIR    Output directory (default: ${BUILD_DIR})
    --help                  Show this help message

ARGUMENTS:
    INPUT_FILE              AsciiDoc input file (default: ${DEFAULT_INPUT_FILE})

EXAMPLES:
    $(basename "$0")
    $(basename "$0") document.adoc
    $(basename "$0") -p document.adoc
    $(basename "$0") -t custom-theme document.adoc
    $(basename "$0") -a revnumber=2.0 -a status=draft document.adoc

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

setup_directories() {
    mkdir -p "$BUILD_DIR"
    mkdir -p "$LOG_DIR"
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

main() {
    local input_file=""
    local pdf_only=false
    local html_only=false
    local theme="$DEFAULT_THEME"
    local output_dir="$BUILD_DIR"
    declare -a ATTRIBUTES=()
    
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
                BUILD_DIR="$output_dir"
                LOG_DIR="${BUILD_DIR}/logs"
                LOG_FILE="${LOG_DIR}/compile_${TIMESTAMP}.log"
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
    
    if [[ -z "$input_file" ]]; then
        input_file="${PROJECT_ROOT}/${DEFAULT_INPUT_FILE}"
    elif [[ ! "$input_file" =~ ^/ ]]; then
        input_file="${PROJECT_ROOT}/${input_file}"
    fi
    
    setup_directories
    
    log "============================================"
    log "AsciiDoc Compilation Script"
    log "============================================"
    log "Timestamp: $(date)"
    log "Input file: $input_file"
    log "Output directory: $BUILD_DIR"
    log "Log file: $LOG_FILE"
    log "============================================"
    
    if ! validate_file "$input_file"; then
        exit 1
    fi
    
    local basename=$(basename "$input_file" .adoc)
    local pdf_output="${BUILD_DIR}/${basename}.pdf"
    local html_output="${BUILD_DIR}/${basename}.html"
    
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
    
    log "============================================"
    
    if [[ $pdf_exit -ne 0 ]] || [[ $html_exit -ne 0 ]]; then
        error "Compilation completed with errors"
        log "PDF exit code: $pdf_exit"
        log "HTML exit code: $html_exit"
        log "Log file: $LOG_FILE"
        exit 1
    else
        log "Compilation completed successfully"
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
