# WAR-BLOOP-V1 Makefile
# Author: Ian Carter Kulani
# Version: 1.0.0

.PHONY: all help install install-dev install-full install-system \
        venv activate clean test lint format check deps \
        run dashboard keylogger phishing dos stop-all \
        docker-build docker-run docker-stop docker-clean \
        docker-compose-up docker-compose-down \
        docs build dist publish security-scan \
        backup restore logs status

# Variables
PYTHON := python3
PIP := pip3
VENV := venv
VENV_BIN := $(VENV)/bin
MAIN_SCRIPT := war_bloop_v1.py
DOCKER_IMAGE := war-bloop-v1
DOCKER_TAG := latest
DOCKER_CONTAINER := war-bloop-v1

# Default target
all: help

# ============================================================================
# HELP
# ============================================================================
help:
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════════════╗"
	@echo "║           WAR-BLOOP-V1 - Makefile Commands                       ║"
	@echo "╚══════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "INSTALLATION:"
	@echo "  make install         - Install core dependencies"
	@echo "  make install-dev     - Install development dependencies"
	@echo "  make install-full    - Install all dependencies"
	@echo "  make install-system  - Install system dependencies"
	@echo "  make venv            - Create virtual environment"
	@echo ""
	@echo "RUNNING:"
	@echo "  make run             - Run WAR-BLOOP-V1"
	@echo "  make dashboard       - Start web dashboard only"
	@echo "  make keylogger       - Start keylogger"
	@echo "  make phishing        - Start phishing server"
	@echo ""
	@echo "TESTING:"
	@echo "  make test            - Run all tests"
	@echo "  make test-commands   - Test all commands"
	@echo "  make check-deps      - Check requirements"
	@echo "  make lint            - Run linters"
	@echo "  make format          - Format code"
	@echo ""
	@echo "DOCKER:"
	@echo "  make docker-build    - Build Docker image"
	@echo "  make docker-run      - Run Docker container"
	@echo "  make docker-stop     - Stop Docker container"
	@echo "  make docker-clean    - Remove Docker resources"
	@echo "  make docker-compose-up   - Start with docker-compose"
	@echo "  make docker-compose-down - Stop docker-compose"
	@echo ""
	@echo "MAINTENANCE:"
	@echo "  make clean           - Clean temporary files"
	@echo "  make backup          - Backup configuration"
	@echo "  make logs            - View logs"
	@echo "  make status          - Show system status"
	@echo ""

# ============================================================================
# INSTALLATION
# ============================================================================
install:
	@echo "[*] Installing core dependencies..."
	$(PIP) install --upgrade pip setuptools wheel
	$(PIP) install -r requirements.txt
	@echo "[+] Core dependencies installed"

install-dev: install
	@echo "[*] Installing development dependencies..."
	$(PIP) install pytest pytest-cov pytest-asyncio black flake8 mypy isort pre-commit
	@echo "[+] Development dependencies installed"

install-full: install
	@echo "[*] Installing all optional dependencies..."
	$(PIP) install discord.py telethon slack-sdk selenium webdriver-manager
	$(PIP) install pynput pyperclip pyautogui
	$(PIP) install reportlab matplotlib numpy
	$(PIP) install google-auth google-api-python-client
	@echo "[+] All dependencies installed"

install-system:
	@echo "[*] Installing system dependencies..."
	@if [ -f /etc/debian_version ]; then \
		sudo apt-get update && sudo apt-get install -y \
			nmap curl wget netcat-openbsd dnsutils traceroute mtr-tiny \
			openssh-client whois chromium chromium-driver; \
	elif [ -f /etc/redhat-release ]; then \
		sudo yum install -y \
			nmap curl wget nc bind-utils traceroute mtr \
			openssh-clients whois chromium chromedriver; \
	elif [ -f /etc/arch-release ]; then \
		sudo pacman -Sy --noconfirm \
			nmap curl wget openbsd-netcat bind traceroute mtr \
			openssh whois chromium; \
	fi
	@echo "[+] System dependencies installed"

