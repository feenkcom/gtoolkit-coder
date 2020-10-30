Class {
	#name : #GtSubstringHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'substring'
	],
	#category : #'GToolkit-Coder-AddOns-Reference highlighter'
}

{ #category : #'instance creation' }
GtSubstringHighlighter class >> substring: aString [
	^ self new substring: aString
]

{ #category : #accessing }
GtSubstringHighlighter >> substring [
	^ substring
]

{ #category : #accessing }
GtSubstringHighlighter >> substring: aString [
	substring := aString
]

{ #category : #visiting }
GtSubstringHighlighter >> visitMethodNode: aMethodNode [
	| source index |
	source := aMethodNode source.
	index := 1.
	[ (index := source
		findString: self substring
		startingAt: index
		caseSensitive: false) > 0 ]
		whileTrue: [ self
				styleFrom: index
				to: index + self substring size - 1
				with: HighlightAttributes.
			index := index + self substring size ]
]
