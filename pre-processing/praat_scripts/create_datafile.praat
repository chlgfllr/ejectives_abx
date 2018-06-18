# Creates a datafile with acoustic measures and metalinguistic parameters.
# Defines a fixed width window
# Creates separate audio files for each sound window that is used


#Copyright Christian DiCanio, Haskins Laboratories, October 2011.

# Version mars 2018

form Get temporal articulatory and acoustic measures
	comment Directory of sound files. Be sure to include the final "/"
	text sound_directory /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled_mono/
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files. Be sure to include the final "/"
	text textGrid_directory /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/resampled_mono/
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:
	text resultsfile /Users/chloe/ejectives_abx/pre-processing/full_abx_corrected.item
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
header$ = "#file onset_f offset_f onset_v offset_v item sequence syllables type place vowel position speaker question new vot constriction vowelduration 'newline$'"
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

                x = Get interval at time: 5, end
                oral_burst = Get start point: 5, x

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

                select Sound 'soundname$'
                Extract part: left, right, "rectangular", 1, "yes"
                Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'oral_burst:6' 'right:6' 'start:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'

            elsif segment$ = "t>" 
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 5, end
                oral_burst = Get start point: 5, x

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

                select Sound 'soundname$'
                Extract part: left, right, "rectangular", 1, "yes"
                Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'
                
            elsif segment$ = "k>"
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 5, end
                oral_burst = Get start point: 5, x

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

                select Sound 'soundname$'
                Extract part: left, right, "rectangular", 1, "yes"
                Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'
                
            elsif segment$ = "p"
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 5, end
                oral_burst = Get start point: 5, x
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

                select Sound 'soundname$'
                Extract part: left, right, "rectangular", 1, "yes"
                Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'

            elsif segment$ = "t"
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 5, end
                oral_burst = Get start point: 5, x
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

                numero = randomInteger (0, 10000)
                new_name$ = log$ + string$(numero)

                regularVOT_duration = (end_vot - oral_burst) * 1000
            
                constriction_duration = ((end - start) * 1000)

                select Sound 'soundname$'
                Extract part: left, right, "rectangular", 1, "yes"
                Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

                # select the TextGrid so we can iterate to the next interval:
                select TextGrid 'soundname$'

            elsif segment$ = "k"
                start = Get start point... 'tier' i
                end = Get end point... 'tier' i

                x = Get interval at time: 5, end
                oral_burst = Get start point: 5, x
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

                select Sound 'soundname$'
                Extract part: left, right, "rectangular", 1, "yes"
                Write to WAV file... /Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/audio_files/cv_sequences/'new_name$'.wav
                
                fileappend "'resultsfile$'" 'soundname$' 'left:6' 'right:6' 'start:6' 'vowel_end:6' 'new_name$' 'sequence$' 'syllable_count' 'type$' 'place$' 'vowel$' 'initial$' 'speaker$' 'question$' 'echo$' 'extendVOT_duration:2' 'constriction_duration:2' 'vowelduration:2' 'newline$'

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