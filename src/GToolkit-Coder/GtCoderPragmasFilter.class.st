Class {
	#name : #GtCoderPragmasFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'symbol'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderPragmasFilter class >> forPragma: aSymbol [
	^ self new
		symbol: aSymbol;
		yourself
]

{ #category : #accessing }
GtCoderPragmasFilter >> highlighter [
	^ GtPragmaHighlighter forPragma: symbol
]

{ #category : #testing }
GtCoderPragmasFilter >> includeMethod: aCompiledMethod [
	^ aCompiledMethod hasPragmaNamed: symbol
]

{ #category : #accessing }
GtCoderPragmasFilter >> symbol [
	^ symbol
]

{ #category : #accessing }
GtCoderPragmasFilter >> symbol: aSymbol [
	symbol := aSymbol
]
