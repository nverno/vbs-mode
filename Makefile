emacs ?= emacs
batch := $(emacs) -batch

loadpath = .

auto ?= vbs-mode-autoloads.el

el = $(filter-out $(auto),$(wildcard *.el))
elc = $(el:.el=.elc)

compile_flags = \
	--eval "(let ((default-directory (expand-file-name \".emacs.d/elpa\" \"~\"))) \
	          (normal-top-level-add-subdirs-to-load-path))"
auto_flags= \
	--eval "(let ((generated-autoload-file \
                      (expand-file-name (unmsys--file-name \"$@\"))) \
                      (wd (expand-file-name default-directory)) \
                      (backup-inhibited t) \
                      (default-directory (expand-file-name \".emacs.d/elpa\" \"~\"))) \
                   (normal-top-level-add-subdirs-to-load-path) \
                   (update-directory-autoloads wd))"

.PHONY: all $(auto) clean test

all : compile $(auto)

compile : $(elc)
%.elc : %.el
	$(batch) $(compile_flags) -L $(loadpath) -f batch-byte-compile $<

$(auto):
	$(batch) -L $(loadpath) $(auto_flags)

TAGS: $(el)
	$(RM) $@
	touch $@
	ls $(el) | xargs etags -a -o $@

test:
	@cd test && $(emacs) -Q -l nvp-test-init.el

clean:
	$(RM) *~

distclean: clean
	$(RM) *autoloads.el *loaddefs.el TAGS *.elc
