# Get Pa value at time script
# EGG information extraction
# Total duration of each file is 129 ms
# Time step = 0.005? (based on max pitch = 200Hz)

form Get an estimate of the amplitude at regular times
	comment Directory of EGG files (include final slash)
	text egg_directory /Users/chloe/features_extraction/test/wavs/
	sentence egg_file_extension .wav
	comment Full path of the resulting csv file
	text resultsfile /Users/chloe/ejectives_abx/results/egg_fixed/egg_1000.csv
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
	a_1000 = a * 1000
	b = Get value at time: 1, 0.010, "Sinc70"
	b_1000 = b * 1000
	c = Get value at time: 1, 0.015, "Sinc70"
	c_1000 = c * 1000
	d = Get value at time: 1, 0.020, "Sinc70"
	d_1000 = d * 1000
	ee = Get value at time: 1, 0.025, "Sinc70"
	ee_1000 = ee * 1000
	f = Get value at time: 1, 0.030, "Sinc70"
	f_1000 = f * 1000
	g = Get value at time: 1, 0.035, "Sinc70"
	g_1000 = g * 1000
	h = Get value at time: 1, 0.040, "Sinc70"
	h_1000 = h * 1000
	i = Get value at time: 1, 0.045, "Sinc70"
	i_1000 = i * 1000
	j = Get value at time: 1, 0.050, "Sinc70"
	j_1000 = j * 1000
	k = Get value at time: 1, 0.055, "Sinc70"
	k_1000 = k * 1000
	l = Get value at time: 1, 0.060, "Sinc70"
	l_1000 = l * 1000
	m = Get value at time: 1, 0.065, "Sinc70"
	m_1000 = m * 1000
	n = Get value at time: 1, 0.070, "Sinc70"
	n_1000 = n * 1000
	o = Get value at time: 1, 0.075, "Sinc70"
	o_1000 = o * 1000
	p = Get value at time: 1, 0.080, "Sinc70"
	p_1000 = p * 1000
	q = Get value at time: 1, 0.085, "Sinc70"
	q_1000 = q * 1000
	r = Get value at time: 1, 0.090, "Sinc70"
	r_1000 = r * 1000
	s = Get value at time: 1, 0.095, "Sinc70"
	s_1000 = s * 1000
	t = Get value at time: 1, 0.100, "Sinc70"
	t_1000 = t * 1000
	u = Get value at time: 1, 0.105, "Sinc70"
	u_1000 = u * 1000
	v = Get value at time: 1, 0.110, "Sinc70"
	v_1000 = v * 1000
	w = Get value at time: 1, 0.115, "Sinc70"
	w_1000 = w * 1000
	x = Get value at time: 1, 0.120, "Sinc70"
	x_1000 = x * 1000
	y = Get value at time: 1, 0.125, "Sinc70"
	y_1000 = y * 1000

	fileappend "'resultsfile$'" 'soundname$' 'a_1000:4' 'b_1000:4' 'c_1000:4' 'd_1000:4' 'ee_1000:4' 'f_1000:4' 'g_1000:4' 'h_1000:4' 'i_1000:4' 'j_1000:4' 'k_1000:4' 'l_1000:4' 'm_1000:4' 'n_1000:4' 'o_1000:4' 'p_1000:4' 'q_1000:4' 'r_1000:4' 's_1000:4' 't_1000:4' 'u_1000:4' 'v_1000:4' 'w_1000:4' 'x_1000:4' 'y_1000:4' 'newline$'

	select Sound 'soundname$'
    Remove
    # and go on with the next sound file!
    select Strings list

endfor

select all
Remove
