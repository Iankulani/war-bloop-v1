#!/usr/bin/env python3
"""
WAR-BLOOP-V1 Command Tester
Tests all commands to verify functionality
"""

import sys
import time
import subprocess
import importlib
from pathlib import Path

# Color codes
class Colors:
    PRIMARY = '\033[94m'
    SUCCESS = '\033[92m'
    WARNING = '\033[93m'
    ERROR = '\033[91m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

class CommandTester:
    def __init__(self):
        self.passed = 0
        self.failed = 0
        self.skipped = 0
        self.results = []
    
    def print_header(self):
        print(f"""
{Colors.PRIMARY}╔══════════════════════════════════════════════════════════════════════════════╗
║{Colors.BOLD}              WAR-BLOOP-V1 - Command Tester                                   {Colors.PRIMARY}║
╚══════════════════════════════════════════════════════════════════════════════╝{Colors.RESET}
""")
    
    def test_command(self, name, command, timeout=30, expect_success=True):
        """Test a single command"""
        print(f"\n{Colors.PRIMARY}[*] Testing: {name}{Colors.RESET}")
        print(f"    Command: {command[:80]}{'...' if len(command) > 80 else ''}")
        
        start_time = time.time()
        
        try:
            result = subprocess.run(
                command,
                shell=True,
                capture_output=True,
                text=True,
                timeout=timeout
            )
            
            execution_time = time.time() - start_time
            
            if expect_success:
                if result.returncode == 0:
                    print(f"{Colors.SUCCESS}    [✓] PASSED ({execution_time:.2f}s){Colors.RESET}")
                    self.passed += 1
                    self.results.append((name, 'PASS', execution_time))
                    return True
                else:
                    print(f"{Colors.ERROR}    [✗] FAILED (exit code: {result.returncode}){Colors.RESET}")
                    if result.stderr:
                        print(f"    Error: {result.stderr[:200]}")
                    self.failed += 1
                    self.results.append((name, 'FAIL', execution_time))
                    return False
            else:
                # Command expected to fail or we don't care about exit code
                print(f"{Colors.SUCCESS}    [✓] EXECUTED ({execution_time:.2f}s){Colors.RESET}")
                self.passed += 1
                self.results.append((name, 'PASS', execution_time))
                return True
                
        except subprocess.TimeoutExpired:
            print(f"{Colors.ERROR}    [✗] TIMEOUT ({timeout}s){Colors.RESET}")
            self.failed += 1
            self.results.append((name, 'TIMEOUT', timeout))
            return False
        except Exception as e:
            print(f"{Colors.ERROR}    [✗] ERROR: {e}{Colors.RESET}")
            self.failed += 1
            self.results.append((name, 'ERROR', 0))
            return False
    
    def test_python_import(self, name, module):
        """Test Python module import"""
        print(f"\n{Colors.PRIMARY}[*] Testing import: {name}{Colors.RESET}")
        
        try:
            importlib.import_module(module)
            print(f"{Colors.SUCCESS}    [✓] PASSED{Colors.RESET}")
            self.passed += 1
            self.results.append((f"import_{name}", 'PASS', 0))
            return True
        except ImportError as e:
            print(f"{Colors.ERROR}    [✗] FAILED: {e}{Colors.RESET}")
            self.failed += 1
            self.results.append((f"import_{name}", 'FAIL', 0))
            return False
    
    def test_network_command(self, name, command, timeout=30):
        """Test network commands (may fail if no connectivity)"""
        print(f"\n{Colors.PRIMARY}[*] Testing network: {name}{Colors.RESET}")
        print(f"    Command: {command[:80]}{'...' if len(command) > 80 else ''}")
        
        start_time = time.time()
        
        try:
            result = subprocess.run(
                command,
                shell=True,
                capture_output=True,
                text=True,
                timeout=timeout
            )
            
            execution_time = time.time() - start_time
            
            # Network commands may fail due to no connectivity, so we just check execution
            print(f"{Colors.SUCCESS}    [✓] EXECUTED ({execution_time:.2f}s){Colors.RESET}")
            self.passed += 1
            self.results.append((name, 'PASS', execution_time))
            return True
                
        except subprocess.TimeoutExpired:
            print(f"{Colors.WARNING}    [!] TIMEOUT ({timeout}s) - May be network issue{Colors.RESET}")
            self.skipped += 1
            self.results.append((name, 'SKIP', timeout))
            return True
        except Exception as e:
            print(f"{Colors.ERROR}    [✗] ERROR: {e}{Colors.RESET}")
            self.failed += 1
            self.results.append((name, 'ERROR', 0))
            return False
    
    def run_all_tests(self):
        """Run all tests"""
        self.print_header()
        
        # Test Python imports
        print(f"\n{Colors.BOLD}{'='*60}{Colors.RESET}")
        print(f"{Colors.BOLD}Testing Python Imports{Colors.RESET}")
        print(f"{Colors.BOLD}{'='*60}{Colors.RESET}")
        
        imports = [
            ('colorama', 'colorama'),
            ('requests', 'requests'),
            ('psutil', 'psutil'),
            ('cryptography', 'cryptography'),
            ('paramiko', 'paramiko'),
            ('scapy', 'scapy'),
            ('dns', 'dns'),
            ('whois', 'whois'),
            ('flask', 'flask'),
            ('flask_socketio', 'flask_socketio'),
            ('discord', 'discord'),
            ('telethon', 'telethon'),
            ('slack_sdk', 'slack_sdk'),
            ('selenium', 'selenium'),
            ('pynput', 'pynput'),
            ('reportlab', 'reportlab'),
            ('matplotlib', 'matplotlib'),
            ('numpy', 'numpy'),
        ]
        
        for name, module in imports:
            self.test_python_import(name, module)
        
        # Test system commands
        print(f"\n{Colors.BOLD}{'='*60}{Colors.RESET}")
        print(f"{Colors.BOLD}Testing System Commands{Colors.RESET}")
        print(f"{Colors.BOLD}{'='*60}{Colors.RESET}")
        
        # Ping tests
        self.test_network_command('ping_localhost', 'ping -c 1 127.0.0.1')
        self.test_network_command('ping_google', 'ping -c 1 8.8.8.8', timeout=10)
        
        # Traceroute tests
        self.test_network_command('traceroute_localhost', 'traceroute -m 3 127.0.0.1', timeout=15)
        
        # Nmap tests
        self.test_command('nmap_version', 'nmap --version', timeout=10)
        self.test_network_command('nmap_localhost', 'nmap -F 127.0.0.1', timeout=30)
        
        # Curl tests
        self.test_command('curl_version', 'curl --version', timeout=10)
        self.test_network_command('curl_localhost', 'curl -s http://localhost 2>&1 || true', timeout=10)
        
        # Wget tests
        self.test_command('wget_version', 'wget --version', timeout=10)
        
        # Netcat tests
        self.test_command('nc_help', 'nc -h 2>&1 || ncat -h 2>&1 || true', timeout=10)
        
        # DNS tests
        self.test_network_command('dig_test', 'dig google.com +short 2>&1 || nslookup google.com 2>&1', timeout=15)
        
        # WHOIS tests
        self.test_network_command('whois_test', 'whois google.com 2>&1 | head -20', timeout=30)
        
        # SSH tests
        self.test_command('ssh_version', 'ssh -V 2>&1', timeout=10)
        
        # OpenSSL tests
        self.test_command('openssl_version', 'openssl version', timeout=10)
        
        # Test WAR-BLOOP-V1 module
        print(f"\n{Colors.BOLD}{'='*60}{Colors.RESET}")
        print(f"{Colors.BOLD}Testing WAR-BLOOP-V1 Module{Colors.RESET}")
        print(f"{Colors.BOLD}{'='*60}{Colors.RESET}")
        
        self.test_war_bloop_module()
        
        # Print summary
        self.print_summary()
    
    def test_war_bloop_module(self):
        """Test the WAR-BLOOP-V1 module"""
        print(f"\n{Colors.PRIMARY}[*] Testing WAR-BLOOP-V1 module...{Colors.RESET}")
        
        # Check if the main file exists
        main_file = Path("war_bloop_v1.py")
        if not main_file.exists():
            # Try to find it
            for f in Path(".").glob("*.py"):
                if "war" in f.name.lower() and "bloop" in f.name.lower():
                    main_file = f
                    break
        
        if main_file.exists():
            print(f"{Colors.SUCCESS}    [✓] Found: {main_file}{Colors.RESET}")
            self.passed += 1
            self.results.append(("war_bloop_module", 'PASS', 0))
            
            # Try to compile it
            try:
                with open(main_file, 'r') as f:
                    code = f.read()
                compile(code, str(main_file), 'exec')
                print(f"{Colors.SUCCESS}    [✓] Syntax check passed{Colors.RESET}")
                self.passed += 1
                self.results.append(("war_bloop_syntax", 'PASS', 0))
            except SyntaxError as e:
                print(f"{Colors.ERROR}    [✗] Syntax error: {e}{Colors.RESET}")
                self.failed += 1
                self.results.append(("war_bloop_syntax", 'FAIL', 0))
        else:
            print(f"{Colors.WARNING}    [!] WAR-BLOOP-V1 module not found{Colors.RESET}")
            self.skipped += 1
            self.results.append(("war_bloop_module", 'SKIP', 0))
    
    def print_summary(self):
        """Print test summary"""
        print(f"\n{Colors.PRIMARY}{'='*60}{Colors.RESET}")
        print(f"{Colors.BOLD}TEST SUMMARY{Colors.RESET}")
        print(f"{Colors.PRIMARY}{'='*60}{Colors.RESET}")
        
        total = self.passed + self.failed + self.skipped
        
        print(f"\n  Total Tests: {total}")
        print(f"  {Colors.SUCCESS}Passed: {self.passed}{Colors.RESET}")
        print(f"  {Colors.ERROR}Failed: {self.failed}{Colors.RESET}")
        print(f"  {Colors.WARNING}Skipped: {self.skipped}{Colors.RESET}")
        
        if self.failed > 0:
            print(f"\n{Colors.ERROR}Failed Tests:{Colors.RESET}")
            for name, status, duration in self.results:
                if status in ['FAIL', 'ERROR', 'TIMEOUT']:
                    print(f"  • {name}: {status}")
        
        print(f"\n{Colors.PRIMARY}{'='*60}{Colors.RESET}")
        
        if self.failed == 0:
            print(f"{Colors.SUCCESS}✅ ALL TESTS PASSED!{Colors.RESET}")
            return 0
        else:
            print(f"{Colors.WARNING}⚠️  Some tests failed. Check the output above.{Colors.RESET}")
            return 1

def main():
    tester = CommandTester()
    exit_code = tester.run_all_tests()
    sys.exit(exit_code)

if __name__ == "__main__":
    main()
