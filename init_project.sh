#!/bin/sh

mkdir -p \
	data/raw \
	data/clean \
	data/figs \
	stats/ \
	figs/


# Top Makefile
cat << 'EOF' > Makefile
# Project Makefile

STATS = ./stats
FIGS  = ./figs

.PHONY: all clean stats clean_stats figs clean_figs

all: stats figs

clean: clean_stats clean_figs

stats:
	$(MAKE) -C $(STATS)

clean_stats:
	$(MAKE) -C $(STATS) clean

figs:
	$(MAKE) -C $(FIGS)

clean_figs:
	$(MAKE) -C $(FIGS) clean
EOF


# --- STATS ---
cat << 'EOF' > ./stats/Makefile
# Statistical analysis makefile
#
# Modify config.mk to include R files and

R = Rscript --vanilla -e

include config.mk

.SUFFIXES: .R .log 
.R.log: 
	$(R) "source('$<', echo=T, keep.source=T, max.deparse.length=Inf)" > $@ || (rm -f $@; exit 1)
	rm -f *.pdf

stats: $(LOGS)

clean:
	rm -f $(LOGS)
EOF

cat << 'EOF' > ./stats/config.mk
# Configuration for data analysis Makefile

# log files to be produced by R scripts
# example:
# run 01_bar.R and 02_boo.R
# LOGS = 01_bar.log \
#	02_foo.log
LOGS = 

# output data produced for plotting
# example:
# OUTPUT_DATA = $(DATADIR)/01_foo.dat\
#	$(DATADIR)/02_bar.dat

DATADIR = ../data/figs
OUTPUT_DATA = 
EOF


# --- FIGURES ---
cat << 'EOF' > ./figs/Makefile
# Figures Makefile

include config.mk

# Gnuplot
.SUFFIXES: .gp .pdf
.gp.pdf:
	gnuplot -e "OUTPUT='$@'" $<


# R
#.SUFFIXES: .R .pdf
#.R.pdf:
#       Rscript --vanilla $< $@


figs: $(PDFs)

clean:
	rm -f $(PDFs)

.PHONY: figs clean
EOF


cat << 'EOF' > ./figs/config.mk
# Configuration for figures Makefile

# list PDFs plots
# example:
# PDFs = bar.pdf \
#	foo.pdf
PDFs =
EOF
