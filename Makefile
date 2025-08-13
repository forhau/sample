# Security Test Sample - Mixed Rust/Solidity Project Makefile
# Supports both Cargo (Rust) and Forge (Solidity) workflows

.PHONY: help install build test clean security lint fmt check all
.DEFAULT_GOAL := help

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Project info
PROJECT_NAME := security-test-sample
RUST_TARGET_DIR := target
SOLIDITY_OUT_DIR := out

help: ## Show this help message
	@echo "$(GREEN)$(PROJECT_NAME) - Mixed Rust/Solidity Project$(NC)"
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

# =============================================================================
# INSTALLATION TARGETS
# =============================================================================

install: install-rust install-solidity ## Install all dependencies

install-rust: ## Install Rust dependencies
	@echo "$(YELLOW)Installing Rust dependencies...$(NC)"
	cargo fetch

install-solidity: ## Install Solidity dependencies and forge-std
	@echo "$(YELLOW)Installing Solidity dependencies...$(NC)"
	@if [ ! -d "lib/forge-std" ]; then \
		forge install foundry-rs/forge-std --no-commit; \
	fi
	npm install

# =============================================================================
# BUILD TARGETS
# =============================================================================

build: build-rust build-solidity ## Build both Rust and Solidity projects

build-rust: ## Build Rust project
	@echo "$(YELLOW)Building Rust project...$(NC)"
	cargo build

build-rust-release: ## Build Rust project in release mode
	@echo "$(YELLOW)Building Rust project (release)...$(NC)"
	cargo build --release

build-solidity: ## Build Solidity contracts with Forge
	@echo "$(YELLOW)Building Solidity contracts...$(NC)"
	forge build

# =============================================================================
# TEST TARGETS
# =============================================================================

test: test-rust test-solidity ## Run all tests

test-rust: ## Run Rust tests
	@echo "$(YELLOW)Running Rust tests...$(NC)"
	cargo test

test-rust-verbose: ## Run Rust tests with verbose output
	@echo "$(YELLOW)Running Rust tests (verbose)...$(NC)"
	cargo test -- --nocapture

test-solidity: ## Run Solidity tests with Forge
	@echo "$(YELLOW)Running Solidity tests...$(NC)"
	forge test

test-solidity-verbose: ## Run Solidity tests with verbose output
	@echo "$(YELLOW)Running Solidity tests (verbose)...$(NC)"
	forge test -vvv

test-solidity-gas: ## Run Solidity tests with gas reporting
	@echo "$(YELLOW)Running Solidity tests with gas report...$(NC)"
	forge test --gas-report

# =============================================================================
# SECURITY ANALYSIS TARGETS
# =============================================================================

security: security-rust security-solidity ## Run security analysis on both projects

security-rust: ## Run security analysis on Rust code
	@echo "$(YELLOW)Running Rust security analysis...$(NC)"
	@if command -v cargo-audit >/dev/null 2>&1; then \
		cargo audit; \
	else \
		echo "$(RED)cargo-audit not installed. Run: cargo install cargo-audit$(NC)"; \
	fi

security-solidity: ## Run Slither analysis on Solidity contracts
	@echo "$(YELLOW)Running Slither analysis...$(NC)"
	@if command -v slither >/dev/null 2>&1; then \
		slither src/; \
	else \
		echo "$(RED)Slither not installed. Visit: https://github.com/crytic/slither$(NC)"; \
	fi

security-mythril: ## Run Mythril analysis on Solidity contracts (optional)
	@echo "$(YELLOW)Running Mythril analysis...$(NC)"
	@if command -v myth >/dev/null 2>&1; then \
		myth analyze src/VulnerableToken.sol; \
	else \
		echo "$(RED)Mythril not installed. Run: pip3 install mythril$(NC)"; \
	fi

# =============================================================================
# CODE QUALITY TARGETS
# =============================================================================

lint: lint-rust lint-solidity ## Run linting on both projects

lint-rust: ## Run Rust linting
	@echo "$(YELLOW)Linting Rust code...$(NC)"
	cargo clippy -- -D warnings

