#!/bin/bash

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script version
SCRIPT_VERSION="1.0.0"

# Default values
TEMPLATES_DIR="templates"
CI_TEMPLATES_DIR="ci-templates"
DEFAULT_AUTHOR="${USER}"
DEFAULT_DATE=$(date +%Y-%m-%d)
DEFAULT_REVISION="0.1"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
}

# Function to check if templates directory exists
check_templates() {
    if [ ! -d "$TEMPLATES_DIR" ]; then
        print_warning "Templates directory not found. Creating it with default ICD template..."
        mkdir -p "$TEMPLATES_DIR"
        
        # Copy the current icd-template.adoc to templates directory if it exists
        if [ -f "icd-template.adoc" ]; then
            cp "icd-template.adoc" "$TEMPLATES_DIR/icd-template.adoc"
            print_success "Created templates/icd-template.adoc"
        else
            print_error "No icd-template.adoc found. Please create templates manually."
            exit 1
        fi
    fi
}

# Function to prompt for user input with default value
prompt_with_default() {
    local prompt_message="$1"
    local default_value="$2"
    local user_input
    
    if [ -n "$default_value" ]; then
        read -p "$(echo -e ${CYAN}${prompt_message}${NC} [${default_value}]: )" user_input
        echo "${user_input:-$default_value}"
    else
        read -p "$(echo -e ${CYAN}${prompt_message}${NC}: )" user_input
        echo "$user_input"
    fi
}

# Function to prompt for project type
prompt_project_type() {
    echo ""
    print_header "Project Type Selection"
    echo ""
    echo "  1) ICD     - Interface Control Document"
    echo "  2) SSDLC   - Secure Software Development Lifecycle"
    echo "  3) Generic - General AsciiDoc documentation"
    echo ""
    
    while true; do
        read -p "$(echo -e ${CYAN}Select project type${NC} [1-3]: )" project_type_input
        
        case $project_type_input in
            1|ICD|icd)
                PROJECT_TYPE="ICD"
                TEMPLATE_FILE="icd-template.adoc"
                CI_TEMPLATE="ci-templates/.gitlab-ci-icd.yml"
                break
                ;;
            2|SSDLC|ssdlc)
                PROJECT_TYPE="SSDLC"
                TEMPLATE_FILE="ssdlc-template.adoc"
                CI_TEMPLATE="ci-templates/.gitlab-ci-ssdlc.yml"
                break
                ;;
            3|Generic|generic|GENERIC)
                PROJECT_TYPE="Generic"
                TEMPLATE_FILE="generic-template.adoc"
                CI_TEMPLATE="ci-templates/.gitlab-ci-generic.yml"
                break
                ;;
            *)
                print_error "Invalid selection. Please choose 1, 2, or 3."
                ;;
        esac
    done
    
    print_success "Selected project type: $PROJECT_TYPE"
}

# Function to prompt for document metadata
prompt_metadata() {
    echo ""
    print_header "Document Metadata"
    echo ""
    
    # Document name
    DOCUMENT_NAME=$(prompt_with_default "Document name (without extension)" "my-document")
    
    # Document title
    DOCUMENT_TITLE=$(prompt_with_default "Document title" "$DOCUMENT_NAME")
    
    # Document ID
    DOCUMENT_ID=$(prompt_with_default "Document ID" "DOC-$(date +%Y%m%d)-001")
    
    # Author
    AUTHOR=$(prompt_with_default "Author name" "$DEFAULT_AUTHOR")
    
    # Organization
    ORGANIZATION=$(prompt_with_default "Organization name" "My Organization")
    
    # Project name
    PROJECT_NAME=$(prompt_with_default "Project name" "$DOCUMENT_NAME")
    
    # Revision
    REVISION=$(prompt_with_default "Initial revision" "$DEFAULT_REVISION")
    
    # Date
    REVISION_DATE=$(prompt_with_default "Revision date" "$DEFAULT_DATE")
    
    # Classification
    CLASSIFICATION=$(prompt_with_default "Classification level" "UNCLASSIFIED")
    
    # Distribution
    DISTRIBUTION=$(prompt_with_default "Distribution statement" "Approved for public release")
    
    # Contract number (optional)
    CONTRACT_NUMBER=$(prompt_with_default "Contract number (optional)" "N/A")
    
    # Status
    DOCUMENT_STATUS=$(prompt_with_default "Document status" "Draft")
    
    echo ""
    print_success "Metadata collected successfully"
}

