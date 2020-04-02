Extension { #name : #ClassDiffBuilder }

{ #category : #'*GToolkit-Coder' }
ClassDiffBuilder >> newRopedText [
	| text |
	text := '' asRopedText.
	
	self
		patchSequenceDoIfMatch: [ :string | text append: string asRopedText ]
		ifInsert: [ :string | 
			text
				append: (string trimBoth asRopedText highlight: (BrGlamorousColors successBackgroundColor alpha: 0.75));
				append: String space asRopedText ]
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
			text
				append: (string trimBoth asRopedText highlight: (BrGlamorousColors errorBackgroundColor alpha: 0.75));
				append: String space asRopedText ].
	^ text
]
