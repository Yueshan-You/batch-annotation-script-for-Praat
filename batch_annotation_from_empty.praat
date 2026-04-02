# Simple Batch Annotation Script for Praat
#Creator:Yueshan YOU
# Just opens files one by one, you annotate, click Next, done.

# Select folders
input_folder$ = chooseDirectory$: "Select folder with sound files"
if input_folder$ = ""
	exitScript: "Cancelled."
endif
input_folder$ = input_folder$ + "/"

output_folder$ = chooseDirectory$: "Select folder to save TextGrids"
if output_folder$ = ""
	exitScript: "Cancelled."
endif
output_folder$ = output_folder$ + "/"

# Simple settings
form Annotation_Settings
	sentence Tier_names words,phonemes
	sentence Tier_types interval,interval
	optionmenu Extension: 1
		option .wav
		option .mp3
endform

# Parse tiers
@parseTiers: tier_names$, tier_types$

# Get file list
if extension = 1
	ext$ = ".wav"
else
	ext$ = ".mp3"
endif

Create Strings as file list: "files", input_folder$ + "*" + ext$
Sort
n = Get number of strings

if n = 0
	exitScript: "No " + ext$ + " files found."
endif

# Main loop
for i from 1 to n
	selectObject: "Strings files"
	file$ = Get string: i
	base$ = file$ - ext$
	
	# Load sound
	Read from file: input_folder$ + file$
	sound$ = selected$("Sound")
	
	# Create or load TextGrid
	tgPath$ = output_folder$ + base$ + ".TextGrid"
	if fileReadable(tgPath$)
		Read from file: tgPath$
	else
		selectObject: "Sound " + sound$
		intervalTiers$ = ""
		pointTiers$ = ""
		for t from 1 to parseTiers.n
			if parseTiers.type$[t] = "point"
				pointTiers$ = pointTiers$ + parseTiers.name$[t] + " "
			else
				intervalTiers$ = intervalTiers$ + parseTiers.name$[t] + " "
			endif
		endfor
		To TextGrid: intervalTiers$, pointTiers$
	endif
	tg$ = selected$("TextGrid")
	
	# Open editor
	selectObject: "Sound " + sound$
	plusObject: "TextGrid " + tg$
	View & Edit
	
	# Wait for user
	beginPause: "File " + string$(i) + "/" + string$(n) + ": " + base$
	clicked = endPause: "Stop", "Next", 2, 1
	
	# Close and save
	editor: "TextGrid " + tg$
		Close
	endeditor
	selectObject: "TextGrid " + tg$
	Save as text file: tgPath$
	
	# Cleanup
	selectObject: "Sound " + sound$
	plusObject: "TextGrid " + tg$
	Remove
	
	if clicked = 1
		exitScript: "Stopped at file " + string$(i)
	endif
endfor

selectObject: "Strings files"
Remove

writeInfoLine: "Done! Annotated ", n, " files."

# Procedure to parse tier config
procedure parseTiers: .names$, .types$
	.n = 0
	while .names$ <> ""
		.n = .n + 1
		.comma = index(.names$, ",")
		if .comma > 0
			.name$[.n] = left$(.names$, .comma - 1)
			.names$ = mid$(.names$, .comma + 1, 999)
		else
			.name$[.n] = .names$
			.names$ = ""
		endif
		.name$[.n] = replace$(.name$[.n], " ", "", 0)
		
		.comma = index(.types$, ",")
		if .comma > 0
			.type$[.n] = left$(.types$, .comma - 1)
			.types$ = mid$(.types$, .comma + 1, 999)
		else
			.type$[.n] = .types$
			.types$ = ""
		endif
		.type$[.n] = replace$(.type$[.n], " ", "", 0)
		if index(.type$[.n], "p") = 1 or index(.type$[.n], "P") = 1
			.type$[.n] = "point"
		else
			.type$[.n] = "interval"
		endif
	endwhile
endproc
