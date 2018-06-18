# Extracts mean formant values dynamically across an duration defined by the textgrid and the user.
# The interval label specifies the starting point for extracting formant data. The duration specifies the duration over which 
# formants are extracted. For example, specifying the interval label as v1 (the initial vowel) and the duration as 0.1 will 
# extract formant values over the initial 100 ms. of the vowel. The number of interval values extracted is equal to 
# numintervals below. Writes results to a textfile.
# Christian DiCanio, 2013.
# Creates a datafile with acoustic measures and metalinguistic parameters.
# Defines a fixed width window
# Creates separate audio files for each sound window that is used
#Copyright Christian DiCanio, Haskins Laboratories, October 2011.
# Version mars 2018
#Number of intervals you wish to extract pitch from.

form Extract VOT measures from TextGrid
	sentence Sound_directory: /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled_mono/edited/done/all_audio_files/
	sentence Sound_file_extension .wav
	sentence TextGrid_directory /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled_mono/edited/done/all_audio_files/
	sentence TextGrid_file_extension .TextGrid
	text resultsfile /Users/chloe/ejectives_abx/essais/all_audio_files.item
	comment Which tier do you want to analyze?
	integer Tier 3
endform

# Make a listing of all the sound files in a directory:
Create Strings as file list... list 'sound_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultsfile$)
	pause The file 'resultsfile$' already exists! Do you want to overwrite it?
	filedelete 'resultsfile$'
endif

# onset and offset are taken for variable window (CV sequence) and fixed window (centered on oral burst, -0.02 +0.109)
num = Get number of strings
header$ = "#file burst dur_burst dur_lag dur_creak dur_vowel onset_creak onset_vowel offset_vot item sequence syllables type place vowel position speaker question new bad_vot constriction vowelduration check_vowel good_vot 'newline$'"
fileappend "'resultsfile$'" 'header$'

