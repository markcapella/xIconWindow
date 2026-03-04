
# *****************************************************
# Variables to control Compile / Link.
#
APP_NAME="xIconWindow"
APP_VERSION="2026-03-01"
APP_AUTHOR="Mark James Capella"

# Color styling.
COLOR_NORMAL := $(shell tput sgr0)

COLOR_BLACK := $(shell tput setaf 0)
COLOR_RED := $(shell tput setaf 1)
COLOR_GREEN := $(shell tput setaf 2)
COLOR_YELLOW := $(shell tput setaf 3)
COLOR_BLUE := $(shell tput setaf 4)
COLOR_MAGENTA := $(shell tput setaf 5)
COLOR_CYAN := $(shell tput setaf 6)
COLOR_WHITE := $(shell tput setaf 7)

CC = g++

X11_CFLAGS = `pkg-config --cflags x11`
X11_LFLAGS = `pkg-config --libs x11 libpng`


# ****************************************************
# make
#
all: xIconWindow.cpp
	@if [ "$(shell id -u)" = 0 ]; then \
		echo; \
		echo "$(COLOR_RED)Error!$(COLOR_NORMAL) You must not"\
			"be root to perform this action."; \
		echo; \
		echo  "Please re-run with:"; \
		echo "   $(COLOR_GREEN)make$(COLOR_NORMAL)"; \
		echo; \
		exit 1; \
	fi

	@echo
	@echo "$(COLOR_BLUE)Build Starts.$(COLOR_NORMAL)"
	@echo

	@echo "$(COLOR_GREEN)Compile ...$(COLOR_NORMAL)"
	$(CC) $(X11_CFLAGS) -c xPngWrapper.cpp
	$(CC) $(X11_CFLAGS) -c xIconWindow.cpp

	@echo
	@echo "$(COLOR_GREEN)Linkage ...$(COLOR_NORMAL)"
	$(CC) xIconWindow.o xPngWrapper.o \
		$(X11_LFLAGS) \
		-o xIconWindow

	@echo "true" > "BUILD_COMPLETE"

	@echo
	@echo "$(COLOR_BLUE)Build Done.$(COLOR_NORMAL)"

# ****************************************************
# make run
#
run:
	@if [ ! -f BUILD_COMPLETE ]; then \
		echo; \
		echo "$(COLOR_RED)Error!$(COLOR_NORMAL) Nothing"\
			"currently built to run."; \
		echo; \
		echo "Please make this project first, with:"; \
		echo "   $(COLOR_GREEN)make$(COLOR_NORMAL)"; \
		echo; \
		exit 1; \
	fi

	@if [ "$(shell id -u)" = 0 ]; then \
		echo; \
		echo "$(COLOR_RED)Error!$(COLOR_NORMAL) You must not"\
			"be root to perform this action."; \
		echo; \
		echo  "Please re-run with:"; \
		echo "   $(COLOR_GREEN)make run$(COLOR_NORMAL)"; \
		echo; \
		exit 1; \
	fi

	@echo
	@echo "$(COLOR_BLUE)Run Starts.$(COLOR_NORMAL)"
	@echo

	./xIconWindow test.png

	@echo
	@echo "$(COLOR_BLUE)Run Done.$(COLOR_NORMAL)"

# ****************************************************
# sudo make install
#
install:
	@if [ ! -f BUILD_COMPLETE ]; then \
		echo; \
		echo "$(COLOR_RED)Error!$(COLOR_NORMAL) Nothing"\
			"currently built to install."; \
		echo; \
		echo "Please make this project first, with:"; \
		echo "   $(COLOR_GREEN)make$(COLOR_NORMAL)"; \
		echo; \
		exit 1; \
	fi

	@if ! [ "$(shell id -u)" = 0 ]; then \
		echo; \
		echo "$(COLOR_RED)Error!$(COLOR_NORMAL) You must"\
			"be root to perform this action."; \
		echo; \
		echo  "Please re-run with:"; \
		echo "   $(COLOR_GREEN)sudo make install$(COLOR_NORMAL)"; \
		echo; \
		exit 1; \
	fi

	@echo
	@echo "$(COLOR_BLUE)Install Starts.$(COLOR_NORMAL)"
	@echo

	cp 'xIconWindow' /usr/local/bin
	chmod +x /usr/local/bin/xIconWindow
	@echo

	@echo
	@echo "$(COLOR_BLUE)Install Done.$(COLOR_NORMAL)"

# ****************************************************
# sudo make uninstall
#
uninstall:
	@if ! [ "$(shell id -u)" = 0 ]; then \
		echo; \
		echo "$(COLOR_RED)Error!$(COLOR_NORMAL) You must"\
			"be root to perform this action."; \
		echo; \
		echo  "Please re-run with:"; \
		echo "   $(COLOR_GREEN)sudo make uninstall$(COLOR_NORMAL)"; \
		echo; \
		exit 1; \
	fi

	@echo
	@echo "$(COLOR_BLUE)Uninstall Starts.$(COLOR_NORMAL)"
	@echo

	rm -f /usr/local/bin/xIconWindow
	@echo

	@echo
	@echo "$(COLOR_BLUE)Uninstall Done.$(COLOR_NORMAL)"

# ****************************************************
# make clean
#
clean:
	@if [ "$(shell id -u)" = 0 ]; then \
		echo; \
		echo "$(COLOR_RED)Error!$(COLOR_NORMAL) You must not"\
			"be root to perform this action."; \
		echo; \
		echo  "Please re-run with:"; \
		echo "   $(COLOR_GREEN)make clean$(COLOR_NORMAL)"; \
		echo; \
		exit 1; \
	fi

	@echo
	@echo "$(COLOR_BLUE)Clean Starts.$(COLOR_NORMAL)"
	@echo

	rm -f xPngWrapper.o
	rm -f xIconWindow.o
	rm -f xIconWindow

	@rm -f "BUILD_COMPLETE"

	@echo
	@echo "$(COLOR_BLUE)Clean Done.$(COLOR_NORMAL)"
