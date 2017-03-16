# Run the emblem2rdf pipeline
#
# Timestamp: <2017-03-16 13:54:35 maus>
#

TEMPDIR := /tmp

ERRORS := $(TEMPDIR)/errors.log
SOURCE := $(TEMPDIR)/records.xml
TARGET := $(TEMPDIR)/emblem
BEACON := $(TEMPDIR)/beacon.rdf

%.nt: %.rdf
	rapper -q -i rdfxml -o ntriples $< > $(basename $<).nt

all: $(TARGET).nt

$(TARGET).rdf: $(SOURCE)
	calabash -i $(SOURCE) -o result=$(TARGET).rdf -o beacon=$(BEACON) src/xproc/emblem2rdf.xpl emblems=$(TARGET) errors=$(ERRORS)

$(SOURCE):
	python2 ~/bin/pyoaiharvest.py -l http://oai.hab.de -s embl -m emblem -o $(SOURCE)

.PHONY: clean
clean:
	rm -f $(TARGET).*
	rm -f $(TARGET)/*
	rm -f $(ERRORS)*
	rm -f $(BEACON)
