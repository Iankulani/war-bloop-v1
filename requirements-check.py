#!/usr/bin/env python3
"""
WAR-BLOOP-V1 Requirements Checker
Verifies all dependencies are installed and available
"""

import sys
import subprocess
import importlib
import shutil
from pathlib import Path

# Color codes
class Colors:
    PRIMARY = '\033[94m'
    SUCCESS = '\033[92m'
    WARNING = '\033[93m'
    ERROR = '\033[91m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

def print_header():
    print(f"""
{Colors.PRIMARY}╔══════════════════════════════════════════════════════════════════════════════╗
║{Colors.BOLD}              WAR-BLOOP-V1 - Requirements Checker                              {Colors.PRIMARY}║
╚══════════════════════════════════════════════════════════════════════════════╝{Colors.RESET}
""")

def check_python_version():
    """Check Python version"""
    version = sys.version_info
    print(f"{Colors.PRIMARY}[*] Checking Python version...{Colors.RESET}")
    
    if version.major >= 3 and version.minor >= 7:
        print(f"{Colors.SUCCESS}[✓] Python {version.major}.{version.minor}.{version.micro} - OK{Colors.RESET}")
        return True
    else:
        print(f"{Colors.ERROR}[✗] Python {version.major}.{version.minor}.{version.micro} - Requires 3.7+{Colors.RESET}")
        return False

def check_python_package(package_name, import_name=None):
    """Check if a Python package is installed"""
    if import_name is None:
        import_name = package_name
    
    try:
        importlib.import_module(import_name)
        return True, None
    except ImportError as e:
        return False, str(e)

def check_system_tool(tool_name):
    """Check if a system tool is available"""
    return shutil.which(tool_name) is not None

def check_python_packages():
    """Check all required Python packages"""
    print(f"\n{Colors.PRIMARY}[*] Checking Python packages...{Colors.RESET}")
    
    packages = [
        # Core
        ('colorama', 'colorama', 'Terminal colors'),
        ('requests', 'requests', 'HTTP library'),
        ('psutil', 'psutil', 'System monitoring'),
        ('cryptography', 'cryptography', 'Encryption'),
        ('paramiko', 'paramiko', 'SSH client'),
        ('scapy', 'scapy', 'Packet manipulation'),
        ('dnspython', 'dns', 'DNS resolution'),
        ('python-whois', 'whois', 'WHOIS lookup'),
        
        # Web
        ('flask', 'flask', 'Web framework'),
        ('flask-socketio', 'flask_socketio', 'WebSocket support'),
        ('flask-cors', 'flask_cors', 'CORS support'),
        
        # Bots
        ('discord.py', 'discord', 'Discord bot'),
        ('telethon', 'telethon', 'Telegram bot'),
        ('slack-sdk', 'slack_sdk', 'Slack bot'),
        ('selenium', 'selenium', 'Browser automation'),
        ('webdriver-manager', 'webdriver_manager', 'WebDriver manager'),
        
        # Keylogger
        ('pynput', 'pynput', 'Keyboard/mouse control'),
        ('pyperclip', 'pyperclip', 'Clipboard access'),
        ('pyautogui', 'pyautogui', 'GUI automation'),
        
        # PDF/Graphics
        ('reportlab', 'reportlab', 'PDF generation'),
        ('matplotlib', 'matplotlib', 'Plotting'),
        ('numpy', 'numpy', 'Numerical computing'),
        
        # Google
        ('google-auth', 'google.auth', 'Google authentication'),
        ('google-api-python-client', 'googleapiclient', 'Google APIs'),
        
        # Utilities
        ('python-dateutil', 'dateutil', 'Date utilities'),
        ('tabulate', 'tabulate', 'Table formatting'),
        ('tqdm', 'tqdm', 'Progress bars'),
        ('pyyaml', 'yaml', 'YAML parser'),
        ('jinja2', 'jinja2', 'Template engine'),
    ]
    
    available = []
    missing = []
    
    for package_name, import_name, description in packages:
        success, error = check_python_package(package_name, import_name)
        if success:
            print(f"{Colors.SUCCESS}[✓] {package_name:<30} - {description}{Colors.RESET}")
            available.append(package_name)
        else:
            print(f"{Colors.ERROR}[✗] {package_name:<30} - {description} (MISSING){Colors.RESET}")
            missing.append(package_name)
    
    return available, missing

def check_system_tools():
    """Check system tools"""
    print(f"\n{Colors.PRIMARY}[*] Checking system tools...{Colors.RESET}")
    
    tools = [
        ('ping', 'Network connectivity test', True),
        ('nmap', 'Network scanning', True),
        ('curl', 'HTTP requests', True),
        ('wget', 'File downloads', True),
        ('nc', 'Netcat network tool', False),
        ('ncat', 'Ncat network tool', False),
        ('dig', 'DNS lookup', False),
        ('nslookup', 'DNS lookup', False),
        ('traceroute', 'Route tracing', False),
        ('tracert', 'Route tracing (Windows)', False),
        ('mtr', 'Network diagnostics', False),
        ('ssh', 'SSH client', False),
        ('whois', 'WHOIS lookup', False),
        ('openssl', 'SSL/TLS toolkit', False),
    ]
    
    available = []
    missing = []
    
    for tool, description, required in tools:
        if check_system_tool(tool):
            print(f"{Colors.SUCCESS}[✓] {tool:<20} - {description}{Colors.RESET}")
            available.append(tool)
        else:
            status = "REQUIRED" if required else "OPTIONAL"
            color = Colors.ERROR if required else Colors.WARNING
            print(f"{color}[✗] {tool:<20} - {description} ({status}){Colors.RESET}")
            if required:
                missing.append(tool)
    
    return available, missing

