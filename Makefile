all: eqc-compile

eqc-compile:
	-mkdir ebin
	erl -make
