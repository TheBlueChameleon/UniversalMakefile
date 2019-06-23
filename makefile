LIBDIR = lib
SRCDIR = src
INCDIR = inc
OBJDIR = obj
EXEDIR = .

EXTENSION_CODE   = .c
EXTENSION_HEADER = .h

CXX      = gcc
CXXFLAGS = -std=c11 -Wextra -Wall -Wpedantic -Wimplicit-fallthrough -I $(LIBDIR)
LDFLAGS  = -lm



DIRECTORIES = $(subst $(SRCDIR),$(OBJDIR),$(shell find $(SRCDIR) -type d))
	# pathes for files to be included into the compile/link procedure.
	# subst: "substitute PARAMETER_1 by PARAMETER_2 in PARAMETER_3.
	# shell find -type d lists only directories. find works recursively.
	# => load from SRCDIR and OBJDIR with all subdirectories

EXENAME = UniversalMakefile
SRC     = $(wildcard $(SRCDIR)/*$(EXTENSION_CODE)) $(wildcard $(SRCDIR)/**/*$(EXTENSION_CODE))
	# list of all files in src, including subdirectories
INC     = $(wildcard $(INCDIR)/*$(EXTENSION_HEADER)) $(wildcard $(INCDIR)/**/*$(EXTENSION_HEADER))
	# same for includes
OBJ     = $(SRC:$(SRCDIR)/%$(EXTENSION_CODE)=$(OBJDIR)/%.o)
	# defines analogy relation?

GIT_BASE = https://github.com
GIT_USERNAME = TheBlueChameleon
GIT_ADDITIONAL = "./makefile"
	# ./tex/*.tex ./makefile
	# ... list files here that you want to be part of the repository that are not already part of the compilable stuff
	# separate them by whitespaces
	# toggle to comment if you don't have any additional files to be added.
GIT_EXCLUDE = ./src ./inc
	# ... list files here that you do not want to be part of the repository
	# separate by whitespaces
	# toggle to comment if you don't want to exclude any files
# =========================================================================== #