lint-solidity: ## Run Solidity linting
	@echo "$(YELLOW)Linting Solidity code...$(NC)"
	forge fmt --check

fmt: fmt-rust fmt-solidity ## Format code for both projects

fmt-rust: ## Format Rust code
	@echo "$(YELLOW)Formatting Rust code...$(NC)"
	cargo fmt

fmt-solidity: ## Format Solidity code
	@echo "$(YELLOW)Formatting Solidity code...$(NC)"
	forge fmt

check: check-rust check-solidity ## Check code quality for both projects

check-rust: ## Check Rust code without building
	@echo "$(YELLOW)Checking Rust code...$(NC)"
	cargo check

check-solidity: ## Check Solidity compilation
	@echo "$(YELLOW)Checking Solidity compilation...$(NC)"
	forge build --sizes

# =============================================================================
# UTILITY TARGETS
# =============================================================================

clean: clean-rust clean-solidity ## Clean build artifacts for both projects

clean-rust: ## Clean Rust build artifacts
	@echo "$(YELLOW)Cleaning Rust artifacts...$(NC)"
	cargo clean

clean-solidity: ## Clean Solidity build artifacts
	@echo "$(YELLOW)Cleaning Solidity artifacts...$(NC)"
	forge clean
	rm -rf out/ cache/ artifacts/

clean-all: clean ## Alias for clean
	@echo "$(GREEN)All build artifacts cleaned$(NC)"

run-rust: ## Run the Rust application
	@echo "$(YELLOW)Running Rust application...$(NC)"
	cargo run

deploy-local: ## Deploy contracts to local network (requires anvil)
	@echo "$(YELLOW)Deploying to local network...$(NC)"
	forge script script/Deploy.s.sol --fork-url http://localhost:8545 --broadcast

coverage-solidity: ## Generate test coverage for Solidity
	@echo "$(YELLOW)Generating Solidity test coverage...$(NC)"
	forge coverage

# =============================================================================
# DEVELOPMENT TARGETS
# =============================================================================

dev: ## Start development environment
	@echo "$(YELLOW)Starting development environment...$(NC)"
	@echo "Run 'make watch-rust' in one terminal and 'make watch-solidity' in another"

watch-rust: ## Watch Rust files for changes and rebuild
	@echo "$(YELLOW)Watching Rust files...$(NC)"
	@if command -v cargo-watch >/dev/null 2>&1; then \
		cargo watch -x check -x test; \
	else \
		echo "$(RED)cargo-watch not installed. Run: cargo install cargo-watch$(NC)"; \
	fi

watch-solidity: ## Watch Solidity files for changes and rebuild
	@echo "$(YELLOW)Watching Solidity files...$(NC)"
	forge build --watch

# =============================================================================
# CI/RELEASE TARGETS
# =============================================================================

ci: install build test lint security ## Run full CI pipeline

ci-rust: install-rust build-rust test-rust lint-rust security-rust ## Run Rust CI pipeline

ci-solidity: install-solidity build-solidity test-solidity lint-solidity security-solidity ## Run Solidity CI pipeline

release-rust: ## Build release version of Rust project
	@echo "$(YELLOW)Building Rust release...$(NC)"
	cargo build --release

# =============================================================================
# INFO TARGETS
# =============================================================================

info: ## Show project information
	@echo "$(GREEN)Project Information:$(NC)"
	@echo "Name: $(PROJECT_NAME)"
	@echo "Rust version: $(shell rustc --version 2>/dev/null || echo 'Not installed')"
	@echo "Cargo version: $(shell cargo --version 2>/dev/null || echo 'Not installed')"
	@echo "Forge version: $(shell forge --version 2>/dev/null || echo 'Not installed')"
	@echo "Node version: $(shell node --version 2>/dev/null || echo 'Not installed')"
	@echo "NPM version: $(shell npm --version 2>/dev/null || echo 'Not installed')"

all: clean install build test lint security ## Run complete build pipeline