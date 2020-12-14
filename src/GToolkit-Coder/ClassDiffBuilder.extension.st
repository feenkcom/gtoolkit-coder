Extension { #name : #ClassDiffBuilder }

{ #category : #'*GToolkit-Coder' }
ClassDiffBuilder >> attributedRopedFrom: aString do: aBlock [
	| aTrimmedLeft aTrimmedRight aTrimmedString aTrimmedText |
			
	aTrimmedLeft := ''.
	aTrimmedString := aString.
	aTrimmedRight := ''.
	
	aTrimmedString := aTrimmedString trimLeft: [ :eachChar |
		eachChar isSeparator
			ifTrue: [
				aTrimmedLeft := aTrimmedLeft, eachChar asString.
				true ]
			ifFalse: [ false ] ].
		
	
	aTrimmedString := aTrimmedString trimRight: [ :eachChar |
		eachChar isSeparator
			ifTrue: [
				aTrimmedRight := eachChar asString, aTrimmedRight.
				true ]
			ifFalse: [ false ] ].
		
	aTrimmedText := aTrimmedString asRopedText.
	aBlock value: aTrimmedText.
	
	^ '' asRopedText
		append: aTrimmedLeft asRopedText;
		append: aTrimmedText;
		append: aTrimmedRight asRopedText;
		yourself
]

{ #category : #'*GToolkit-Coder' }
ClassDiffBuilder >> newRopedText [
	| text |
	text := '' asRopedText.
	
	self
		patchSequenceDoIfMatch: [ :string | text append: string asRopedText ]
		ifInsert: [ :string | 
			text append: (self
				attributedRopedFrom: string
				do: [ :aText | aText highlight: (BrGlamorousColors successBackgroundColor alpha: 0.75) ])]
		ifRemove: [ :string | ].
	^ text
]

{ #category : #'*GToolkit-Coder' }
ClassDiffBuilder >> previousRopedText [
	| text |
	text := '' asRopedText.
	self
		patchSequenceDoIfMatch: [ :string | text append: string asRopedText ]
		ifInsert: [ :string |  ]
		ifRemove: [ :string | 
			text append: (self
				attributedRopedFrom: string
				do: [ :aText | aText highlight: (BrGlamorousColors errorBackgroundColor alpha: 0.75) ])].
	^ text
]