# Function to display confirmation summary
display_summary() {
    echo ""
    print_header "Configuration Summary"
    echo ""
    echo "  Project Type:      $PROJECT_TYPE"
    echo "  Document Name:     $DOCUMENT_NAME"
    echo "  Document Title:    $DOCUMENT_TITLE"
    echo "  Document ID:       $DOCUMENT_ID"
    echo "  Author:            $AUTHOR"
    echo "  Organization:      $ORGANIZATION"
    echo "  Project Name:      $PROJECT_NAME"
    echo "  Revision:          $REVISION"
    echo "  Date:              $REVISION_DATE"
    echo "  Classification:    $CLASSIFICATION"
    echo "  Distribution:      $DISTRIBUTION"
    echo "  Contract Number:   $CONTRACT_NUMBER"
    echo "  Status:            $DOCUMENT_STATUS"
    echo ""
    
    read -p "$(echo -e ${CYAN}Proceed with these settings?${NC} [Y/n]: )" confirm
    case $confirm in
        [Nn]*)
            print_warning "Operation cancelled by user"
            exit 0
            ;;
        *)
            print_success "Confirmed. Proceeding with project initialization..."
            ;;
    esac
}

# Function to copy template file
copy_template() {
    local source_template
    local target_file="${DOCUMENT_NAME}.adoc"
    
    # Determine source template path
    if [ -f "$TEMPLATES_DIR/$TEMPLATE_FILE" ]; then
        source_template="$TEMPLATES_DIR/$TEMPLATE_FILE"
    elif [ -f "$TEMPLATE_FILE" ]; then
        source_template="$TEMPLATE_FILE"
    elif [ -f "icd-template.adoc" ]; then
        # Fallback to icd-template.adoc if specific template not found
        source_template="icd-template.adoc"
        print_warning "Template $TEMPLATE_FILE not found, using icd-template.adoc as fallback"
    else
        print_error "No template file found"
        exit 1
    fi
    
    # Check if target file already exists
    if [ -f "$target_file" ]; then
        print_warning "File $target_file already exists"
        read -p "$(echo -e ${YELLOW}Overwrite?${NC} [y/N]: )" overwrite
        case $overwrite in
            [Yy]*)
                print_info "Overwriting $target_file..."
                ;;
            *)
                print_error "Cannot proceed: $target_file already exists"
                exit 1
                ;;
        esac
    fi
    
    print_info "Copying template from $source_template to $target_file..."
    cp "$source_template" "$target_file"
    print_success "Template copied successfully"
    
    echo "$target_file"
}

# Function to copy GitLab CI template
copy_ci_template() {
    if [ ! -f "$CI_TEMPLATE" ]; then
        print_warning "CI template not found: $CI_TEMPLATE"
        return
    fi
    
    local target_ci=".gitlab-ci.yml"
    
    if [ -f "$target_ci" ]; then
        print_warning "File $target_ci already exists"
        read -p "$(echo -e ${YELLOW}Overwrite?${NC} [y/N]: )" overwrite
        case $overwrite in
            [Yy]*)
                print_info "Overwriting $target_ci..."
                ;;
            *)
                print_warning "Skipping CI template copy"
                return
                ;;
        esac
    fi
    
    print_info "Copying CI template from $CI_TEMPLATE to $target_ci..."
    cp "$CI_TEMPLATE" "$target_ci"
    print_success "CI template copied successfully"
}

# Function to generate customized Makefile
generate_makefile() {
    local makefile_path="Makefile"
    local asciidoc_file="${DOCUMENT_NAME}.adoc"
    local pdf_output="${DOCUMENT_NAME}.pdf"
    local html_output="${DOCUMENT_NAME}.html"
    
    if [ -f "$makefile_path" ]; then
        print_warning "Makefile already exists"
        read -p "$(echo -e ${YELLOW}Overwrite?${NC} [y/N]: )" overwrite
        case $overwrite in
            [Yy]*)
                print_info "Overwriting Makefile..."
                ;;
            *)
                print_warning "Skipping Makefile generation"
                return
                ;;
        esac
    fi
    
    print_info "Generating customized Makefile..."
    
    cat > "$makefile_path" << 'EOF'