venv:
	@echo "[*] Creating virtual environment..."
	$(PYTHON) -m venv $(VENV)
	@echo "[+] Virtual environment created"
	@echo "[!] Activate with: source $(VENV_BIN)/activate"

activate:
	@echo "[*] To activate virtual environment, run:"
	@echo "    source $(VENV_BIN)/activate"

# ============================================================================
# RUNNING
# ============================================================================
run:
	@echo "[*] Starting WAR-BLOOP-V1..."
	@if [ -d "$(VENV)" ]; then \
		$(VENV_BIN)/python $(MAIN_SCRIPT); \
	else \
		$(PYTHON) $(MAIN_SCRIPT); \
	fi

dashboard:
	@echo "[*] Starting web dashboard..."
	@if [ -d "$(VENV)" ]; then \
		$(VENV_BIN)/python -c "from war_bloop_v1 import WarBloopV1; app = WarBloopV1(); app.web.start(); import time; time.sleep(3600)"; \
	else \
		$(PYTHON) -c "from war_bloop_v1 import WarBloopV1; app = WarBloopV1(); app.web.start(); import time; time.sleep(3600)"; \
	fi

# ============================================================================
# TESTING
# ============================================================================
test: test-commands check-deps
	@echo "[+] All tests completed"

test-commands:
	@echo "[*] Running command tests..."
	$(PYTHON) test-commands.py

check-deps:
	@echo "[*] Checking dependencies..."
	$(PYTHON) requirements-check.py

test-pytest:
	@echo "[*] Running pytest..."
	pytest tests/ -v --cov=. --cov-report=html

test-security:
	@echo "[*] Running security tests..."
	bandit -r . -x ./venv,./tests

# ============================================================================
# CODE QUALITY
# ============================================================================
lint:
	@echo "[*] Running linters..."
	flake8 . --exclude=venv,__pycache__,.git --max-line-length=120
	mypy $(MAIN_SCRIPT) --ignore-missing-imports || true
	@echo "[+] Linting complete"

format:
	@echo "[*] Formatting code..."
	black . --exclude=venv --line-length=120
	isort . --skip=venv --profile=black
	@echo "[+] Formatting complete"

check: lint test-commands
	@echo "[+] All checks passed"

security-scan:
	@echo "[*] Running security scan..."
	bandit -r . -x ./venv,./tests -f json -o security-report.json || true
	safety check || true
	@echo "[+] Security scan complete"

# ============================================================================
# DOCKER
# ============================================================================
docker-build:
	@echo "[*] Building Docker image..."
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	@echo "[+] Docker image built: $(DOCKER_IMAGE):$(DOCKER_TAG)"

docker-build-dev:
	@echo "[*] Building development Docker image..."
	docker build -f Dockerfile.dev -t $(DOCKER_IMAGE):dev .
	@echo "[+] Development image built"

docker-run:
	@echo "[*] Running Docker container..."
	docker run -it --rm \
		--name $(DOCKER_CONTAINER) \
		-p 5000:5000 \
		-p 8080:8080 \
		--cap-add=NET_ADMIN \
		--cap-add=NET_RAW \
		-v war-bloop-data:/app/.war_bloop_v1 \
		-v war-bloop-reports:/app/war_bloop_reports \
		$(DOCKER_IMAGE):$(DOCKER_TAG)

docker-run-detached:
	@echo "[*] Running Docker container in background..."
	docker run -d \
		--name $(DOCKER_CONTAINER) \
		-p 5000:5000 \
		-p 8080:8080 \
		--cap-add=NET_ADMIN \
		--cap-add=NET_RAW \
		-v war-bloop-data:/app/.war_bloop_v1 \
		-v war-bloop-reports:/app/war_bloop_reports \
		$(DOCKER_IMAGE):$(DOCKER_TAG)

docker-stop:
	@echo "[*] Stopping Docker container..."
	docker stop $(DOCKER_CONTAINER) || true
	docker rm $(DOCKER_CONTAINER) || true
	@echo "[+] Container stopped"

