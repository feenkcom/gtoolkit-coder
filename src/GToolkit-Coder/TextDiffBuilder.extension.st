Extension { #name : 'TextDiffBuilder' }

{ #category : '*GToolkit-Coder' }
TextDiffBuilder >> newRopedText [
	| text |
	text := '' asRopedText.
	self
		patchSequenceDoIfMatch: [ :string | 
			text
				append: string asRopedText;
				append: String cr asRopedText ]
		ifInsert: [ :string | 
			text
				append: string asRopedText;
				append: String cr asRopedText ]
		ifRemove: [ :string |  ].
	^ text
]

{ #category : '*GToolkit-Coder' }
TextDiffBuilder >> newStyler [
	^ nil
]

{ #category : '*GToolkit-Coder' }
TextDiffBuilder >> previousRopedText [
	| text |
	text := '' asRopedText.
	self
		patchSequenceDoIfMatch: [ :string | 
			text
				append: string asRopedText;
				append: String cr asRopedText ]
		ifInsert: [ :string |  ]
		ifRemove: [ :string | 
			text
				append: string asRopedText;
				append: String cr asRopedText ].
	^ text
]
