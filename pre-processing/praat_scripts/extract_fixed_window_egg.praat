form Extract fixed length window of the EGG signal
	comment Directory of EGG files. Be sure to include the final "/"
	text sound_directory /Users/chloe/features_extraction/test/wavs/
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files. Be sure to include the final "/"
	text textGrid_directory /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled_mono/
	comment Full path of the resulting text file:
	text resultsfile /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/egg_files/full_abx.item
	sentence TextGrid_file_extension .TextGrid
	comment Which tier do you want to analyze?
	integer Tier 3
endform

Create Strings as file list... list 'sound_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings

if fileReadable (resultsfile$)
	pause The file 'resultsfile$' already exists! Do you want to overwrite it?
	filedelete 'resultsfile$'
endif

num = Get number of strings
header$ = "#file onset_f offset_f onset_v offset_v item sequence syllables type place vowel position speaker question new vot constriction vowelduration 'newline$'"
fileappend "'resultsfile$'" 'header$'

for ifile to num
	filename$ = Get string... ifile
	ref$ = mid$("'filename$'",1,17)
	speaker$ = mid$("'filename$'",7,3)
	focus$ = mid$("'filename$'",14,1)
	Read from file... 'sound_directory$''filename$'
	soundname$ = selected$ ("Sound", 1)

	Read from file... 'sound_directory$'/'filename$'

	# Look for a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"

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
            position$ = Get label of interval... 2 s
        
        	if position$ = "1"
            initial$ = "initial"

                if segment$ = "p>" and position$ = "1"
            	    start = Get start point... 'tier' i
                    end = Get end point... 'tier' i

                    x = Get interval at time: 5, end
                    oral_burst = Get start point: 5, x

                    left = oral_burst - 0.02
                    right = oral_burst + 0.109
                                        
                    vowel$ = Get label of interval... 3 i+1
                    sequence$ = segment$ + vowel$
                	vowel_start = Get start point: 3, i+1
                    vowel_end = Get end point: 3, i+1
                    vowelduration = (vowel_end - vowel_start) * 1000
                                                
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

					v = Get interval at time: 5, end
					#extendVOT$ = Get label of interval: 5, v
					extendVOT_start = Get start point: 5, v
					extendVOT_end = Get end point: 5, v
					extendVOT_duration = (extendVOT_end - extendVOT_start) * 1000
            
            		constriction_duration = ((end - start) * 1000)

                    select Sound 'soundname$'
                    Extract part: left, right, "rectangular", 1, "yes"
                    Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/egg_files/'filename$'.wav
                 
             		#"#file onset offset item sequence syllables type place vowel position speaker question new 																		vot constriction vowelduration 'newline$'"
                    fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'ifile' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                    # select the TextGrid so we can iterate to the next interval:
                    select TextGrid 'soundname$'

                elsif segment$ = "t>" and position$ = "1"
                    start = Get start point... 'tier' i
                    end = Get end point... 'tier' i

                    x = Get interval at time: 5, end
                    oral_burst = Get start point: 5, x

                    left = oral_burst - 0.02
                    right = oral_burst + 0.109
                                        
                    vowel$ = Get label of interval... 3 i+1
                    sequence$ = segment$ + vowel$
                    vowel_start = Get start point: 3, i+1
                    vowel_end = Get end point: 3, i+1
                    vowelduration = (vowel_end - vowel_start) * 1000
                                                
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

                    v = Get interval at time: 5, end
                    #extendVOT$ = Get label of interval: 5, v
                    extendVOT_start = Get start point: 5, v
                    extendVOT_end = Get end point: 5, v
                    extendVOT_duration = (extendVOT_end - extendVOT_start) * 1000
            
                    constriction_duration = ((end - start) * 1000)

                    select Sound 'soundname$'
                    Extract part: left, right, "rectangular", 1, "yes"
                    Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/egg_files/'filename$'.wav
                 
                    #"#file onset offset item sequence syllables type place vowel position speaker question new                                                                         vot constriction vowelduration 'newline$'"
                    fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'ifile' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                    # select the TextGrid so we can iterate to the next interval:
                    select TextGrid 'soundname$'
                
                elsif segment$ = "k>" and position$ = "1"
                    start = Get start point... 'tier' i
                    end = Get end point... 'tier' i

                    x = Get interval at time: 5, end
                    oral_burst = Get start point: 5, x

                    left = oral_burst - 0.02
                    right = oral_burst + 0.109
                                        
                    vowel$ = Get label of interval... 3 i+1
                    sequence$ = segment$ + vowel$
                    vowel_start = Get start point: 3, i+1
                    vowel_end = Get end point: 3, i+1
                    vowelduration = (vowel_end - vowel_start) * 1000
                                                
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

                    v = Get interval at time: 5, end
                    #extendVOT$ = Get label of interval: 5, v
                    extendVOT_start = Get start point: 5, v
                    extendVOT_end = Get end point: 5, v
                    extendVOT_duration = (extendVOT_end - extendVOT_start) * 1000
            
                    constriction_duration = ((end - start) * 1000)

                    select Sound 'soundname$'
                    Extract part: left, right, "rectangular", 1, "yes"
                    Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/egg_files/'filename$'.wav
                 
                    #"#file onset offset item sequence syllables type place vowel position speaker question new                                                                         vot constriction vowelduration 'newline$'"
                    fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'ifile' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                    # select the TextGrid so we can iterate to the next interval:
                    select TextGrid 'soundname$'
                
                elsif segment$ = "p" and position$ = "1"
                    start = Get start point... 'tier' i
                    end = Get end point... 'tier' i

                    x = Get interval at time: 5, end
                    oral_burst = Get start point: 5, x

                    left = oral_burst - 0.02
                    right = oral_burst + 0.109
                                        
                    vowel$ = Get label of interval... 3 i+1
                    sequence$ = segment$ + vowel$
                    vowel_start = Get start point: 3, i+1
                    vowel_end = Get end point: 3, i+1
                    vowelduration = (vowel_end - vowel_start) * 1000
                                                
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

                    k = Get interval at time: 6, end
                    regularVOT$ = Get label of interval: 6, k
                    regularVOT_start = Get start point: 6, k
                    regularVOT_end = Get end point: 6, k
                    regularVOT_duration = (regularVOT_end - regularVOT_start) * 1000
            
                    constriction_duration = ((end - start) * 1000)

                    select Sound 'soundname$'
                    Extract part: left, right, "rectangular", 1, "yes"
                    Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/egg_files/'filename$'.wav
                 
                    #"#file onset offset item sequence syllables type place vowel position speaker question new                                                                         vot constriction vowelduration 'newline$'"
                    fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'ifile' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'regularVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                    # select the TextGrid so we can iterate to the next interval:
                    select TextGrid 'soundname$'

                elsif segment$ = "t" and position$ = "1"
                    start = Get start point... 'tier' i
                    end = Get end point... 'tier' i

                    x = Get interval at time: 5, end
                    oral_burst = Get start point: 5, x

                    left = oral_burst - 0.02
                    right = oral_burst + 0.109
                                        
                    vowel$ = Get label of interval... 3 i+1
                    sequence$ = segment$ + vowel$
                    vowel_start = Get start point: 3, i+1
                    vowel_end = Get end point: 3, i+1
                    vowelduration = (vowel_end - vowel_start) * 1000
                                                
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
                    endif

                    k = Get interval at time: 6, end
                    regularVOT$ = Get label of interval: 6, k
                    regularVOT_start = Get start point: 6, k
                    regularVOT_end = Get end point: 6, k
                    regularVOT_duration = (regularVOT_end - regularVOT_start) * 1000
            
                    constriction_duration = ((end - start) * 1000)

                    select Sound 'soundname$'
                    Extract part: left, right, "rectangular", 1, "yes"
                    Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/egg_files/'filename$'.wav
                 
                    #"#file onset offset item sequence syllables type place vowel position speaker question new                                                                         vot constriction vowelduration 'newline$'"
                    fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'ifile' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'regularVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                    # select the TextGrid so we can iterate to the next interval:
                    select TextGrid 'soundname$'

                elsif segment$ = "k" and position$ = "1"
                    start = Get start point... 'tier' i
                    end = Get end point... 'tier' i

                    x = Get interval at time: 5, end
                    oral_burst = Get start point: 5, x

                    left = oral_burst - 0.02
                    right = oral_burst + 0.109
                                        
                    vowel$ = Get label of interval... 3 i+1
                    sequence$ = segment$ + vowel$
                    vowel_start = Get start point: 3, i+1
                    vowel_end = Get end point: 3, i+1
                    vowelduration = (vowel_end - vowel_start) * 1000
                                                
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

                    k = Get interval at time: 6, end
                    regularVOT$ = Get label of interval: 6, k
                    regularVOT_start = Get start point: 6, k
                    regularVOT_end = Get end point: 6, k
                    regularVOT_duration = (regularVOT_end - regularVOT_start) * 1000
            
                    constriction_duration = ((end - start) * 1000)

                    select Sound 'soundname$'
                    Extract part: left, right, "rectangular", 1, "yes"
                    Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/egg_files/'filename$'.wav
                 
                    #"#file onset offset item sequence syllables type place vowel position speaker question new                                                                         vot constriction vowelduration 'newline$'"
                    fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'ifile' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'regularVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                    # select the TextGrid so we can iterate to the next interval:
                    select TextGrid 'soundname$'
                endif
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
                 