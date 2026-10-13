@echo off
REM WAR-BLOOP-V1 Installation Script for Windows
REM Author: Ian Carter Kulani
REM Version: 1.0.0

setlocal EnableDelayedExpansion

REM Colors (using ANSI escape codes)
for /F "delims=" %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "BLUE=%ESC%[94m"
set "CYAN=%ESC%[96m"
set "NC=%ESC%[0m"
set "BOLD=%ESC%[1m"

REM Banner
:print_banner
echo %BLUE%
echo ================================================================================
echo                                                                                
echo   ##     ##    ###    ########     ########  ##        #######   #######  ########  
echo   ##     ##   ## ##   ##     ##    ##     ## ##       ##     ## ##     ## ##     ## 
echo   ##  #  ##  ##   ##  ##     ##    ########  ##       ##     ## ##     ## ########  
echo   ## ## ## ## ######### ########     ##     ## ##       ##     ## ##     ## ##        
echo   ## ## ## ## ##     ## ##   ##      ##     ## ##       ##     ## ##     ## ##        
echo    ###   ###  ##     ## ##    ##     ########  ########  #######   #######  ##        
echo                                                                                
echo                     WAR-BLOOP-V1 - Cyber Command Platform                     
echo                          Author: Ian Carter Kulani                            
echo                               Version: 1.0.0                                  
echo                                                                                
echo ================================================================================
echo %NC%

REM Check for admin rights
:check_admin
net session >nul 2>&1
if %errorLevel% == 0 (
    echo %GREEN%[+] Running with administrator privileges%NC%
    set "ADMIN=1"
) else (
    echo %YELLOW%[!] Not running as administrator. Some features may require elevation.%NC%
    set "ADMIN=0"
)

REM Check Python
:check_python
echo.
echo %BLUE%[*] Checking Python installation...%NC%
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo %RED%[X] Python not found! Please install Python 3.7+ from https://python.org%NC%
    pause
    exit /b 1
)
python --version
echo %GREEN%[+] Python found%NC%

REM Upgrade pip
:upgrade_pip
echo.
echo %BLUE%[*] Upgrading pip...%NC%
python -m pip install --upgrade pip setuptools wheel
echo %GREEN%[+] Pip upgraded%NC%

REM Install Python dependencies
:install_deps
echo.
echo %BLUE%[*] Installing Python dependencies...%NC%

if exist requirements.txt (
    python -m pip install -r requirements.txt
) else (
    echo %YELLOW%[!] requirements.txt not found. Installing core dependencies...%NC%
    python -m pip install ^
        colorama ^
        requests ^
        psutil ^
        cryptography ^
        paramiko ^
        scapy ^
        dnspython ^
        python-whois ^
        flask ^
        flask-socketio ^
        flask-cors ^
        discord.py ^
        telethon ^
        slack-sdk ^
        selenium ^
        webdriver-manager ^
        pynput ^
        pyperclip ^
        pyautogui ^
        reportlab ^
        matplotlib ^
        numpy ^
        google-auth ^
        google-api-python-client ^
        python-dateutil ^
        tabulate ^
        tqdm ^
        pyyaml ^
        jinja2
)
echo %GREEN%[+] Python dependencies installed%NC%

REM Check for Nmap
:check_nmap
echo.
echo %BLUE%[*] Checking for Nmap...%NC%
where nmap >nul 2>&1
if %errorLevel% neq 0 (
    echo %YELLOW%[!] Nmap not found. Please install from https://nmap.org/download.html%NC%
    echo %YELLOW%    Some scanning features will be limited.%NC%
) else (
    echo %GREEN%[+] Nmap found%NC%
)

REM Check for Wireshark/Npcap (for packet capture)
:check_npcap
echo.
echo %BLUE%[*] Checking for Npcap (packet capture)...%NC%
where windump >nul 2>&1
if %errorLevel% neq 0 (
    echo %YELLOW%[!] Npcap/WinPcap not found. Scapy features may be limited.%NC%
    echo %YELLOW%    Install from https://npcap.com/%NC%
) else (
    echo %GREEN%[+] Npcap found%NC%
)

REM Create directories
:create_dirs
echo.
echo %BLUE%[*] Creating directories...%NC%
mkdir ".war_bloop_v1\payloads" 2>nul
mkdir ".war_bloop_v1\scans" 2>nul
mkdir ".war_bloop_v1\phishing_pages" 2>nul
mkdir ".war_bloop_v1\captured_credentials" 2>nul
mkdir ".war_bloop_v1\ssh_keys" 2>nul
mkdir ".war_bloop_v1\traffic_logs" 2>nul
mkdir ".war_bloop_v1\keylogs" 2>nul
mkdir ".war_bloop_v1\keylog_screenshots" 2>nul
mkdir ".war_bloop_v1\dos_logs" 2>nul
mkdir ".war_bloop_v1\agents" 2>nul
mkdir ".war_bloop_v1\c2_logs" 2>nul
mkdir ".war_bloop_v1\modules" 2>nul
mkdir ".war_bloop_v1\network_monitor" 2>nul
mkdir ".war_bloop_v1\keylog_exfil" 2>nul
mkdir ".war_bloop_v1\deployments" 2>nul
mkdir ".war_bloop_v1\domain_hosting" 2>nul
mkdir ".war_bloop_v1\cracking" 2>nul
mkdir ".war_bloop_v1\docker_scans" 2>nul
mkdir "war_bloop_reports\pdf_reports" 2>nul
mkdir "war_bloop_reports\graphics" 2>nul
mkdir "war_bloop_reports\charts" 2>nul
echo %GREEN%[+] Directories created%NC%

REM Create launcher
:create_launcher
echo.
echo %BLUE%[*] Creating launcher script...%NC%
(
echo @echo off
echo python "%%~dp0war_bloop_v1.py" %%*
) > war-bloop.bat
echo %GREEN%[+] Launcher script created%NC%

REM Complete
:complete
echo.
echo %GREEN%================================================================================%NC%
echo %GREEN%              WAR-BLOOP-V1 Installation Complete!                               %NC%
echo %GREEN%================================================================================%NC%
echo.
echo %CYAN%To run WAR-BLOOP-V1:%NC%
echo   %GREEN%war-bloop.bat%NC%          # Run the tool
echo   %GREEN%python war_bloop_v1.py%NC% # Alternative
echo.
echo %CYAN%To check requirements:%NC%
echo   %GREEN%python requirements-check.py%NC%
echo.
echo %CYAN%To run tests:%NC%
echo   %GREEN%python test-commands.py%NC%
echo.

pause
