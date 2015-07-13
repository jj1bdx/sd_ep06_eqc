all: build eqc-compile

build:
	mkdir -p ebin
	(cd ebin && erlc ../src/msgcounter_eqc.erl)
	(cd ebin && erlc ../src/msgcounter_gen_server.erl)

eqc-compile:
	erl -make
