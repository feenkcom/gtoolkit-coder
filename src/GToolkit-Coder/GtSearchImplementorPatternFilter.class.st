Class {
	#name : #GtSearchImplementorPatternFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchImplementorPatternFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #printing }
GtSearchImplementorPatternFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self pattern printString;
		nextPutAll: ' implementors matching'
]

{ #category : #accessing }
GtSearchImplementorPatternFilter >> highlighter [
	pattern isEmpty
		ifTrue: [ ^ super highlighter ].
	^ GtImplementorPatternHighlighter forPattern: pattern
]

{ #category : #testing }
GtSearchImplementorPatternFilter >> includesMethod: aCompiledMethod [
	^ pattern isEmpty or: [ (aCompiledMethod selector asLowercase indexOfSubCollection: pattern asLowercase) > 0 ]
]

{ #category : #accessing }
GtSearchImplementorPatternFilter >> pattern [
	^ pattern
]

{ #category : #accessing }
GtSearchImplementorPatternFilter >> pattern: aString [
	pattern := aString
]
