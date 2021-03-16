Class {
	#name : #GtPharoSubstringLiteralHighlighter,
	#superclass : #GtPharoCodeHighlighter,
	#instVars : [
		'substring',
		'caseSensitive'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #'instance creation' }
GtPharoSubstringLiteralHighlighter class >> substring: aString [
	^ self new substring: aString
]

{ #category : #'instance creation' }
GtPharoSubstringLiteralHighlighter class >> substring: aString caseSensitive: aBoolean [
	^ self new substring: aString; caseSensitive: aBoolean
]

{ #category : #'api - accessing' }
GtPharoSubstringLiteralHighlighter >> caseSensitive [
	<return: #Boolean>
	^ caseSensitive
]

{ #category : #'api - accessing' }
GtPharoSubstringLiteralHighlighter >> caseSensitive: aBoolean [
	self 
		assert: [ aBoolean isBoolean ] 
		description: [ 'Case sensitive must be a boolean value' ].
	caseSensitive := aBoolean.
]

{ #category : #initialization }
GtPharoSubstringLiteralHighlighter >> initialize [
	super initialize.

	caseSensitive := false
]

{ #category : #'api - accessing' }
GtPharoSubstringLiteralHighlighter >> substring [
	^ substring
]

{ #category : #'api - accessing' }
GtPharoSubstringLiteralHighlighter >> substring: aString [
	substring := aString
]

{ #category : #visiting }
GtPharoSubstringLiteralHighlighter >> visitStringLiteral: aNode [
	| source index |

	source := aNode string.
	index := 1.
	[ (index := source
		findString: self substring
		startingAt: index
		caseSensitive: self caseSensitive) > 0 ]
		whileTrue: [
			stream nextPut: (index - 1 + aNode startPosition to: index + aNode startPosition + self substring size - 2).
			index := index + self substring size ]
]
