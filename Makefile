.PHONY: rescan
rescan:
	./script/rescan.sh debian
	./script/rescan.sh ubuntu

.PHONY: clean
clean:
	-rm --recursive ./cache
