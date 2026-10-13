#
# WAR-BLOOP-V1 Installation Script for Windows (PowerShell)
# Author: Ian Carter Kulani
# Version: 1.0.0
#

#Requires -Version 5.1

# Set execution policy for current session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Colors
$Red = "`e[91m"
$Green = "`e[92m"
$Yellow = "`e[93m"
$Blue = "`e[94m"
$Cyan = "`e[96m"
$White = "`e[97m"
$Reset = "`e[0m"
$Bold = "`e[1m"

# Banner
function Show-Banner {
    Write-Host @"
$Blue
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
$Reset
"@
}

# Check administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check Python
function Test-Python {
    Write-Host "`n$Blue[*] Checking Python installation...$Reset"
    
    try {
        $pythonVersion = python --version 2>&1
        Write-Host "$Green[+] $pythonVersion$Reset"
        return $true
    }
    catch {
        Write-Host "$Red[X] Python not found! Please install Python 3.7+ from https://python.org$Reset"
        return $false
    }
}

# Install Python packages
function Install-PythonDependencies {
    Write-Host "`n$Blue[*] Installing Python dependencies...$Reset"
    
    # Upgrade pip
    Write-Host "$Cyan[*] Upgrading pip...$Reset"
    python -m pip install --upgrade pip setuptools wheel
    
    # Install from requirements.txt or manually
    if (Test-Path "requirements.txt") {
        Write-Host "$Cyan[*] Installing from requirements.txt...$Reset"
        python -m pip install -r requirements.txt
    }
    else {
        Write-Host "$Yellow[!] requirements.txt not found. Installing core dependencies...$Reset"
        $packages = @(
            "colorama",
            "requests",
            "psutil",
            "cryptography",
            "paramiko",
            "scapy",
            "dnspython",
            "python-whois",
            "flask",
            "flask-socketio",
            "flask-cors",
            "discord.py",
            "telethon",
            "slack-sdk",
            "selenium",
            "webdriver-manager",
            "pynput",
            "pyperclip",
            "pyautogui",
            "reportlab",
            "matplotlib",
            "numpy",
            "google-auth",
            "google-api-python-client",
            "python-dateutil",
            "tabulate",
            "tqdm",
            "pyyaml",
            "jinja2"
        )
        python -m pip install @packages
    }
    
    Write-Host "$Green[+] Python dependencies installed$Reset"
}

# Check system tools
function Test-SystemTools {
    Write-Host "`n$Blue[*] Checking system tools...$Reset"
    
    $tools = @{
        "nmap" = "Nmap network scanner"
        "curl" = "HTTP client"
        "wget" = "File downloader"
        "ssh" = "SSH client"
    }
    
    foreach ($tool in $tools.Keys) {
        $found = Get-Command $tool -ErrorAction SilentlyContinue
        if ($found) {
            Write-Host "$Green[+] $tool - $($tools[$tool])$Reset"
        }
        else {
            Write-Host "$Yellow[!] $tool not found - $($tools[$tool])$Reset"
        }
    }
}

# Create directories
function New-Directories {
    Write-Host "`n$Blue[*] Creating directories...$Reset"
    
    $directories = @(
        ".war_bloop_v1\payloads",
        ".war_bloop_v1\scans",
        ".war_bloop_v1\phishing_pages",
        ".war_bloop_v1\captured_credentials",
        ".war_bloop_v1\ssh_keys",
        ".war_bloop_v1\traffic_logs",
        ".war_bloop_v1\keylogs",
        ".war_bloop_v1\keylog_screenshots",
        ".war_bloop_v1\dos_logs",
        ".war_bloop_v1\agents",
        ".war_bloop_v1\c2_logs",
        ".war_bloop_v1\modules",
        ".war_bloop_v1\network_monitor",
        ".war_bloop_v1\keylog_exfil",
        ".war_bloop_v1\deployments",
        ".war_bloop_v1\domain_hosting",
        ".war_bloop_v1\cracking",
        ".war_bloop_v1\docker_scans",
        "war_bloop_reports\pdf_reports",
        "war_bloop_reports\graphics",
        "war_bloop_reports\charts"
    )
    
    foreach ($dir in $directories) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    
    Write-Host "$Green[+] Directories created$Reset"
}

# Create launcher
function New-Launcher {
    Write-Host "`n$Blue[*] Creating launcher script...$Reset"
    
    $launcherContent = @"
@echo off
python "%~dp0war_bloop_v1.py" %*
"@
    
    Set-Content -Path "war-bloop.bat" -Value $launcherContent
    
    # Also create PowerShell launcher
    $psLauncherContent = @"
#!/usr/bin/env pwsh
python "`$PSScriptRoot/war_bloop_v1.py" @args
"@
    
    Set-Content -Path "war-bloop.ps1" -Value $psLauncherContent
    
    Write-Host "$Green[+] Launcher scripts created$Reset"
}

# Main installation
function Main {
    Show-Banner
    
    $isAdmin = Test-Administrator
    if ($isAdmin) {
        Write-Host "$Green[+] Running with administrator privileges$Reset"
    }
    else {
        Write-Host "$Yellow[!] Not running as administrator. Some features may require elevation.$Reset"
    }
    
    if (-not (Test-Python)) {
        exit 1
    }
    
    Install-PythonDependencies
    Test-SystemTools
    New-Directories
    New-Launcher
    
    Write-Host @"
`n$Green$Bold
╔══════════════════════════════════════════════════════════════════╗
║              WAR-BLOOP-V1 Installation Complete!                 ║
╚══════════════════════════════════════════════════════════════════╝
$Reset

$Cyan To run WAR-BLOOP-V1:$Reset
  $Green.\war-bloop.bat$Reset          # Run the tool (CMD)
  $Green.\war-bloop.ps1$Reset          # Run the tool (PowerShell)
  $Green python war_bloop_v1.py$Reset   # Alternative

$Cyan To check requirements:$Reset
  $Green python requirements-check.py$Reset

$Cyan To run tests:$Reset
  $Green python test-commands.py$Reset
"@
}

# Run main
Main