.PHONY: all pdf html verify clean watch help docker-build

ASCIIDOC_FILE = __ASCIIDOC_FILE__
PDF_OUTPUT = __PDF_OUTPUT__
HTML_OUTPUT = __HTML_OUTPUT__
BUILD_DIR = build
VERIFY_SCRIPT = verify.sh
DOCKER_IMAGE_NAME = asciidoctor-__PROJECT_TYPE_LOWER__
DOCKER_IMAGE_TAG = latest

# Detect if we're in Docker or using bundler
ifeq ($(shell command -v bundle 2> /dev/null && [ -f Gemfile.lock ] && echo yes),yes)
	ASCIIDOCTOR = bundle exec asciidoctor
	ASCIIDOCTOR_PDF = bundle exec asciidoctor-pdf
else
	ASCIIDOCTOR = asciidoctor
	ASCIIDOCTOR_PDF = asciidoctor-pdf
endif

all: pdf html

pdf: $(BUILD_DIR)/$(PDF_OUTPUT)

html: $(BUILD_DIR)/$(HTML_OUTPUT)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/$(PDF_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating PDF..."
	@$(ASCIIDOCTOR_PDF) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(PDF_OUTPUT)
	@echo "PDF generated: $(BUILD_DIR)/$(PDF_OUTPUT)"

$(BUILD_DIR)/$(HTML_OUTPUT): $(ASCIIDOC_FILE) | $(BUILD_DIR)
	@echo "Generating HTML..."
	@$(ASCIIDOCTOR) -r asciidoctor-diagram $(ASCIIDOC_FILE) -o $(BUILD_DIR)/$(HTML_OUTPUT)
	@echo "HTML generated: $(BUILD_DIR)/$(HTML_OUTPUT)"

verify:
	@if [ -f $(VERIFY_SCRIPT) ]; then \
		echo "Running verification script..."; \
		./$(VERIFY_SCRIPT); \
	else \
		echo "Verification script not found: $(VERIFY_SCRIPT)"; \
		echo "Creating basic verification script..."; \
		echo '#!/bin/bash' > $(VERIFY_SCRIPT); \
		echo 'set -e' >> $(VERIFY_SCRIPT); \
		echo 'echo "Verifying AsciiDoc syntax..."' >> $(VERIFY_SCRIPT); \
		echo 'if command -v bundle &> /dev/null && [ -f Gemfile.lock ] && bundle exec asciidoctor --version &> /dev/null; then' >> $(VERIFY_SCRIPT); \
		echo '    bundle exec asciidoctor -o /dev/null $(ASCIIDOC_FILE) && echo "✓ AsciiDoc syntax is valid"' >> $(VERIFY_SCRIPT); \
		echo 'elif command -v asciidoctor &> /dev/null; then' >> $(VERIFY_SCRIPT); \
		echo '    asciidoctor -o /dev/null $(ASCIIDOC_FILE) && echo "✓ AsciiDoc syntax is valid"' >> $(VERIFY_SCRIPT); \
		echo 'else' >> $(VERIFY_SCRIPT); \
		echo '    echo "✗ asciidoctor not found, skipping syntax check"' >> $(VERIFY_SCRIPT); \
		echo '    exit 1' >> $(VERIFY_SCRIPT); \
		echo 'fi' >> $(VERIFY_SCRIPT); \
		echo 'echo "Verification complete!"' >> $(VERIFY_SCRIPT); \
		chmod +x $(VERIFY_SCRIPT); \
		./$(VERIFY_SCRIPT); \
	fi

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Build artifacts removed."

watch:
	@echo "Watching for changes to $(ASCIIDOC_FILE)..."
	@if command -v inotifywait &> /dev/null; then \
		echo "Using inotifywait for file monitoring..."; \
		while true; do \
			inotifywait -e modify,create,delete $(ASCIIDOC_FILE) && \
			$(MAKE) all; \
		done \
	elif command -v entr &> /dev/null; then \
		echo "Using entr for file monitoring..."; \
		echo $(ASCIIDOC_FILE) | entr -c $(MAKE) all; \
	else \
		echo "Error: Neither inotifywait nor entr found."; \
		echo "Please install one of the following:"; \
		echo "  - inotify-tools (for inotifywait): apt install inotify-tools"; \
		echo "  - entr: apt install entr or brew install entr"; \
		exit 1; \
	fi

docker-build:
	@echo "Building Docker image..."
	@docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .
	@echo "Docker image built: $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)"

help:
	@echo "Available targets:"
	@echo "  make all          - Compile both PDF and HTML (default)"
	@echo "  make pdf          - Compile PDF only"
	@echo "  make html         - Compile HTML only"
	@echo "  make verify       - Run verification script"
	@echo "  make clean        - Remove build artifacts"
	@echo "  make watch        - Auto-compile on changes (requires inotifywait or entr)"
	@echo "  make docker-build - Build Docker image"
	@echo "  make help         - Show this help message"
EOF

    # Replace placeholders with actual values
    sed -i.bak "s|__ASCIIDOC_FILE__|$asciidoc_file|g" "$makefile_path"
    sed -i.bak "s|__PDF_OUTPUT__|$pdf_output|g" "$makefile_path"
    sed -i.bak "s|__HTML_OUTPUT__|$html_output|g" "$makefile_path"
    sed -i.bak "s|__PROJECT_TYPE_LOWER__|$(echo $PROJECT_TYPE | tr '[:upper:]' '[:lower:]')|g" "$makefile_path"
    rm -f "${makefile_path}.bak"
    
    print_success "Makefile generated successfully"
}

