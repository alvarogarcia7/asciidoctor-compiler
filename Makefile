.PHONY: all pdf html verify clean watch help docker-build

ASCIIDOC_FILE = icd-template.adoc
PDF_OUTPUT = icd-template.pdf
HTML_OUTPUT = icd-template.html
BUILD_DIR = build
VERIFY_SCRIPT = verify.sh
DOCKER_IMAGE_NAME = asciidoctor-icd
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
		echo '    bundle exec asciidoctor -o /dev/null icd-template.adoc && echo "✓ AsciiDoc syntax is valid"' >> $(VERIFY_SCRIPT); \
		echo 'elif command -v asciidoctor &> /dev/null; then' >> $(VERIFY_SCRIPT); \
		echo '    asciidoctor -o /dev/null icd-template.adoc && echo "✓ AsciiDoc syntax is valid"' >> $(VERIFY_SCRIPT); \
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
