# Run the emblem2rdf pipeline
#
# Timestamp: <2017-03-05 12:56:53 dmaus>
#

TEMPDIR := /tmp

ERRORS := $(TEMPDIR)/errors.log
SOURCE := $(TEMPDIR)/records.xml
TARGET := $(TEMPDIR)/emblem

%.nt: %.rdf
	rapper -q -i rdfxml -o ntriples $< > $(basename $<).nt

all: $(TARGET).nt

$(TARGET).rdf: $(SOURCE)
	calabash -i $(SOURCE) -o $(TARGET).rdf src/xproc/emblem2rdf.xpl emblems=$(TARGET) errors=$(ERRORS)

$(SOURCE):
	python2 ~/bin/pyoaiharvest.py -l http://oai.hab.de -s embl -m emblem -o $(SOURCE)

.PHONY: clean
clean:
	rm -f $(TARGET).*
	rm -f $(TARGET)/*
	rm -f $(ERRORS)*
