Class {
	#name : #GtImplementorPatternHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtImplementorPatternHighlighter class >> forPattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #private }
GtImplementorPatternHighlighter >> highlightMethod: aMethodNode [
	| index start |
	start := 1.
	[ index := aMethodNode selector asLowercase indexOfSubCollection: pattern startingAt: start.
	index > 0 ]
		whileTrue: [ self highlightMethod: aMethodNode startingAt: index.
			start := index + pattern size ]
]

{ #category : #private }
GtImplementorPatternHighlighter >> highlightMethod: aMethodNode startingAt: anInteger [
	| offset patternEnd todo |
	offset := 1.
	patternEnd := anInteger + pattern size - 1.
	aMethodNode keywordsIntervals
		do: [ :each | 
			| first last end |
			end := offset + each size - 1.
			anInteger > end
				ifFalse: [ (anInteger between: offset and: end)
						ifTrue: [ first := anInteger - offset + each first.
							patternEnd <= end
								ifTrue: [ last := patternEnd - offset + each first ]
								ifFalse: [ last := each last.
									todo := pattern size - (end - first) - 1 ] ]
						ifFalse: [ first := each first.
							todo <= each size
								ifTrue: [ last := each first + todo - 1 ]
								ifFalse: [ last := each last.
									todo := todo - each size ] ].
					self styleFrom: first to: last with: HighlightAttributes ].
			patternEnd <= end
				ifTrue: [ ^ self ].
			offset := end + 1 ]
]

{ #category : #accessing }
GtImplementorPatternHighlighter >> pattern [
	^ pattern
]

{ #category : #accessing }
GtImplementorPatternHighlighter >> pattern: aString [
	pattern := aString asLowercase
]

{ #category : #visiting }
GtImplementorPatternHighlighter >> visitMethodNode: aMethodNode [
	super visitMethodNode: aMethodNode.
	self highlightMethod: aMethodNode
]