for ifile to num
	#select Strings list
	filename$ = Get string... ifile
	ref$ = mid$("'filename$'",1,17)
	speaker$ = mid$("'filename$'",7,3)
	focus$ = mid$("'filename$'",14,1)
	Read from file... 'sound_directory$''filename$'
	soundname$ = selected$ ("Sound", 1)

	Read from file... 'sound_directory$'/'filename$'

	# Look for a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"

	# if a TextGrid exists, open it and do the analysis:
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		
        select TextGrid 'soundname$'

        # get the name of the sound object:
		#soundname$ = selected$ ("Sound", 1)

		word$ = Get label of interval... 1 2
		total_syll = Get number of intervals... 2
		syllable_count = total_syll - 2

		ints = Get number of intervals... tier
        
		# Pass through all intervals in the designated tier, and if they have a label, do the analysis:
		for i to ints
            segment$ = Get label of interval... 'tier' i
            start = Get start point... 'tier' i
            
            s = Get interval at time: 2, start
            
        
        	if segment$ = "p>"
        	    start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 8, end
                oral_burst = Get start point: 8, x

                verif$ = Get label of interval: 8, x

                if verif$ = "burst"
                    debut_burst = Get start point... 8 x
                    fin_burst = Get end point... 8 x
                    duree_burst = (fin_burst - debut_burst)*1000
                    next$ = Get label of interval... 8 x+1
                    if next$ = "lag"
                        debut_lag = Get start point... 8 x+1
                        fin_lag = Get end point... 8 x+1
                        duree_lag = (fin_lag - debut_lag)*1000
                    elsif next$ = "creak"
                        duree_lag = 0
                        debut_creak = Get start point... 8 x+1
                        fin_creak = Get end point... 8 x+1
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif next$ = "vowel"
                        duree_lag = 0
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+1
                        fin_vowel = Get end point... 8 x+1
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    endif
                    following$ = Get label of interval... 8 x+2
                    if following$ = "creak"
                        debut_creak = Get start point... 8 x+2
                        fin_creak = Get end point... 8 x+2
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif following$ = "vowel"
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+2
                        fin_vowel = Get end point... 8 x+2
                        duree_vowel = (fin_vowel - debut_vowel)*1000                    
                    endif
                    final$ = Get label of interval... 8 x+3
                    if final$ = "vowel"
                        debut_vowel = Get start point... 8 x+3
                        fin_vowel = Get end point... 8 x+3
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    elsif final$ != "vowel" & following$ != "vowel" & next$ != "vowel"
                        duree_vowel = 0
                    endif
                else
                    verif$ = "erreur"
                endif

                left = oral_burst - 0.02
                right = oral_burst + 0.109

                position$ = Get label of interval... 2 s

                if position$ = "1"
                    initial$ = "initial"
                    log$ = "1_"
                elsif position$ = "2"
                    initial$ = "medial"
                    log$ = "2_"
                elsif position$ = "3"
                    initial$ = "medial"
                    log$ = "3_"
                endif

                vowel$ = Get label of interval... 3 i+1
                sequence$ = segment$ + vowel$
            	vowel_start = Get start point: 3, i+1
                vowel_end = Get end point: 3, i+1
                vowelduration = (vowel_end - vowel_start) * 1000

                y = Get interval at time... 7 oral_burst      
                vot_check$ = Get label of interval... 7 y+1
                
                if vot_check$ = vowel$
                	vot_start = Get start point: 7, y+1
                endif

                vot = (vot_start - oral_burst) * 1000
                                                
                type$ = "ejective"
                place$ = "labial"
                 
                quest$ = mid$("'filename$'",17,1)
                     
                if quest$ = "1"
                    question$ = "question"
                else
                    question$ = "answer"
                endif
                 
                if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                    echo$ = "new"
                elsif focus$ = "2" or focus$ = "4" or focus$ = "6" or focus$ = "8" or focus$ = "0"
					if question$ = "question"
                    	echo$ = "new"
                    elsif question$ = "answer"
                        echo$ = "echo"
                    endif
				endif

                numero = randomInteger (0, 10000)
                new_name$ = log$ + string$(numero)

				v = Get interval at time: 5, end
				#extendVOT$ = Get label of interval: 5, v
				extendVOT_start = Get start point: 5, v
				extendVOT_end = Get end point: 5, v
				extendVOT_duration = (extendVOT_end - extendVOT_start) * 1000
            
            	constriction_duration = ((end - start) * 1000)

                #select Sound 'soundname$'
                #Extract part: left, right, "rectangular", 1, "yes"
                #Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'verif$' 'duree_burst:2' 'duree_lag:2' 'duree_creak:2' 'duree_vowel:2' 'debut_creak:6' 'debut_vowel:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'vot_check$' 'vot:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'

            elsif segment$ = "t>" 
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 8, end
                oral_burst = Get start point: 8, x

                verif$ = Get label of interval: 8, x

                if verif$ = "burst"
                    debut_burst = Get start point... 8 x
                    fin_burst = Get end point... 8 x
                    duree_burst = (fin_burst - debut_burst)*1000
                    next$ = Get label of interval... 8 x+1
                    if next$ = "lag"
                        debut_lag = Get start point... 8 x+1
                        fin_lag = Get end point... 8 x+1
                        duree_lag = (fin_lag - debut_lag)*1000
                    elsif next$ = "creak"
                        duree_lag = 0
                        debut_creak = Get start point... 8 x+1
                        fin_creak = Get end point... 8 x+1
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif next$ = "vowel"
                        duree_lag = 0
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+1
                        fin_vowel = Get end point... 8 x+1
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    endif
                    following$ = Get label of interval... 8 x+2
                    if following$ = "creak"
                        debut_creak = Get start point... 8 x+2
                        fin_creak = Get end point... 8 x+2
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif following$ = "vowel"
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+2
                        fin_vowel = Get end point... 8 x+2
                        duree_vowel = (fin_vowel - debut_vowel)*1000                    
                    endif
                    final$ = Get label of interval... 8 x+3
                    if final$ = "vowel"
                        debut_vowel = Get start point... 8 x+3
                        fin_vowel = Get end point... 8 x+3
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    elsif final$ != "vowel" & following$ != "vowel" & next$ != "vowel"
                        duree_vowel = 0
                    endif
                else
                    verif$ = "erreur"
                endif

                left = oral_burst - 0.02
                right = oral_burst + 0.109

                position$ = Get label of interval... 2 s

                if position$ = "1"
                    initial$ = "initial"
                    log$ = "1_"
                elsif position$ = "2"
                    initial$ = "medial"
                    log$ = "2_"
                elsif position$ = "3"
                    initial$ = "medial"
                    log$ = "3_"
                endif
        
                vowel$ = Get label of interval... 3 i+1
                sequence$ = segment$ + vowel$
                vowel_start = Get start point: 3, i+1
                vowel_end = Get end point: 3, i+1
                vowelduration = (vowel_end - vowel_start) * 1000
                 
                y = Get interval at time... 7 oral_burst      
                vot_check$ = Get label of interval... 7 y+1
                
                if vot_check$ = vowel$
                	vot_start = Get start point: 7, y+1
                endif

                vot = (vot_start - oral_burst) * 1000
                
                type$ = "ejective"
                place$ = "coronal"
             
                quest$ = mid$("'filename$'",17,1)
                     
                if quest$ = "1"
                    question$ = "question"
                else
                    question$ = "answer"
                endif
                 
                if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                    echo$ = "new"
                elsif focus$ = "2" or focus$ = "4" or focus$ = "6" or focus$ = "8" or focus$ = "0"
                    if question$ = "question"
                        echo$ = "new"
                    elsif question$ = "answer"
                        echo$ = "echo"
                    endif
                endif

                numero = randomInteger (0, 10000)
                new_name$ = log$ + string$(numero)

                v = Get interval at time: 5, end
                #extendVOT$ = Get label of interval: 5, v
                extendVOT_start = Get start point: 5, v
                extendVOT_end = Get end point: 5, v
                extendVOT_duration = (extendVOT_end - extendVOT_start) * 1000
            
                constriction_duration = ((end - start) * 1000)

                #select Sound 'soundname$'
                #Extract part: left, right, "rectangular", 1, "yes"
                #Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'verif$' 'duree_burst:2' 'duree_lag:2' 'duree_creak:2' 'duree_vowel:2' 'debut_creak:6' 'debut_vowel:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'vot_check$' 'vot:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'
                
            elsif segment$ = "k>"
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 8, end
                oral_burst = Get start point: 8, x

                verif$ = Get label of interval: 8, x

                if verif$ = "burst"
                    debut_burst = Get start point... 8 x
                    fin_burst = Get end point... 8 x
                    duree_burst = (fin_burst - debut_burst)*1000
                    next$ = Get label of interval... 8 x+1
                    if next$ = "lag"
                        debut_lag = Get start point... 8 x+1
                        fin_lag = Get end point... 8 x+1
                        duree_lag = (fin_lag - debut_lag)*1000
                    elsif next$ = "creak"
                        duree_lag = 0
                        debut_creak = Get start point... 8 x+1
                        fin_creak = Get end point... 8 x+1
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif next$ = "vowel"
                        duree_lag = 0
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+1
                        fin_vowel = Get end point... 8 x+1
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    endif
                    following$ = Get label of interval... 8 x+2
                    if following$ = "creak"
                        debut_creak = Get start point... 8 x+2
                        fin_creak = Get end point... 8 x+2
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif following$ = "vowel"
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+2
                        fin_vowel = Get end point... 8 x+2
                        duree_vowel = (fin_vowel - debut_vowel)*1000                    
                    endif
                    final$ = Get label of interval... 8 x+3
                    if final$ = "vowel"
                        debut_vowel = Get start point... 8 x+3
                        fin_vowel = Get end point... 8 x+3
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    elsif final$ != "vowel" & following$ != "vowel" & next$ != "vowel"
                        duree_vowel = 0
                    endif
                else
                    verif$ = "erreur"
                endif

                left = oral_burst - 0.02
                right = oral_burst + 0.109

                position$ = Get label of interval... 2 s

                if position$ = "1"
                    initial$ = "initial"
                    log$ = "1_"
                elsif position$ = "2"
                    initial$ = "medial"
                    log$ = "2_"
                elsif position$ = "3"
                    initial$ = "medial"
                    log$ = "3_"
                endif
        
                vowel$ = Get label of interval... 3 i+1
                sequence$ = segment$ + vowel$
                vowel_start = Get start point: 3, i+1
                vowel_end = Get end point: 3, i+1
                vowelduration = (vowel_end - vowel_start) * 1000
                
                y = Get interval at time... 7 oral_burst      
                vot_check$ = Get label of interval... 7 y+1
                
                if vot_check$ = vowel$
                	vot_start = Get start point: 7, y+1
                endif

                vot = (vot_start - oral_burst) * 1000
               
                type$ = "ejective"
                place$ = "velar"
                 
                quest$ = mid$("'filename$'",17,1)
                     
                if quest$ = "1"
                    question$ = "question"
                else
                    question$ = "answer"
                endif
                 
                if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                    echo$ = "new"
                elsif focus$ = "2" or focus$ = "4" or focus$ = "6" or focus$ = "8" or focus$ = "0"
                    if question$ = "question"
                        echo$ = "new"
                    elsif question$ = "answer"
                        echo$ = "echo"
                    endif
                endif

                numero = randomInteger (0, 10000)
                new_name$ = log$ + string$(numero)

                v = Get interval at time: 5, end
                #extendVOT$ = Get label of interval: 5, v
                extendVOT_start = Get start point: 5, v
                extendVOT_end = Get end point: 5, v
                extendVOT_duration = (extendVOT_end - extendVOT_start) * 1000
            
                constriction_duration = ((end - start) * 1000)

                #select Sound 'soundname$'
                #Extract part: left, right, "rectangular", 1, "yes"
                #Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'verif$' 'duree_burst:2' 'duree_lag:2' 'duree_creak:2' 'duree_vowel:2' 'debut_creak:6' 'debut_vowel:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'vot_check$' 'vot:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'
                
            elsif segment$ = "p"
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 8, end
                oral_burst = Get start point: 8, x

                verif$ = Get label of interval: 8, x

                if verif$ = "burst"
                    debut_burst = Get start point... 8 x
                    fin_burst = Get end point... 8 x
                    duree_burst = (fin_burst - debut_burst)*1000
                    next$ = Get label of interval... 8 x+1
                    if next$ = "lag"
                        debut_lag = Get start point... 8 x+1
                        fin_lag = Get end point... 8 x+1
                        duree_lag = (fin_lag - debut_lag)*1000
                    elsif next$ = "creak"
                        duree_lag = 0
                        debut_creak = Get start point... 8 x+1
                        fin_creak = Get end point... 8 x+1
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif next$ = "vowel"
                        duree_lag = 0
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+1
                        fin_vowel = Get end point... 8 x+1
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    endif
                    following$ = Get label of interval... 8 x+2
                    if following$ = "creak"
                        debut_creak = Get start point... 8 x+2
                        fin_creak = Get end point... 8 x+2
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif following$ = "vowel"
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+2
                        fin_vowel = Get end point... 8 x+2
                        duree_vowel = (fin_vowel - debut_vowel)*1000                    
                    endif
                    final$ = Get label of interval... 8 x+3
                    if final$ = "vowel"
                        debut_vowel = Get start point... 8 x+3
                        fin_vowel = Get end point... 8 x+3
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    elsif final$ != "vowel" & following$ != "vowel" & next$ != "vowel"
                        duree_vowel = 0
                    endif
                else
                    verif$ = "erreur"
                endif

                end_vot = Get end point: 5, x

                left = oral_burst - 0.02
                right = oral_burst + 0.109

                position$ = Get label of interval... 2 s

                if position$ = "1"
                    initial$ = "initial"
                    log$ = "1_"
                elsif position$ = "2"
                    initial$ = "medial"
                    log$ = "2_"
                elsif position$ = "3"
                    initial$ = "medial"
                    log$ = "3_"
                endif
        
                vowel$ = Get label of interval... 3 i+1
                sequence$ = segment$ + vowel$
                vowel_start = Get start point: 3, i+1
                vowel_end = Get end point: 3, i+1
                vowelduration = (vowel_end - vowel_start) * 1000
                
                y = Get interval at time... 7 oral_burst      
                vot_check$ = Get label of interval... 7 y+1
                
                if vot_check$ = vowel$
                	vot_start = Get start point: 7, y+1
                endif

                vot = (vot_start - oral_burst) * 1000
                
                type$ = "pulmonic"
                place$ = "labial"
                 
                quest$ = mid$("'filename$'",17,1)
                     
                if quest$ = "1"
                    question$ = "question"
                else
                    question$ = "answer"
                endif
                 
                if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                    echo$ = "new"
                elsif focus$ = "2" or focus$ = "4" or focus$ = "6" or focus$ = "8" or focus$ = "0"
                    if question$ = "question"
                        echo$ = "new"
                    elsif question$ = "answer"
                        echo$ = "echo"
                    endif
                endif

                numero = randomInteger (0, 10000)
                new_name$ = log$ + string$(numero)

                regularVOT_duration = (end_vot - oral_burst) * 1000
                            
                constriction_duration = ((end - start) * 1000)

                #select Sound 'soundname$'
                #Extract part: left, right, "rectangular", 1, "yes"
                #Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'verif$' 'duree_burst:2' 'duree_lag:2' 'duree_creak:2' 'duree_vowel:2' 'debut_creak:6' 'debut_vowel:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'vot_check$' 'vot:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'

            elsif segment$ = "t"
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 8, end
                oral_burst = Get start point: 8, x

                verif$ = Get label of interval: 8, x

                if verif$ = "burst"
                    debut_burst = Get start point... 8 x
                    fin_burst = Get end point... 8 x
                    duree_burst = (fin_burst - debut_burst)*1000
                    next$ = Get label of interval... 8 x+1
                    if next$ = "lag"
                        debut_lag = Get start point... 8 x+1
                        fin_lag = Get end point... 8 x+1
                        duree_lag = (fin_lag - debut_lag)*1000
                    elsif next$ = "creak"
                        duree_lag = 0
                        debut_creak = Get start point... 8 x+1
                        fin_creak = Get end point... 8 x+1
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif next$ = "vowel"
                        duree_lag = 0
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+1
                        fin_vowel = Get end point... 8 x+1
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    endif
                    following$ = Get label of interval... 8 x+2
                    if following$ = "creak"
                        debut_creak = Get start point... 8 x+2
                        fin_creak = Get end point... 8 x+2
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif following$ = "vowel"
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+2
                        fin_vowel = Get end point... 8 x+2
                        duree_vowel = (fin_vowel - debut_vowel)*1000                    
                    endif
                    final$ = Get label of interval... 8 x+3
                    if final$ = "vowel"
                        debut_vowel = Get start point... 8 x+3
                        fin_vowel = Get end point... 8 x+3
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    elsif final$ != "vowel" & following$ != "vowel" & next$ != "vowel"
                        duree_vowel = 0
                    endif
                else
                    verif$ = "erreur"
                endif

                end_vot = Get end point: 5, x
                    
                left = oral_burst - 0.02
                right = oral_burst + 0.109

                position$ = Get label of interval... 2 s

                if position$ = "1"
                    initial$ = "initial"
                    log$ = "1_"
                elsif position$ = "2"
                    initial$ = "medial"
                    log$ = "2_"
                elsif position$ = "3"
                    initial$ = "medial"
                    log$ = "3_"
                endif
        
                vowel$ = Get label of interval... 3 i+1
                sequence$ = segment$ + vowel$
                vowel_start = Get start point: 3, i+1
                vowel_end = Get end point: 3, i+1
                vowelduration = (vowel_end - vowel_start) * 1000
                
                y = Get interval at time... 7 oral_burst      
                vot_check$ = Get label of interval... 7 y+1
                
                if vot_check$ = vowel$
                	vot_start = Get start point: 7, y+1
                endif

                vot = (vot_start - oral_burst) * 1000
                
                type$ = "pulmonic"
                place$ = "coronal"
                 
                quest$ = mid$("'filename$'",17,1)
                     
                if quest$ = "1"
                    question$ = "question"
                else
                    question$ = "answer"
                endif
                 
                if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                    echo$ = "new"
                elsif focus$ = "2" or focus$ = "4" or focus$ = "6" or focus$ = "8" or focus$ = "0"
                    if question$ = "question"
                        echo$ = "new"
                    elsif question$ = "answer"
                        echo$ = "echo"
                    endif
                else
                    verif$ = "erreur"
                endif

                numero = randomInteger (0, 10000)
                new_name$ = log$ + string$(numero)

                regularVOT_duration = (end_vot - oral_burst) * 1000
            
                constriction_duration = ((end - start) * 1000)

                #select Sound 'soundname$'
                #Extract part: left, right, "rectangular", 1, "yes"
                #Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'verif$' 'duree_burst:2' 'duree_lag:2' 'duree_creak:2' 'duree_vowel:2' 'debut_creak:6' 'debut_vowel:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'vot_check$' 'vot:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'

            elsif segment$ = "k"
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 8, end
                oral_burst = Get start point: 8, x

                verif$ = Get label of interval: 8, x

                if verif$ = "burst"
                    debut_burst = Get start point... 8 x
                    fin_burst = Get end point... 8 x
                    duree_burst = (fin_burst - debut_burst)*1000
                    next$ = Get label of interval... 8 x+1
                    if next$ = "lag"
                        debut_lag = Get start point... 8 x+1
                        fin_lag = Get end point... 8 x+1
                        duree_lag = (fin_lag - debut_lag)*1000
                    elsif next$ = "creak"
                        duree_lag = 0
                        debut_creak = Get start point... 8 x+1
                        fin_creak = Get end point... 8 x+1
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif next$ = "vowel"
                        duree_lag = 0
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+1
                        fin_vowel = Get end point... 8 x+1
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    endif
                    following$ = Get label of interval... 8 x+2
                    if following$ = "creak"
                        debut_creak = Get start point... 8 x+2
                        fin_creak = Get end point... 8 x+2
                        duree_creak = (fin_creak - debut_creak)*1000
                    elsif following$ = "vowel"
                        duree_creak = 0
                        debut_vowel = Get start point... 8 x+2
                        fin_vowel = Get end point... 8 x+2
                        duree_vowel = (fin_vowel - debut_vowel)*1000                    
                    endif
                    final$ = Get label of interval... 8 x+3
                    if final$ = "vowel"
                        debut_vowel = Get start point... 8 x+3
                        fin_vowel = Get end point... 8 x+3
                        duree_vowel = (fin_vowel - debut_vowel)*1000
                    elsif final$ != "vowel"
                        duree_vowel = 0
                    endif
                endif

                end_vot = Get end point: 5, x
                    
                left = oral_burst - 0.02
                right = oral_burst + 0.109

                position$ = Get label of interval... 2 s

                if position$ = "1"
                    initial$ = "initial"
                    log$ = "1_"
                elsif position$ = "2"
                    initial$ = "medial"
                    log$ = "2_"
                elsif position$ = "3"
                    initial$ = "medial"
                    log$ = "3_"
                endif
        
                vowel$ = Get label of interval... 3 i+1
                sequence$ = segment$ + vowel$
                vowel_start = Get start point: 3, i+1
                vowel_end = Get end point: 3, i+1
                vowelduration = (vowel_end - vowel_start) * 1000
                
                y = Get interval at time... 7 oral_burst      
                vot_check$ = Get label of interval... 7 y+1
                
                if vot_check$ = vowel$
                	vot_start = Get start point: 7, y+1
                endif

                vot = (vot_start - oral_burst) * 1000
                
                type$ = "pulmonic"
                place$ = "velar"
             
                quest$ = mid$("'filename$'",17,1)
                     
                if quest$ = "1"
                    question$ = "question"
                else
                    question$ = "answer"
                endif
                 
                if focus$ = "1" or focus$ = "3" or focus$ = "5" or focus$ = "7" or focus$ = "9"
                    echo$ = "new"
                elsif focus$ = "2" or focus$ = "4" or focus$ = "6" or focus$ = "8" or focus$ = "0"
                    if question$ = "question"
                        echo$ = "new"
                    elsif question$ = "answer"
                        echo$ = "echo"
                    endif
                endif

                numero = randomInteger (0, 10000)
                new_name$ = log$ + string$(numero)

                regularVOT_duration = (end_vot - oral_burst) * 1000
            
                constriction_duration = ((end - start) * 1000)

                #select Sound 'soundname$'
                #Extract part: left, right, "rectangular", 1, "yes"
                #Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'verif$' 'duree_burst:2' 'duree_lag:2' 'duree_creak:2' 'duree_vowel:2' 'debut_creak:6' 'debut_vowel:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'vot_check$' 'vot:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'
            endif
        endfor
    endif

    select Sound 'soundname$'
    Remove
    # and go on with the next sound file!
    select Strings list

endfor

select all
Remove