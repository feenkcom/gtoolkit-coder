Class {
	#name : #GtPharoSubstringHighlighter,
	#superclass : #GtPharoCodeHighlighter,
	#instVars : [
		'substring'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #'instance creation' }
GtPharoSubstringHighlighter class >> substring: aString [
	^ self new substring: aString
]

{ #category : #accessing }
GtPharoSubstringHighlighter >> substring [
	^ substring
]

{ #category : #accessing }
GtPharoSubstringHighlighter >> substring: aString [
	substring := aString
]

{ #category : #visiting }
GtPharoSubstringHighlighter >> visitMethod: aMethodNode [
	| source index |

	source := aMethodNode completeSource asString.

	index := 1.
	[ (index := source
		findString: self substring
		startingAt: index
		caseSensitive: false) > 0 ]
		whileTrue: [
			stream nextPut: (index to: index + self substring size - 1).
			index := index + self substring size ]
]
