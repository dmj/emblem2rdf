rng:
	trang -I rnc -O rng src/schema/emblem2rdf.rnc src/schema/emblem2rdf.rng
clean:
	rm -f output/emblems.*
	rm -f output/emblems/*
