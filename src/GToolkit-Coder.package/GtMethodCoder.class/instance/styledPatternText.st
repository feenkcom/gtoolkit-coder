private
styledPatternText
	| text |
	text := patternSource asRopedText.
	^ BrRBTextStyler new
		classOrMetaClass: class;
		style: text