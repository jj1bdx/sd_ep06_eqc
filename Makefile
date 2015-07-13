all: eqc-compile build

build:
	cd ebin
	erlc ../src/msgcounter_gen_server.erl
	erlc ../src/msgcounter_eqc.erl

eqc-compile:
	mkdir -p ebin
	erl -make
