# @author Dominik Vágner
# @date 10/04/2021

# Variables
VENV := venv
LOGINS := xvasin11_xvagne10_xpoliv06_xhajek51

# Commands
all: venv

$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	./$(VENV)/bin/pip install -r requirements.txt

venv: $(VENV)/bin/activate

run: venv
	./$(VENV)/bin/python3 calculator.py

profile: venv
	./$(VENV)/bin/python3 profiling.py	

test: venv
	./$(VENV)/bin/py.test test_math_functions.py -v

test_verbose: venv
	./$(VENV)/bin/py.test test_math_functions.py -v -s

doc:
	doxygen dconfig

pack: clean doc
	rsync -a --exclude=html --exclude=latex ../* ../repo/
	cp -rf ../.git ../repo/
	cp ../.gitignore ../repo/
	mkdir ../doc ../install
	rsync -a html ../doc/
	rsync -a latex ../doc/
	cp ../calculator-4exceptions.deb ../install/
	mkdir ../$(LOGINS)/
	mv -t ../$(LOGINS)/ ../doc ../install ../repo
	zip -r ../$(LOGINS).zip ../$(LOGINS)
	rm -r --force ../doc/ ../install/ ../repo/ ../$(LOGINS)/

clean:
	rm -rf $(VENV) __pycache__ .hypothesis .pytest_cache ../$(LOGINS).zip
	find . -type f -name '*.pyc' -delete

help:
	@echo "USAGE:"
	@echo "make <target>"
	@echo ""
	@echo "DESCRIPTION:"
	@echo "This Makefile is used for creating python virtual enviroment and"
	@echo "running script in it. All targets with usage written below."
	@echo ""
	@echo "TARGETS:"
	@echo "all: Build new venv, with packages from requirements.txt"
	@echo "run: Run the calculator.py from venv."
	@echo "test: Runs tests for math functions."
	@echo "test_verbose: Runs tests with detailed output (every input echoed)."
	@echo "profile: Runs profiling."
	@echo "doc: Generates program documentation."
	@echo "pack: Packs required files into zip that is ready to be submitted."
	@echo "clean: Removes all files that aren't supposed to be submitted."

.PHONY: all venv run clean test test_verbose help doc profile pack