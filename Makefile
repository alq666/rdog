.PHONY: all test package prep clean

all: package

package: test
	R CMD build rdog

test: prep
	R CMD check rdog

prep: clean
	mkdir rdog
	cp -a R rdog/
	cp -a man rdog/
	cp -a DESCRIPTION rdog/
	cp -a LICENSE rdog/
	cp -a NAMESPACE rdog/

clean:
	-rm -rf rdog
	-rm -rf rdog.Rcheck
