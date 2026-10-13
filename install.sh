#!/bin/bash
#
# WAR-BLOOP-V1 Installation Script for Linux/macOS
# Author: Ian Carter Kulani
# Version: 1.0.0
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Banner
print_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║  ██╗    ██╗ █████╗ ██████╗       ██████╗ ██╗      ██████╗  ██████╗ ██████╗   ║
║  ██║    ██║██╔══██╗██╔══██╗      ██╔══██╗██║     ██╔═══██╗██╔═══██╗██╔══██╗  ║
║  ██║ █╗ ██║███████║██████╔╝█████╗██████╔╝██║     ██║   ██║██║   ██║██████╔╝  ║
║  ██║███╗██║██╔══██║██╔══██╗╚════╝██╔══██╗██║     ██║   ██║██║   ██║██╔═══╝   ║
║  ╚███╔███╔╝██║  ██║██║  ██║      ██████╔╝███████╗╚██████╔╝╚██████╔╝██║       ║
║   ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝       ║
║                                                                              ║
║                    WAR-BLOOP-V1 - Cyber Command Platform                     ║
║                         Author: Ian Carter Kulani                            ║
║                              Version: 1.0.0                                  ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}[!] Not running as root. Some features may require sudo.${NC}"
        SUDO="sudo"
    else
        SUDO=""
    fi
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            OS="debian"
        elif [ -f /etc/redhat-release ]; then
            OS="redhat"
        elif [ -f /etc/arch-release ]; then
            OS="arch"
        elif [ -f /etc/alpine-release ]; then
            OS="alpine"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
    echo -e "${GREEN}[✓] Detected OS: $OS${NC}"
}

# Install system dependencies
install_system_deps() {
    echo -e "\n${BLUE}[*] Installing system dependencies...${NC}"
    
    case $OS in
        debian)
            $SUDO apt-get update
            $SUDO apt-get install -y \
                python3 \
                python3-pip \
                python3-dev \
                python3-venv \
                build-essential \
                libssl-dev \
                libffi-dev \
                libpcap-dev \
                nmap \
                curl \
                wget \
                netcat-openbsd \
                dnsutils \
                traceroute \
                mtr-tiny \
                openssh-client \
                whois \
                git \
                chromium-browser \
                chromium-chromedriver
            ;;
        redhat)
            $SUDO yum install -y \
                python3 \
                python3-pip \
                python3-devel \
                gcc \
                gcc-c++ \
                make \
                openssl-devel \
                libffi-devel \
                libpcap-devel \
                nmap \
                curl \
                wget \
                nc \
                bind-utils \
                traceroute \
                mtr \
                openssh-clients \
                whois \
                git \
                chromium \
                chromedriver
            ;;
        arch)
            $SUDO pacman -Sy --noconfirm \
                python \
                python-pip \
                base-devel \
                openssl \
                libffi \
                libpcap \
                nmap \
                curl \
                wget \
                openbsd-netcat \
                bind \
                traceroute \
                mtr \
                openssh \
                whois \
                git \
                chromium
            ;;
        alpine)
            $SUDO apk add --no-cache \
                python3 \
                py3-pip \
                python3-dev \
                build-base \
                openssl-dev \
                libffi-dev \
                libpcap-dev \
                nmap \
                curl \
                wget \
                netcat-openbsd \
                bind-tools \
                traceroute \
                mtr \
                openssh-client \
                whois \
                git \
                chromium \
                chromium-chromedriver
            ;;
        macos)
            if ! command -v brew &> /dev/null; then
                echo -e "${YELLOW}[!] Homebrew not found. Installing...${NC}"
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install \
                python3 \
                nmap \
                curl \
                wget \
                netcat \
                bind \
                traceroute \
                mtr \
                openssh \
                whois \
                git \
                chromium \
                chromedriver
            ;;
        *)
            echo -e "${RED}[✗] Unsupported OS. Please install dependencies manually.${NC}"
            ;;
    esac
    
    echo -e "${GREEN}[✓] System dependencies installed${NC}"
}

# Setup Python virtual environment
setup_venv() {
    echo -e "\n${BLUE}[*] Setting up Python virtual environment...${NC}"
    
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        echo -e "${GREEN}[✓] Virtual environment created${NC}"
    else
        echo -e "${YELLOW}[!] Virtual environment already exists${NC}"
    fi
    
    source venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip setuptools wheel
    
    echo -e "${GREEN}[✓] Virtual environment activated${NC}"
}

# Install Python dependencies
install_python_deps() {
    echo -e "\n${BLUE}[*] Installing Python dependencies...${NC}"
    
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    else
        echo -e "${YELLOW}[!] requirements.txt not found. Installing core dependencies...${NC}"
        pip install \
            colorama \
            requests \
            psutil \
            cryptography \
            paramiko \
            scapy \
            dnspython \
            python-whois \
            flask \
            flask-socketio \
            flask-cors \
            discord.py \
            telethon \
            slack-sdk \
            selenium \
            webdriver-manager \
            pynput \
            pyperclip \
            pyautogui \
            reportlab \
            matplotlib \
            numpy \
            google-auth \
            google-api-python-client \
            python-dateutil \
            tabulate \
            tqdm \
            pyyaml \
            jinja2
    fi
    
    echo -e "${GREEN}[✓] Python dependencies installed${NC}"
}

# Create directories
create_directories() {
    echo -e "\n${BLUE}[*] Creating directories...${NC}"
    
    mkdir -p .war_bloop_v1/{payloads,scans,phishing_pages,captured_credentials,ssh_keys,traffic_logs,keylogs,keylog_screenshots,dos_logs,agents,c2_logs,modules,network_monitor,keylog_exfil,deployments,domain_hosting,cracking,docker_scans}
    mkdir -p war_bloop_reports/{pdf_reports,graphics,charts}
    
    echo -e "${GREEN}[✓] Directories created${NC}"
}

# Create launcher script
create_launcher() {
    echo -e "\n${BLUE}[*] Creating launcher script...${NC}"
    
    cat > war-bloop << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/venv/bin/activate"
python3 "$SCRIPT_DIR/war_bloop_v1.py" "$@"
EOF
    
    chmod +x war-bloop
    
    echo -e "${GREEN}[✓] Launcher script created${NC}"
}

# Main installation
main() {
    print_banner
    check_root
    detect_os
    
    echo -e "\n${CYAN}${BOLD}Starting WAR-BLOOP-V1 installation...${NC}\n"
    
    install_system_deps
    setup_venv
    install_python_deps
    create_directories
    create_launcher
    
    echo -e "\n${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║              WAR-BLOOP-V1 Installation Complete!                 ║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "\n${CYAN}To run WAR-BLOOP-V1:${NC}"
    echo -e "  ${GREEN}./war-bloop${NC}          # Run the tool"
    echo -e "  ${GREEN}source venv/bin/activate${NC}  # Activate virtual environment"
    echo -e "\n${CYAN}To check requirements:${NC}"
    echo -e "  ${GREEN}python3 requirements-check.py${NC}"
    echo -e "\n${CYAN}To run tests:${NC}"
    echo -e "  ${GREEN}python3 test-commands.py${NC}"
}

main "$@"