docker-clean:
	@echo "[*] Cleaning Docker resources..."
	docker stop $(DOCKER_CONTAINER) || true
	docker rm $(DOCKER_CONTAINER) || true
	docker rmi $(DOCKER_IMAGE):$(DOCKER_TAG) || true
	docker volume rm war-bloop-data war-bloop-reports || true
	@echo "[+] Docker resources cleaned"

docker-logs:
	docker logs -f $(DOCKER_CONTAINER)

docker-shell:
	docker exec -it $(DOCKER_CONTAINER) /bin/bash

docker-compose-up:
	@echo "[*] Starting with docker-compose..."
	docker-compose up -d
	@echo "[+] Services started"

docker-compose-down:
	@echo "[*] Stopping docker-compose services..."
	docker-compose down
	@echo "[+] Services stopped"

docker-compose-logs:
	docker-compose logs -f

# ============================================================================
# MAINTENANCE
# ============================================================================
clean:
	@echo "[*] Cleaning temporary files..."
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	rm -rf build/ dist/ .coverage htmlcov/ 2>/dev/null || true
	rm -rf .war_bloop_v1/temp/* 2>/dev/null || true
	@echo "[+] Cleaned"

clean-all: clean
	@echo "[*] Deep cleaning..."
	rm -rf $(VENV) 2>/dev/null || true
	rm -rf .war_bloop_v1 2>/dev/null || true
	rm -rf war_bloop_reports 2>/dev/null || true
	@echo "[+] Deep clean complete"

backup:
	@echo "[*] Backing up configuration..."
	@mkdir -p backups
	@tar -czvf backups/war-bloop-backup-$$(date +%Y%m%d_%H%M%S).tar.gz \
		.war_bloop_v1/ \
		--exclude='.war_bloop_v1/temp' \
		2>/dev/null || true
	@echo "[+] Backup created in backups/"

restore:
	@echo "[*] Available backups:"
	@ls -la backups/*.tar.gz 2>/dev/null || echo "No backups found"
	@echo "[!] To restore: tar -xzvf backups/<backup-file>.tar.gz"

logs:
	@echo "[*] Recent logs:"
	@tail -100 .war_bloop_v1/war_bloop_v1.log 2>/dev/null || echo "No logs found"

status:
	@echo "╔══════════════════════════════════════════════════════════════════╗"
	@echo "║              WAR-BLOOP-V1 System Status                          ║"
	@echo "╚══════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Python Version: $$($(PYTHON) --version 2>&1)"
	@echo "Virtual Env: $$([ -d $(VENV) ] && echo 'Active' || echo 'Not created')"
	@echo ""
	@echo "Docker Status:"
	@docker ps -a --filter "name=$(DOCKER_CONTAINER)" --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || echo "Docker not available"
	@echo ""
	@echo "Directories:"
	@ls -la .war_bloop_v1/ 2>/dev/null | head -20 || echo "Not initialized"
	@echo ""

deps:
	@echo "[*] Current dependencies:"
	$(PIP) list --format=columns 2>/dev/null | head -50

update:
	@echo "[*] Updating dependencies..."
	$(PIP) install --upgrade -r requirements.txt
	@echo "[+] Dependencies updated"

# ============================================================================
# BUILD & DISTRIBUTION
# ============================================================================
build:
	@echo "[*] Building distribution..."
	$(PYTHON) -m build
	@echo "[+] Build complete"

dist: build
	@echo "[*] Distribution files:"
	@ls -la dist/

publish: build
	@echo "[*] Publishing to PyPI..."
	twine upload dist/*
	@echo "[+] Published"

docs:
	@echo "[*] Building documentation..."
	cd docs && make html
	@echo "[+] Documentation built in docs/_build/html/"

# ============================================================================
# QUICK COMMANDS
# ============================================================================
quick: install run

full-setup: install-system venv install-full check-deps
	@echo "[+] Full setup complete!"

dev-setup: venv install-dev
	@echo "[+] Development setup complete!"
	@echo "[!] Activate with: source $(VENV_BIN)/activate"
