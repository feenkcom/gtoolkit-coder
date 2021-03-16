Class {
	#name : #GtPharoImplementorPatternHighlighter,
	#superclass : #GtPharoCodeHighlighter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #'instance creation' }
GtPharoImplementorPatternHighlighter class >> forPattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #private }
GtPharoImplementorPatternHighlighter >> highlightMethod: aMethodNode startingAt: anInteger [
	| offset patternEnd todo |
	
	offset := 1.
	patternEnd := anInteger + pattern size - 1.
	
	aMethodNode selectorParts
		do: [ :eachSelectorPart | 
			| first last end |
			end := offset + eachSelectorPart size - 1.
			anInteger > end
				ifFalse: [ (anInteger between: offset and: end)
						ifTrue: [ first := anInteger - offset + eachSelectorPart startPosition.
							patternEnd <= end
								ifTrue: [ last := patternEnd - offset + eachSelectorPart startPosition ]
								ifFalse: [ last := eachSelectorPart stopPosition.
									todo := pattern size - (end - first) - 1 ] ]
						ifFalse: [ first := eachSelectorPart startPosition.
							todo <= eachSelectorPart size
								ifTrue: [ last := eachSelectorPart startPosition + todo - 1 ]
								ifFalse: [ last := eachSelectorPart stopPosition.
									todo := todo - eachSelectorPart size ] ].
					stream nextPut: (first to: last) ].
			patternEnd <= end
				ifTrue: [ ^ self ].
			offset := end + 1 ]
]

{ #category : #accessing }
GtPharoImplementorPatternHighlighter >> pattern [
	^ pattern
]

{ #category : #accessing }
GtPharoImplementorPatternHighlighter >> pattern: aString [
	pattern := aString asLowercase
]

{ #category : #visiting }
GtPharoImplementorPatternHighlighter >> visitMethod: aMethodNode [
	| index start |
	start := 1.
	[
		index := aMethodNode selector asLowercase indexOfSubCollection: pattern startingAt: start.
		index > 0
	]
	whileTrue: [
		self highlightMethod: aMethodNode startingAt: index.
		start := index + pattern size ]
]
