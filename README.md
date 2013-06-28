AutoKariotyping
===============

Matlab scripts to **computationally support automatic kariotyping**, that is, from a given image of chromossomes, identify and list each pair of chromosomes.

It uses image manipulation in matlab to clean and separate each chromossome in the image, and then performs signal analysis on the chromosome bands to perform pairing.

Entry point: `ChromossomeKaryotype(filename)` *(ChromossomeKaryotype.m)*