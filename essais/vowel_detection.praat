form Extract Formant data from labelled points
   sentence Directory_name: /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled_mono
   positive Analysis_points_time_step 0.010
   positive Window_length 0.005
   sentence new_label vowel
endform

Create Strings as file list... list 'directory_name$'/*.wav
num = Get number of strings
for ifile to num
  select Strings list
  fileName$ = Get string... ifile
  Read from file... 'directory_name$'/'fileName$'
  soundID1$ = selected$("Sound")

  Read from file... 'directory_name$'/'soundID1$'.TextGrid
  textGridID = selected("TextGrid")

  num_tiers = Get number of tiers
  new_tier = num_tiers + 1
  Insert interval tier... new_tier voyelle

  start_word = Get starting point... 1 2
  #end_word = Get ending point... 1 2
  #Insert boundary... new_tier start_word  
  #Insert boundary... new_tier end_word
	
  Read from file... 'directory_name$'/'fileName$'
  soundID1$ = selected$("Sound")
  intensity_object = To Intensity: 100, 0
  n = Get number of frames
  started = 0
  for i to n-1
    intensity = Get value in frame: i
  
    if intensity > 69 and started = 0
       time = Get time from frame: i
       selectObject: textGridID
       Insert boundary... new_tier time
       started = 1
       selectObject: intensity_object
    endif
    

    if intensity < 69 and started = 1
       time = Get time from frame: i
       selectObject: textGridID
       Insert boundary... new_tier time
       started = 0
       selectObject: intensity_object
    endif

  endfor

	selectObject: textGridID
	Save as text file... 'directory_name$'/edited/'soundID1$'.TextGrid

	select all
	minus Strings list
	Remove

endfor

    #time = Get time from frame: i
	#intensityN = Get value at time: time, "Cubic"
	#appendInfoLine: "Onset of sound at: ", time, " seconds. Object 32."
	#appendInfoLine: intensityN
    #exit
    #endif
    