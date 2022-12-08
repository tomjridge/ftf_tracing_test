M:=./_build/default/main.exe

default: all

all:
	dune build main.exe  # NOTE require .exe here, but not in dune file?

run:
	time $(M)


