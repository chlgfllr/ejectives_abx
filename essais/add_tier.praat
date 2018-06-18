form Extract Formant data from labelled points
   sentence Directory_name: /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled_mono/edited/done/s09_audio_files
   sentence new_label burst
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
  Insert interval tier... new_tier new_label$

	selectObject: textGridID
	Save as text file... 'directory_name$'/'soundID1$'.TextGrid

	select all
	minus Strings list
	Remove

endfor