COLOR_END	= \033[m

COLOR_RED	= \033[0;31m
COLOR_GREEN	= \033[0;32m
COLOR_YELLOW	= \033[0;33m
COLOR_BLUE	= \033[0;34m
COLOR_PURPLE	= \033[0;35m
COLOR_CYAN	= \033[0;36m
COLOR_GREY	= \033[0;37m

COLOR_LRED	= \033[1;31m
COLOR_LGREEN	= \033[1;32m
COLOR_LYELLOW	= \033[1;33m
COLOR_LBLUE	= \033[1;34m
COLOR_LPURPLE	= \033[1;35m
COLOR_LCYAN	= \033[1;36m
COLOR_LGREY	= \033[1;37m

MSG_OK		= $(COLOR_LGREEN)[SUCCES]$(COLOR_END)
MSG_WARNING	= $(COLOR_LYELLOW)[WARNING]$(COLOR_END)
MSG_ERROR	= $(COLOR_LRED)[ERROR]$(COLOR_END)

# =========================================================================== #

define fatboxtop
	@printf "$(COLOR_BLUE)"
	@printf "#=============================================================================#\n"
	@printf "$(COLOR_END)"
endef
# ........................................................................... #
define fatboxbottom
	@printf "$(COLOR_BLUE)"
	@printf "#=============================================================================#\n"
	@printf "$(COLOR_END)"
endef
# ........................................................................... #
define fatboxtext
	@printf "$(COLOR_BLUE)"
	@printf "# "
	@printf "$(COLOR_LGREY)"
	@printf "%-75b %s" $(1)
	@printf "$(COLOR_BLUE)"
	@printf "#\n"
	@printf "$(COLOR_END)"
	
endef
# --------------------------------------------------------------------------- #
define boxtop
	@printf "$(COLOR_BLUE)"
	@printf "+-----------------------------------------------------------------------------+\n"
	@printf "$(COLOR_END)"
endef
# ........................................................................... #
define boxbottom
	@printf "$(COLOR_BLUE)"
	@printf "+-----------------------------------------------------------------------------+\n"
	@printf "$(COLOR_END)"
endef
# ........................................................................... #
define boxtext
	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LGREY)"
	@printf "%-75b %s" $(1)
	@printf "$(COLOR_BLUE)"
	@printf "|\n"
	@printf "$(COLOR_END)"
endef
# --------------------------------------------------------------------------- #
define fatbox
	$(call fatboxtop)
	$(call fatboxtext, $(1))
	$(call fatboxbottom)
endef
# ........................................................................... #
define box
	$(call boxtop)
	$(call boxtext, $(1))
	$(call boxbottom)
endef

# =========================================================================== #

.PHONY: intro all 

# --------------------------------------------------------------------------- #
all:   intro generate extro
new:   clean intro generate extro
run:   intro generate extro execute
grind: intro generate extro valgrind
gitstart: gitinit gitadds gitsetmasterhint
# --------------------------------------------------------------------------- #
intro:
	@clear
	$(call fatbox, "attempting to make")
	@printf "$(COLOR_GREY)  "
	@date
	@echo ""
	
# ........................................................................... #
extro:
	$(call fatbox, "make done")
	@printf "$(COLOR_GREY)  "
	@date
	@echo ""
	
# --------------------------------------------------------------------------- #
generate: $(EXENAME)
# ........................................................................... #
# compile
$(OBJDIR)/%.o: $(SRCDIR)/%$(EXTENSION_CODE)
	$(call boxtop)
	$(call boxtext, "attempting to compile...")
	
	@mkdir -p $(DIRECTORIES)
	
	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LBLUE)"
	@printf "%-75b %s" "  Compiling:  $(COLOR_LYELLOW)$<$(COLOR_END)"
	
	@-$(CXX) $(CXXFLAGS) -c $< -o $@ -I $(INCDIR)

	@printf "%-20b" "$(MSG_OK)"
	@printf "$(COLOR_BLUE)|\n"
	
	$(call boxtext, "done.")
	$(call boxbottom)
	
# ........................................................................... #
# link
$(EXENAME): $(OBJ)
	$(call boxtop)
	$(call boxtext, "attempting to link...")
	
	@mkdir -p $(EXEDIR)
	
	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LBLUE)"
	@printf "%-85b %s" "  Linking:  $(COLOR_LYELLOW)$<$(COLOR_END)"
	@printf "$(COLOR_BLUE)|\n"
	
	@$(CXX) $^ -o $(EXEDIR)/$(EXENAME) $(LDFLAGS)
	
	$(call boxtext, "done.")
	$(call boxtop)
	
	
	@printf "$(COLOR_BLUE)"
	@printf "| "
	@printf "$(COLOR_LBLUE)"
	@printf "%-81b %s " "Executable: $(COLOR_LYELLOW)$(EXEDIR)/$(EXENAME)"
	@printf "$(COLOR_BLUE)|\n"
	
	$(call boxbottom)
	
# --------------------------------------------------------------------------- #
execute:
	@./$(EXEDIR)/$(EXENAME)
	
# --------------------------------------------------------------------------- #
valgrind :
	@valgrind ./$(EXEDIR)/$(EXENAME)
	
# --------------------------------------------------------------------------- #
clean:
	@printf "$(COLOR_LCYAN)"
	@echo "#=============================================================================#"
	@echo "# attempting to clean...                                                      #"
	
	@rm -rf $(OBJDIR)
	@rm -f $(EXEDIR)/$(EXENAME)
	
	@echo "# done.                                                                       #"
	@echo "#=============================================================================#"
	@echo ""
	
# --------------------------------------------------------------------------- #
vars :
	@clear
	$(call fatbox, "variables dump:")
	
	@echo "SRCDIR          : $(SRCDIR)"
	@echo "INCDIR          : $(INCDIR)"
	@echo "OBJDIR          : $(OBJDIR)"
	@echo "EXEDIR          : $(EXEDIR)"
	@echo ""
	@echo "DIRECTORIES     : $(DIRECTORIES)"
	@echo ""
	@echo "EXTENSION_CODE  :" $(EXTENSION_CODE)
	@echo "EXTENSION_HEADER:" $(EXTENSION_HEADER)
	@echo ""
	@echo "EXENAME         : $(EXENAME)"
	@echo "SRC             : $(SRC)"
	@echo "INC             : $(INC)"
	@echo "OBJ             : $(OBJ)"
	
	$(call fatbox, "done.")
# --------------------------------------------------------------------------- #
gitinit :
	@clear
	$(call fatbox, "Setting up GIT repository with name \"$(EXENAME)\"")
	@echo ""
	@echo "Note that this assumes there exists a repository named"
	@echo "   $(COLOR_CYAN)$(EXENAME)$(COLOR_END)"
	@echo "under the adress"
	@echo "   $(COLOR_CYAN)$(GIT_BASE)/$(GIT_USERNAME)$(COLOR_END)"
	@echo ""
	
	@git init
	@git remote add origin $(GIT_BASE)/$(GIT_USERNAME)/$(EXENAME).git
	
# --------------------------------------------------------------------------- #
gitadds :
	@git add ./$(SRCDIR)
	@git add ./$(INCDIR)
	
	@git config credential.helper store
	@git config --global credential.helper 'cache --timeout 7200'
	
	@if [ -n "$(GIT_ADDITIONAL)" ]; then git add $(GIT_ADDITIONAL); fi           # -n: true if string length is nonzero 
	@echo here
	@if [ -n "$(GIT_EXCLUDE)" ]; then git rm -r --cached $(GIT_EXCLUDE); fi
	
	@echo ""
	@git status
	
	@echo "Reader for checkin. Type"
	@echo "   $(COLOR_CYAN)git commit -m \"version comments\"$(COLOR_END)"
	@echo "   $(COLOR_CYAN)git push$(COLOR_END)"
	@echo "to upload the current status"
	@echo ""
	
# --------------------------------------------------------------------------- #
gitremove :
	@printf "$(COLOR_LCYAN)"
	@echo "#=============================================================================#"
	@echo "# Removing all local data for a GIT repository                                #"
	@echo "# This will not affect the data in the repository.                            #"
	
	@rm -rf ./.git
	
	@echo "# done.                                                                       #"
	@echo "#=============================================================================#"
	@echo ""
# --------------------------------------------------------------------------- #
gitsetmasterhint :
	@echo "type"
	@echo "   $(COLOR_CYAN)make gitsetmaster$(COLOR_END)"
	@echo "to finalize the process after adjusting the staging area."
	@echo ""
# --------------------------------------------------------------------------- #
gitsetmaster :
	@git commit -m "initial commit"
	@git push --set-upstream origin master
# --------------------------------------------------------------------------- #
help :
	@echo "This makefile supports the following targets:"
	@echo "$(COLOR_LCYAN)clean:$(COLOR_END)"
	@echo "   removes $(OBJDIR) and its contents."
	@echo "$(COLOR_LCYAN)generate:$(COLOR_END)"
	@echo "   compiles any files that may have changed since the last time this was run"
	@echo "$(COLOR_LCYAN)run:$(COLOR_END)"
	@echo "   compiles all files and runs the program thereafter"
	@echo "$(COLOR_LCYAN)grind:$(COLOR_END)"
	@echo "   compiles all files and runs the program via valgrind"
	@echo ""
	@echo "$(COLOR_LCYAN)gitstart:$(COLOR_END)"
	@echo "   sets up the working directory for git and prepares an initial commit"
	@echo "$(COLOR_LCYAN)gitsetmaster:$(COLOR_END)"
	@echo "   sets the master branch and pushes the initial commit. Run only once"
	@echo "$(COLOR_LCYAN)gitadds:$(COLOR_END)"
	@echo "   adds files to the staging area."
	@echo "$(COLOR_LCYAN)gitremove:$(COLOR_END)"
	@echo "   removes all local data of the versioning system"
