Class {
	#name : #GtSearchPragmasFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'symbol'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtSearchPragmasFilter class >> forPragma: aSymbol [
	^ self new
		symbol: aSymbol;
		yourself
]

{ #category : #printing }
GtSearchPragmasFilter >> gtDisplayOn: stream [
	stream 
		nextPutAll: self symbol printString;
		nextPutAll: ' pragmas'
]

{ #category : #accessing }
GtSearchPragmasFilter >> highlighter [
	^ GtPragmaHighlighter forPragma: symbol
]

{ #category : #testing }
GtSearchPragmasFilter >> includesMethod: aCompiledMethod [
	^ aCompiledMethod hasPragmaNamed: symbol
]

{ #category : #printing }
GtSearchPragmasFilter >> printOn: aStream [
	aStream 
		nextPutAll: self symbol printString;
		nextPutAll: ' gtPragmas'
]

{ #category : #accessing }
GtSearchPragmasFilter >> symbol [
	^ symbol
]

{ #category : #accessing }
GtSearchPragmasFilter >> symbol: aSymbol [
	symbol := aSymbol
]
