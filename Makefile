.PHONY: install lint format test clean help

help:  ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}{printf "  %-10s %s\n", $$1, $$2}'

install:  ## Editable install with dev tools + git hooks
	pip install -e ".[dev]"
	pre-commit install

lint:  ## Check lint + format (no writes)
	ruff check .
	black --check .

format:  ## Auto-fix lint + format
	ruff check --fix .
	black .

test:  ## Run tests
	pytest -q

clean:  ## Remove build/cache artifacts
	rm -rf build dist src/*.egg-info .pytest_cache .ruff_cache
	find . -type d -name __pycache__ -exec rm -rf {} +
