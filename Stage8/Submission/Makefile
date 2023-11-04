GHDL=ghdl
GHDLFLAGS=
MODULES=\
	MyTypes.o \
	mem.o \
	alu.o \
	pc.o \
	shifter1.o \
	shifter2.o \
	shifter4.o \
	shifter8.o \
	shifter16.o \
	shifter.o \
	rf.o \
	flags.o \
	multiplier.o \
	mux.o \
	mux4.o \
	pmconnect.o \
	decoder.o \
	fsm.o \
	datapath.o \
	processor.o \
	processor_tb.o \
	processor_tb


test: $(MODULES)

# Binary depends on the object file
%: %.o
	$(GHDL) -r $(GHDLFLAGS) $@ --vcd=test.vcd
	gtkwave test.vcd


# Object file depends on source
%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<
