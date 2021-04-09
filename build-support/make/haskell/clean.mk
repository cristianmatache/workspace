clean-hs:
	find . -name *.hi | xargs rm -f && find . -name *.o | xargs rm -f;