# Function to update template placeholders
update_placeholders() {
    local target_file="$1"
    
    print_info "Updating placeholders in $target_file..."
    
    # Create a temporary file for safe replacement
    local temp_file="${target_file}.tmp"
    cp "$target_file" "$temp_file"
    
    # Replace document title (first line)
    sed -i.bak "1s/.*/= $DOCUMENT_TITLE/" "$temp_file"
    
    # Replace attributes
    sed -i.bak "s/:title:.*/:title: $DOCUMENT_TITLE/" "$temp_file"
    sed -i.bak "s/:author:.*/:author: $AUTHOR/" "$temp_file"
    sed -i.bak "s/:revnumber:.*/:revnumber: $REVISION/" "$temp_file"
    
    # Replace document metadata
    sed -i.bak "s|:document-title:.*|:document-title: $DOCUMENT_TITLE|" "$temp_file"
    sed -i.bak "s|:document-id:.*|:document-id: $DOCUMENT_ID|" "$temp_file"
    sed -i.bak "s|:project-name:.*|:project-name: $PROJECT_NAME|" "$temp_file"
    sed -i.bak "s|:classification:.*|:classification: $CLASSIFICATION|" "$temp_file"
    sed -i.bak "s|:distribution:.*|:distribution: $DISTRIBUTION|" "$temp_file"
    sed -i.bak "s|:contract-number:.*|:contract-number: $CONTRACT_NUMBER|" "$temp_file"
    sed -i.bak "s|:organization:.*|:organization: $ORGANIZATION|" "$temp_file"
    
    # Replace bracketed placeholders
    sed -i.bak "s/\[Author Name\]/$AUTHOR/g" "$temp_file"
    sed -i.bak "s/\[Document ID\]/$DOCUMENT_ID/g" "$temp_file"
    sed -i.bak "s/\[Project Name\]/$PROJECT_NAME/g" "$temp_file"
    sed -i.bak "s/\[Classification Level\]/$CLASSIFICATION/g" "$temp_file"
    sed -i.bak "s/\[Distribution Statement\]/$DISTRIBUTION/g" "$temp_file"
    sed -i.bak "s/\[Contract Number\]/$CONTRACT_NUMBER/g" "$temp_file"
    sed -i.bak "s/\[Organization Name\]/$ORGANIZATION/g" "$temp_file"
    sed -i.bak "s/\[Draft\/Review\/Approved\/Released\]/$DOCUMENT_STATUS/g" "$temp_file"
    sed -i.bak "s/\[Date\]/$REVISION_DATE/g" "$temp_file"
    sed -i.bak "s/\[Author\]/$AUTHOR/g" "$temp_file"
    
    # Update document type based on project type
    if [ "$PROJECT_TYPE" = "SSDLC" ]; then
        sed -i.bak "s|:document-type:.*|:document-type: SSDLC|" "$temp_file"
        sed -i.bak "s|Interface Control Document|Secure Software Development Lifecycle Document|g" "$temp_file"
    elif [ "$PROJECT_TYPE" = "Generic" ]; then
        sed -i.bak "s|:document-type:.*|:document-type: Documentation|" "$temp_file"
    fi
    
    # Remove backup files
    rm -f "${temp_file}.bak"
    
    # Move temp file to target
    mv "$temp_file" "$target_file"
    
    print_success "Placeholders updated successfully"
}

