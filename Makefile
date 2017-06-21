# Run the emblem2rdf pipeline
#
# Timestamp: <2017-06-21 16:31:08 maus>
#

TEMPDIR := /tmp

SOURCE := $(TEMPDIR)/records.xml
TARGET := $(TEMPDIR)/emblem

%.nt: %.rdf
	rapper -q -i rdfxml -o ntriples $< > $(basename $<).nt

all: $(TARGET).nt

$(TARGET).rdf: $(SOURCE)
	calabash -i $(SOURCE) -o result=$(TARGET).rdf src/xproc/emblem2rdf.xpl emblems=$(TARGET)

$(SOURCE):
	python2 ~/bin/pyoaiharvest.py -l http://oai.hab.de -s embl -m emblem -o $(SOURCE)

.PHONY: clean
clean:
	rm -f $(TARGET).*
	rm -f $(TARGET)/*
