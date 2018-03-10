# Get Pa value at time script
# EGG information extraction
# Total duration of each file is 129 ms
# Time step = 0.005? (based on max pitch = 200Hz)

form Get an estimate of the amplitude at regular times
	comment Directory of EGG files (include final slash)
	text egg_directory /Users/chloe/features_extraction/test/wavs/
	sentence egg_file_extension .wav
	comment Full path of the resulting csv file
	text resultsfile /Users/chloe/features_extraction/test/wavs/egg.csv
endform

Create Strings as file list... list 'egg_directory$'*'egg_file_extension$'
num = Get number of strings

if fileReadable (resultsfile$)
	pause The file 'resultsfile$' already exists! Do you want to overwrite it?
	filedelete 'resultsfile$'
endif

header$ = "#file time_0 time_1 time_2 time_3 time_4 time_5 time_6 time_7 time_8 time_9 time_10 time_11 time_12 time_13 time_14 time_15 time_16 time_17 time_18 time_19 time_20 time_21 time_22 time_23 time_24 'newline$'"
fileappend "'resultsfile$'" 'header$'

for ifile to num
	filename$ = Get string... ifile
	Read from file... 'egg_directory$''filename$'
	soundname$ = selected$ ("Sound", 1)

	a = Get value at time: 1, 0.005, "Sinc70"
	b = Get value at time: 1, 0.010, "Sinc70"
	c = Get value at time: 1, 0.015, "Sinc70"
	d = Get value at time: 1, 0.020, "Sinc70"
	ee = Get value at time: 1, 0.025, "Sinc70"
	f = Get value at time: 1, 0.030, "Sinc70"
	g = Get value at time: 1, 0.035, "Sinc70"
	h = Get value at time: 1, 0.040, "Sinc70"
	i = Get value at time: 1, 0.045, "Sinc70"
	j = Get value at time: 1, 0.050, "Sinc70"
	k = Get value at time: 1, 0.055, "Sinc70"
	l = Get value at time: 1, 0.060, "Sinc70"
	m = Get value at time: 1, 0.065, "Sinc70"
	n = Get value at time: 1, 0.070, "Sinc70"
	o = Get value at time: 1, 0.075, "Sinc70"
	p = Get value at time: 1, 0.080, "Sinc70"
	q = Get value at time: 1, 0.085, "Sinc70"
	r = Get value at time: 1, 0.090, "Sinc70"
	s = Get value at time: 1, 0.095, "Sinc70"
	t = Get value at time: 1, 0.100, "Sinc70"
	u = Get value at time: 1, 0.105, "Sinc70"
	v = Get value at time: 1, 0.110, "Sinc70"
	w = Get value at time: 1, 0.115, "Sinc70"
	x = Get value at time: 1, 0.120, "Sinc70"
	y = Get value at time: 1, 0.125, "Sinc70"

	fileappend "'resultsfile$'" 'soundname$' 'a:4' 'b:4' 'c:4' 'd:4' 'ee:4' 'f:4' 'g:4' 'h:4' 'i:4' 'j:4' 'k:4' 'l:4' 'm:4' 'n:4' 'o:4' 'p:4' 'q:4' 'r:4' 's:4' 't:4' 'u:4' 'v:4' 'w:4' 'x:4' 'y:4' 'newline$'

	select Sound 'soundname$'
    Remove
    # and go on with the next sound file!
    select Strings list

endfor

select all
Remove
