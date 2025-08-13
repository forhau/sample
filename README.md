# Security Test Sample

A mixed Rust and Solidity project designed to test security analysis tools including **Slither** for Solidity smart contracts and **CodeQL Advanced Security** for Rust code. This project intentionally contains security vulnerabilities for testing purposes.

## 🎯 Purpose

This project serves as a comprehensive testing ground for:
- **Slither Action** - Static analysis for Solidity smart contracts
- **CodeQL Advanced Security** - Security analysis for Rust code
- **GitHub Actions workflows** - Automated security scanning
- **Mixed language development** - Rust and Solidity in one repository

## 🏗️ Project Structure

```
sample/
├── .github/workflows/
│   └── security-analysis.yml    # GitHub Actions security workflow
├── src/
│   ├── main.rs                  # Rust application with intentional vulnerabilities
│   └── VulnerableToken.sol      # Solidity contract with security issues
├── test/
│   └── VulnerableToken.t.sol    # Forge test suite
├── script/
│   └── Deploy.s.sol             # Deployment script
├── Cargo.toml                   # Rust project configuration
├── foundry.toml                 # Forge configuration
├── package.json                 # NPM configuration
├── remappings.txt               # Solidity import mappings
├── Makefile                     # Build automation
└── README.md                    # This file
```

## 🔧 Prerequisites

Before using this project, ensure you have the following installed:

### Required Tools
- **Rust & Cargo**: [Install Rust](https://rustup.rs/)
- **Foundry (Forge)**: [Install Foundry](https://book.getfoundry.sh/getting-started/installation)
- **Node.js & NPM**: [Install Node.js](https://nodejs.org/)
- **Git**: For version control

### Optional Security Tools
- **Slither**: `pip3 install slither-analyzer`
- **cargo-audit**: `cargo install cargo-audit`
- **Mythril**: `pip3 install mythril`
- **cargo-watch**: `cargo install cargo-watch` (for development)

## 🚀 Quick Start

1. **Clone and navigate to the project:**
   ```bash
   cd sample/
   ```

2. **Install all dependencies:**
   ```bash
   make install
   ```

3. **Build both projects:**
   ```bash
   make build
   ```

4. **Run tests:**
   ```bash
   make test
   ```

5. **Run security analysis:**
   ```bash
   make security
   ```

## 📋 Makefile Commands Reference

### Installation Commands

| Command | Description |
|---------|-------------|
| `make install` | Install all dependencies for both Rust and Solidity |
| `make install-rust` | Install only Rust dependencies |
| `make install-solidity` | Install Solidity dependencies and forge-std |

### Build Commands

| Command | Description |
|---------|-------------|
| `make build` | Build both Rust and Solidity projects |
| `make build-rust` | Build only the Rust project |
| `make build-rust-release` | Build Rust project in optimized release mode |
| `make build-solidity` | Build only Solidity contracts with Forge |

### Test Commands

| Command | Description |
|---------|-------------|
| `make test` | Run all tests for both projects |
| `make test-rust` | Run Rust tests |
| `make test-rust-verbose` | Run Rust tests with detailed output |
| `make test-solidity` | Run Solidity tests with Forge |
| `make test-solidity-verbose` | Run Solidity tests with detailed output |
| `make test-solidity-gas` | Run Solidity tests with gas usage reporting |

### Security Analysis Commands

| Command | Description |
|---------|-------------|
| `make security` | Run security analysis on both projects |
| `make security-rust` | Run cargo-audit on Rust code |
| `make security-solidity` | Run Slither analysis on Solidity contracts |
| `make security-mythril` | Run Mythril analysis (optional tool) |

### Code Quality Commands

| Command | Description |
|---------|-------------|
| `make lint` | Run linting on both projects |
| `make lint-rust` | Run Rust clippy linting |
| `make lint-solidity` | Check Solidity formatting |
| `make fmt` | Format code for both projects |
| `make fmt-rust` | Format Rust code |
| `make fmt-solidity` | Format Solidity code |
| `make check` | Check code quality without building |
| `make check-rust` | Check Rust code without building |
| `make check-solidity` | Check Solidity compilation and sizes |

### Development Commands

| Command | Description |
|---------|-------------|
| `make dev` | Instructions for starting development environment |
| `make watch-rust` | Watch Rust files for changes and rebuild |
| `make watch-solidity` | Watch Solidity files for changes and rebuild |
| `make run-rust` | Run the Rust application |
| `make coverage-solidity` | Generate test coverage for Solidity |

### Deployment Commands

| Command | Description |
|---------|-------------|
| `make deploy-local` | Deploy contracts to local network (requires anvil) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `make clean` | Clean build artifacts for both projects |
| `make clean-rust` | Clean only Rust build artifacts |
| `make clean-solidity` | Clean only Solidity build artifacts |
| `make clean-all` | Alias for clean command |
| `make help` | Show all available commands with descriptions |
| `make info` | Display project and tool version information |

### CI/CD Commands

| Command | Description |
|---------|-------------|
| `make ci` | Run complete CI pipeline (install, build, test, lint, security) |
| `make ci-rust` | Run CI pipeline for Rust only |
| `make ci-solidity` | Run CI pipeline for Solidity only |
| `make release-rust` | Build optimized release version |
| `make all` | Run complete build pipeline from scratch |

## 🔒 Security Vulnerabilities (Intentional)

This project contains intentional security vulnerabilities for testing purposes:

### Rust Vulnerabilities
- **Information Disclosure**: Logging sensitive data
- **Path Traversal**: Unsafe file operations
- **Memory Safety**: Unsafe memory operations
- **Weak Cryptography**: Poor password handling
- **SQL Injection**: Unsafe query construction

### Solidity Vulnerabilities
- **Reentrancy Attack**: External calls before state changes
- **Access Control**: Missing permission checks
- **Integer Overflow**: Unchecked arithmetic operations
- **Timestamp Dependence**: Relying on block.timestamp
- **DoS Attacks**: Unbounded loops
- **Weak Randomness**: Predictable random number generation

## 🔄 Common Workflows

### Daily Development
```bash
make clean          # Start fresh
make install        # Ensure dependencies are up to date
make build          # Build both projects
make test           # Run tests
make lint           # Check code quality
```

### Before Committing
```bash
make ci             # Run full CI pipeline
```

### Security Review
```bash
make security       # Run all security tools
make coverage-solidity  # Check test coverage
```

### Development with File Watching
```bash
# Terminal 1
make watch-rust

# Terminal 2  
make watch-solidity
```

## 🚨 GitHub Actions Integration

The project includes a comprehensive GitHub Actions workflow (`.github/workflows/security-analysis.yml`) that:

1. **Runs Slither analysis** on Solidity contracts
2. **Runs CodeQL analysis** on Rust code  
3. **Uploads results** to GitHub Security tab
4. **Provides summary reports** after each run

The workflow triggers on:
- Push to main/develop branches
- Pull requests to main
- Weekly schedule (Mondays at 6 AM UTC)

## 🛠️ Troubleshooting

### Common Issues

**Forge not found:**
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

**Slither not working:**
```bash
pip3 install slither-analyzer
# or
pip install slither-analyzer
```

**Cargo audit missing:**
```bash
cargo install cargo-audit
```

**Permission errors:**
```bash
# Ensure you have proper permissions
chmod +x scripts/*  # If using custom scripts
```

### Tool Versions
Check tool versions with:
```bash
make info
```

## 📝 License

MIT License - This project is for educational and testing purposes only.

## ⚠️ Disclaimer

This project contains intentional security vulnerabilities and should **never** be deployed to production or used with real funds. It is designed solely for security testing and educational purposes.