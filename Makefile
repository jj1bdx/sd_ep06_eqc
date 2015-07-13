all: build eqc-compile

build:
	erlc src/msgcounter_eqc.erl
	erlc src/msgcounter_gen_server.erl

eqc-compile:
	mkdir -p ebin
	erl -make
