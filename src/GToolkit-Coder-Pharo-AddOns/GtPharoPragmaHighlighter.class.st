Class {
	#name : #GtPharoPragmaHighlighter,
	#superclass : #GtPharoCodeHighlighter,
	#instVars : [
		'symbol'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #'instance creation' }
GtPharoPragmaHighlighter class >> forPragma: aSymbol [
	^ self new
		symbol: aSymbol;
		yourself
]

{ #category : #accessing }
GtPharoPragmaHighlighter >> symbol [
	^ symbol
]

{ #category : #accessing }
GtPharoPragmaHighlighter >> symbol: aSymbol [
	symbol := aSymbol
]

{ #category : #visiting }
GtPharoPragmaHighlighter >> visitPragma: aNode [
	aNode selector = symbol
		ifTrue: [ stream nextPut: (aNode startPosition to: aNode stopPosition) ]
]
