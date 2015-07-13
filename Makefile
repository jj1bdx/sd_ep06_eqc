all: eqc-compile

eqc-compile:
	mkdir -p ebin
	erl -make
