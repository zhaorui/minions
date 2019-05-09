
f.dylib:
	cc -dynamiclib -o f.dylib f.c

yaygotf: f.dylib	
	cc -o yaygotf whatnof.c f.dylib

whatnof: yaygotf
	touch null.c
	cc -dynamiclib -o f.dylib null.c
	mv yaygotf whatnof

clean:
	rm -f *.o *.dylib whatnof yaygotf

.PHONY: clean