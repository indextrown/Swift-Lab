PYTHON := .venv/bin/python
UVICORN := .venv/bin/uvicorn
MOCK_COUNT := $(word 2, $(MAKECMDGOALS))

.PHONY: start install mock

install:
	python3 -m venv .venv
	$(PYTHON) -m pip install -r requirements.txt

start:
	@if [ ! -x "$(UVICORN)" ]; then \
		echo "uvicorn not found in .venv. Run 'make install' first."; \
		exit 1; \
	fi
	$(UVICORN) app.main:app --reload

mock:
	@if [ ! -x "$(PYTHON)" ]; then \
		echo "python not found in .venv. Run 'make install' first."; \
		exit 1; \
	fi
	$(PYTHON) -m app.seed $(if $(MOCK_COUNT),$(MOCK_COUNT),10)

%:
	@:
