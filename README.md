jammy
=====

A musical accompaniment system, trained using Echo State Networks to listen to a leading track (default: guitar) and play along by generating an accompanying track (default: bass). The code is not yet in a solid state (only minor error checking), and it is what I am using for my Bachelor Thesis.


<b> File structure </b>: 

<b> /music/ </b> : main scripts

<b> /music/csv/ </b>: This is where I currently keep all the csv files.

<b> /music/midi/ </b>: This is where I keep midi files

<b>/music/Sample Results/ </b>: samples of melodies produced by the system, visualized using the Music Animation Machine. The top (purple) line is the leading track, the bbttom one is the network produced accompanying track.


<b> Prerequisites </b>:

Besides matlab, the tools <a href='http://www.fourmilab.ch/webtools/midicsv/'>midicsv and csvmidi</a> are needed to convert between midi and csv files. The script expects csv files created by midicsv.

<b> Main Scripts </b>: 

<b>read\_mixed\_csv.m </b>: Reads the midi information from a csv file (the result of converting the midi file to csv using midicsv) into matlab structures.

<b>music.m </b>: To train the network (file names are hard-coded) All training and testing data should be in 1 file.

<b> continue_run.m </b>: To run the network. In the top rows it is determined which portion of the data will be used as testing data.

<b> noteToVector.m </b>: Converts a midi note (pitch) to a 5 dimensional vector that represents that note. (described in the paper)

<b> durationToVector.m </b>: Converts a midi duration in the representation used by the network (essentially, just applying a logarithmic transform for now)

<b> teachNote.m, teachDur.m </b>: Convert a midi note/duration into the representation of notes used in the output units

<b> select.m </b>: Interprets the network output and selects the next note on the accompanying track. The third argument specifies the type of selection (1 : deterministic, 0: non-deterministic selection)

<b> Limitations </b>: 


1. For each of the 2 instruments the system currently supports only 1 voice (1 line of melody). This also means that chords are not yet supported. Whenever chords appear in the train/test data, only the top note is selected.

