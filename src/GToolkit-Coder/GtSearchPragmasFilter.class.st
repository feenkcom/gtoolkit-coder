Class {
	#name : #GtSearchPragmasFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'symbol'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchPragmasFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		forClass: self
		named: 'Pragma'
		order: 11
		getter: #symbol
		setter: #symbol:
		completion:
			(GtStringsCompletionStrategy new
				completions: aMethodsCoder pragmaNames)
]

{ #category : #'instance creation' }
GtSearchPragmasFilter class >> forPragma: aSymbol [
	^ self new
		symbol: aSymbol;
		yourself
]

{ #category : #comparing }
GtSearchPragmasFilter >> = anObject [
	^ self class = anObject class and: [ self symbol = anObject symbol ]
]

{ #category : #printing }
GtSearchPragmasFilter >> gtDisplayOn: stream [
	stream 
		nextPutAll: self symbol printString;
		nextPutAll: ' pragmas'
]

{ #category : #comparing }
GtSearchPragmasFilter >> hash [
	^ self class hash bitXor: self symbol hash
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
