# Extracts mean formant values dynamically across an duration defined by the textgrid and the user.
# The interval label specifies the starting point for extracting formant data. The duration specifies the duration over which 
# formants are extracted. For example, specifying the interval label as v1 (the initial vowel) and the duration as 0.1 will 
# extract formant values over the initial 100 ms. of the vowel. The number of interval values extracted is equal to 
# numintervals below. Writes results to a textfile.
# Christian DiCanio, 2013.

numintervals = 5
#Number of intervals you wish to extract pitch from.

form Extract Formant data from labelled points
   sentence Directory_name: /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled_mono/edited/done
   sentence Temporary_path: /Users/chloe/ejectives_abx/essais
   sentence Interval_label 
   sentence Log_file Vowel
   positive Labeled_tier_number 7
   positive Analysis_points_time_step 0.005
   positive Record_with_precision 1
   comment Formant Settings:
   positive Analysis_time_step 0.005
   positive Maximum_formant 5500
   positive Number_formants 5
   positive Number_tracks 3
   positive F1_ref 500
   positive F2_ref 1485
   positive F3_ref 2450
   positive F4_ref 3550
   positive F5_ref 4650
   positive Window_length 0.005
   positive Duration 0.1
endform

maxf = maximum_formant

# If your sound files are in a different format, you can insert that format instead of wav below.
# Resampling done for LPC analysis.

Create Strings as file list... list 'directory_name$'/*.wav
num = Get number of strings
for ifile to num
	select Strings list
	fileName$ = Get string... ifile
	Read from file... 'directory_name$'/'fileName$'
	soundID1$ = selected$("Sound")
#	Resample... 16000 50
	soundID2 = selected("Sound")
	Read from file... 'directory_name$'/'soundID1$'.TextGrid
	textGridID = selected("TextGrid")
	num_labels = Get number of intervals... labeled_tier_number

	fileappend 'directory_name$'/'log_file$'.txt label'tab$'

	for i to numintervals
		fileappend 'temporary_path$'/'log_file$'.txt 'i'F1'tab$''i'F2'tab$''i'F3'tab$'
	endfor
	fileappend 'temporary_path$'/'log_file$'.txt 'newline$'

	for i to num_labels
		select 'textGridID'
		label$ = Get label of interval... labeled_tier_number i
			if label$ = "a" or label$ = "e" or label$ = "i" or label$ = "o" or label$ = "u" 
				debut = Get start point: labeled_tier_number, i
				seq = Get interval at time... 1 debut
				mot$ = Get label of interval... 1 debut
				
				fileappend 'temporary_path$'/'log_file$'.txt 'fileName$''tab$'
	      			intvl_start = Get starting point... labeled_tier_number i
				intvl_end = intvl_start+'duration'
				select 'soundID2'
				Extract part... intvl_start intvl_end Rectangular 1 no
				intID = selected("Sound")	
				chunkID  = (intvl_end-intvl_start)/numintervals
	
				for j to numintervals
	
					#Getting formants and frequency boundaries 10% away from them. Writing to data file.

					select 'intID'
					Extract part... (j-1)*chunkID j*chunkID Rectangular 1 no
					chunk_part = selected("Sound")
					form_chunk = To Formant (burg)... 0 'number_formants' 'maxf' 'window_length' 50
					formantID_bf = selected("Formant")
					Track... 'number_tracks' 'f1_ref' 'f2_ref' 'f3_ref' 'f4_ref' 'f5_ref' 1 1 1
					formantID = selected("Formant")
					f1 = Get mean... 1 0 0 Hertz
					f1_a = f1-(f1/10)
					f1_b = f1+(f1/10)
					f2 = Get mean... 2 0 0 Hertz
					f2_a = f2-(f2/10)
					f2_b = f2+(f2/10)
					f3 = Get mean... 3 0 0 Hertz
					f3_a = f3-(f3/10)
					f3_b = f3+(f3/10)
						if j = numintervals
						fileappend 'temporary_path$'/'log_file$'.txt
	 	           			... 'label$' 'mot$' 'j' 'f1:2''tab$''f2:2''tab$''f3:2''newline$'
						else
						fileappend 'temporary_path$'/'log_file$'.txt
	   	         			... 'label$' 'mot$' 'j' 'f1:2''tab$''f2:2''tab$''f3:2''tab$'
						endif
					select 'chunk_part'
					Remove
					select 'formantID_bf'
					Remove
					select 'formantID'
					Remove
				endfor
				select 'intID'
				Remove
			else
				#do nothing
	   		endif
	endfor
	select 'soundID2'
	Remove
	select 'textGridID'
	Remove
endfor
select all
Remove