# Function to update CI variables
update_ci_variables() {
    if [ ! -f ".gitlab-ci.yml" ]; then
        return
    fi
    
    print_info "Updating GitLab CI variables..."
    
    local asciidoc_file="${DOCUMENT_NAME}.adoc"
    local output_name="${DOCUMENT_NAME}"
    
    # Update variables in .gitlab-ci.yml
    sed -i.bak "s|DOCUMENT_FILE:.*|DOCUMENT_FILE: \"$asciidoc_file\"|" .gitlab-ci.yml
    sed -i.bak "s|OUTPUT_NAME:.*|OUTPUT_NAME: \"$output_name\"|" .gitlab-ci.yml
    
    # Remove backup file
    rm -f .gitlab-ci.yml.bak
    
    print_success "CI variables updated successfully"
}

# Function to create project structure
create_project_structure() {
    print_info "Creating project directory structure..."
    
    # Create directories
    mkdir -p build
    mkdir -p images
    mkdir -p scripts
    
    print_success "Project structure created"
}

# Function to display final instructions
display_final_instructions() {
    echo ""
    print_header "Project Initialization Complete!"
    echo ""
    echo "  Document file:     ${GREEN}${DOCUMENT_NAME}.adoc${NC}"
    echo "  Makefile:          ${GREEN}Makefile${NC}"
    
    if [ -f ".gitlab-ci.yml" ]; then
        echo "  GitLab CI:         ${GREEN}.gitlab-ci.yml${NC}"
    fi
    
    echo ""
    print_info "Next steps:"
    echo ""
    echo "  1. Review and edit ${DOCUMENT_NAME}.adoc"
    echo "  2. Build the document:"
    echo "     ${CYAN}make all${NC}        - Build both PDF and HTML"
    echo "     ${CYAN}make pdf${NC}        - Build PDF only"
    echo "     ${CYAN}make html${NC}       - Build HTML only"
    echo ""
    echo "  3. Verify the document:"
    echo "     ${CYAN}make verify${NC}     - Run syntax verification"
    echo ""
    echo "  4. Watch for changes (auto-rebuild):"
    echo "     ${CYAN}make watch${NC}      - Auto-compile on file changes"
    echo ""
    
    if [ -f ".gitlab-ci.yml" ]; then
        print_info "GitLab CI pipeline is configured and ready to use"
    fi
    
    echo ""
    print_success "Happy documenting! 📝"
    echo ""
}

# Main script execution
main() {
    print_header "AsciiDoc Project Initialization Script v${SCRIPT_VERSION}"
    
    # Check for templates
    check_templates
    
    # Prompt for project type
    prompt_project_type
    
    # Prompt for metadata
    prompt_metadata
    
    # Display summary and confirm
    display_summary
    
    # Copy template
    target_file=$(copy_template)
    
    # Update placeholders in the copied template
    update_placeholders "$target_file"
    
    # Copy CI template
    copy_ci_template
    
    # Update CI variables
    update_ci_variables
    
    # Generate Makefile
    generate_makefile
    
    # Create project structure
    create_project_structure
    
    # Display final instructions
    display_final_instructions
}

# Run main function
main
