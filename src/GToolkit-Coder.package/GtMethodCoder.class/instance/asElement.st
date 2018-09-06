converting
asElement
	| accordion styledPattern header |
	accordion := BrAccordion new.
	accordion look: BrGlamorousAccordionLook new.
	accordion margin: (BlInsets all: 5).
	accordion stencil: [ self bodyElement ].
	styledPattern := self styledPatternText.
	header := BrButton new.
	header look: BrGlamorousAccordionHeaderLook new.
	header label: styledPattern.
	header action: [ accordion toggle ].
	accordion addChildFirst: header.
	^ accordion