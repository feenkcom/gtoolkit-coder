Class {
	#name : #GtSubstringLiteralHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'substring',
		'caseSensitive'
	],
	#category : #'GToolkit-Coder-AddOns-Reference highlighter'
}

{ #category : #'instance creation' }
GtSubstringLiteralHighlighter class >> substring: aString [
	^ self new substring: aString
]

{ #category : #'instance creation' }
GtSubstringLiteralHighlighter class >> substring: aString caseSensitive: aBoolean [
	^ self new substring: aString; caseSensitive: aBoolean
]

{ #category : #'api - accessing' }
GtSubstringLiteralHighlighter >> caseSensitive [
	<return: #Boolean>
	^ caseSensitive
]

{ #category : #'api - accessing' }
GtSubstringLiteralHighlighter >> caseSensitive: aBoolean [
	self 
		assert: [ aBoolean isBoolean ] 
		description: [ 'Case sensitive must be a boolean value' ].
	caseSensitive := aBoolean.
]

{ #category : #initialization }
GtSubstringLiteralHighlighter >> initialize [
	super initialize.
	caseSensitive := false.
]

{ #category : #'api - accessing' }
GtSubstringLiteralHighlighter >> substring [
	^ substring
]

{ #category : #'api - accessing' }
GtSubstringLiteralHighlighter >> substring: aString [
	substring := aString
]

{ #category : #visiting }
GtSubstringLiteralHighlighter >> visitLiteralValueNode: aNode [
	| source index |
	source := aNode value.
	index := 1.
	[ (index := source
		findString: self substring
		startingAt: index
		caseSensitive: self caseSensitive) > 0 ]
		whileTrue: [ self
				styleFrom: index + aNode start
				to: index + aNode start + self substring size - 1
				with: HighlightAttributes.
			index := index + self substring size ]
]