def check_directories():
    """Check/create required directories"""
    print(f"\n{Colors.PRIMARY}[*] Checking directories...{Colors.RESET}")
    
    config_dir = ".war_bloop_v1"
    directories = [
        config_dir,
        f"{config_dir}/payloads",
        f"{config_dir}/scans",
        f"{config_dir}/phishing_pages",
        f"{config_dir}/captured_credentials",
        f"{config_dir}/ssh_keys",
        f"{config_dir}/traffic_logs",
        f"{config_dir}/keylogs",
        f"{config_dir}/keylog_screenshots",
        f"{config_dir}/dos_logs",
        f"{config_dir}/agents",
        f"{config_dir}/c2_logs",
        f"{config_dir}/modules",
        f"{config_dir}/network_monitor",
        f"{config_dir}/keylog_exfil",
        f"{config_dir}/deployments",
        f"{config_dir}/domain_hosting",
        f"{config_dir}/cracking",
        f"{config_dir}/docker_scans",
        "war_bloop_reports",
        "war_bloop_reports/pdf_reports",
        "war_bloop_reports/graphics",
        "war_bloop_reports/charts",
    ]
    
    for directory in directories:
        path = Path(directory)
        if path.exists():
            print(f"{Colors.SUCCESS}[✓] {directory}{Colors.RESET}")
        else:
            path.mkdir(parents=True, exist_ok=True)
            print(f"{Colors.WARNING}[+] {directory} (created){Colors.RESET}")

def check_network():
    """Check network connectivity"""
    print(f"\n{Colors.PRIMARY}[*] Checking network connectivity...{Colors.RESET}")
    
    try:
        import socket
        socket.create_connection(("8.8.8.8", 53), timeout=5)
        print(f"{Colors.SUCCESS}[✓] Internet connectivity - OK{Colors.RESET}")
        return True
    except Exception as e:
        print(f"{Colors.WARNING}[!] Internet connectivity - {e}{Colors.RESET}")
        return False

def check_permissions():
    """Check for admin/root permissions"""
    print(f"\n{Colors.PRIMARY}[*] Checking permissions...{Colors.RESET}")
    
    import platform
    import os
    
    if platform.system().lower() == 'windows':
        try:
            import ctypes
            is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
        except:
            is_admin = False
    else:
        is_admin = os.geteuid() == 0 if hasattr(os, 'geteuid') else False
    
    if is_admin:
        print(f"{Colors.SUCCESS}[✓] Running with elevated privileges{Colors.RESET}")
    else:
        print(f"{Colors.WARNING}[!] Running without elevated privileges (some features may be limited){Colors.RESET}")
    
    return is_admin

def generate_report(results):
    """Generate a summary report"""
    print(f"\n{Colors.PRIMARY}{'='*60}{Colors.RESET}")
    print(f"{Colors.BOLD}WAR-BLOOP-V1 Requirements Report{Colors.RESET}")
    print(f"{Colors.PRIMARY}{'='*60}{Colors.RESET}")
    
    print(f"\n{Colors.SUCCESS}Python Packages Available: {len(results['packages_available'])}{Colors.RESET}")
    if results['packages_missing']:
        print(f"{Colors.ERROR}Python Packages Missing: {len(results['packages_missing'])}{Colors.RESET}")
        print(f"  Missing: {', '.join(results['packages_missing'])}")
    
    print(f"\n{Colors.SUCCESS}System Tools Available: {len(results['tools_available'])}{Colors.RESET}")
    if results['tools_missing']:
        print(f"{Colors.WARNING}System Tools Missing: {len(results['tools_missing'])}{Colors.RESET}")
        print(f"  Missing: {', '.join(results['tools_missing'])}")
    
    # Overall status
    print(f"\n{Colors.PRIMARY}{'='*60}{Colors.RESET}")
    
    if not results['packages_missing'] and not results['tools_missing']:
        print(f"{Colors.SUCCESS}✅ ALL REQUIREMENTS SATISFIED - Ready to run!{Colors.RESET}")
        return 0
    elif not results['tools_missing']:
        print(f"{Colors.WARNING}⚠️  Some Python packages missing - Install with: pip install -r requirements.txt{Colors.RESET}")
        return 1
    else:
        print(f"{Colors.ERROR}❌ Missing required dependencies{Colors.RESET}")
        print(f"{Colors.WARNING}   Install Python packages: pip install -r requirements.txt{Colors.RESET}")
        print(f"{Colors.WARNING}   Install system tools based on your OS{Colors.RESET}")
        return 2

def main():
    print_header()
    
    results = {}
    
    # Check Python version
    results['python_ok'] = check_python_version()
    
    if not results['python_ok']:
        print(f"\n{Colors.ERROR}❌ Python 3.7+ is required!{Colors.RESET}")
        sys.exit(1)
    
    # Check packages
    results['packages_available'], results['packages_missing'] = check_python_packages()
    
    # Check tools
    results['tools_available'], results['tools_missing'] = check_system_tools()
    
    # Check directories
    check_directories()
    
    # Check network
    results['network_ok'] = check_network()
    
    # Check permissions
    results['is_admin'] = check_permissions()
    
    # Generate report
    exit_code = generate_report(results)
    
    sys.exit(exit_code)

if __name__ == "__main__":
    main()
