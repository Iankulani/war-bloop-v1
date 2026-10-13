#!/usr/bin/env python3
"""
WAR-BLOOP-V1 Setup Script
Author: Ian Carter Kulani
Version: 1.0.0
"""

from setuptools import setup, find_packages
from pathlib import Path

# Read README for long description
readme_file = Path(__file__).parent / "README.md"
long_description = ""
if readme_file.exists():
    long_description = readme_file.read_text(encoding="utf-8")

# Read requirements
requirements_file = Path(__file__).parent / "requirements.txt"
requirements = []
if requirements_file.exists():
    requirements = [
        line.strip()
        for line in requirements_file.read_text().splitlines()
        if line.strip() and not line.startswith("#")
    ]

setup(
    name="war-bloop-v1",
    version="1.0.0",
    author="Ian Carter Kulani",
    author_email="ian.carter.kulani@example.com",
    description="Ultimate Cybersecurity Command & Control Platform",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/iancarterkulani/war-bloop-v1",
    project_urls={
        "Bug Reports": "https://github.com/iancarterkulani/war-bloop-v1/issues",
        "Source": "https://github.com/iancarterkulani/war-bloop-v1",
        "Documentation": "https://github.com/iancarterkulani/war-bloop-v1/wiki",
    },
    py_modules=["war_bloop_v1"],
    python_requires=">=3.7",
    install_requires=requirements,
    extras_require={
        "dev": [
            "pytest>=7.0.0",
            "pytest-cov>=4.0.0",
            "pytest-asyncio>=0.21.0",
            "black>=23.0.0",
            "flake8>=6.0.0",
            "mypy>=1.0.0",
            "isort>=5.12.0",
            "pre-commit>=3.0.0",
        ],
        "docs": [
            "sphinx>=7.0.0",
            "sphinx-rtd-theme>=1.3.0",
            "myst-parser>=2.0.0",
        ],
        "full": [
            "discord.py>=2.3.0",
            "telethon>=1.31.0",
            "slack-sdk>=3.23.0",
            "selenium>=4.15.0",
            "webdriver-manager>=4.0.0",
            "pynput>=1.7.6",
            "pyperclip>=1.8.2",
            "pyautogui>=0.9.54",
            "reportlab>=4.0.0",
            "matplotlib>=3.7.0",
            "numpy>=1.24.0",
        ],
    },
    entry_points={
        "console_scripts": [
            "war-bloop=war_bloop_v1:main",
            "warbloop=war_bloop_v1:main",
            "wbv1=war_bloop_v1:main",
        ],
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Environment :: Console",
        "Environment :: Web Environment",
        "Intended Audience :: Information Technology",
        "Intended Audience :: System Administrators",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Topic :: Security",
        "Topic :: System :: Networking",
        "Topic :: System :: Systems Administration",
        "Topic :: Utilities",
    ],
    keywords=[
        "security",
        "cybersecurity",
        "penetration-testing",
        "network-scanning",
        "phishing",
        "keylogger",
        "ddos",
        "command-and-control",
        "c2",
        "red-team",
        "blue-team",
        "nmap",
        "curl",
        "wget",
        "netcat",
    ],
    license="MIT",
    zip_safe=False,
    include_package_data=True,
    package_data={
        "": ["*.txt", "*.md", "*.json", "*.yml", "*.yaml"],
    },
)
