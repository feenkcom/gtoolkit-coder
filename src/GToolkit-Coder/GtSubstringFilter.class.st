Class {
	#name : #GtSubstringFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'substring'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSubstringFilter class >> filterDescriptorFor: aMethodCoder [
	^ GtFilterDescriptor
		forClass: self
		named: 'Substring'
		order: 90
		getter: #substring
]

{ #category : #'instance creation' }
GtSubstringFilter class >> substring: aString [
	^ self new substring: aString
]

{ #category : #comparing }
GtSubstringFilter >> = anObject [
	^ self class = anObject class
		and: [ self substring asLowercase = anObject substring asLowercase ]
]

{ #category : #printing }
GtSubstringFilter >> gtDisplayOn: stream [
	stream
		print: self substring;
		nextPutAll: ' substringMatch'
]

{ #category : #comparing }
GtSubstringFilter >> hash [
	^ self class hash bitXor: self substring asLowercase hash
]

{ #category : #accessing }
GtSubstringFilter >> highlighter [
	^ GtSubstringHighlighter substring: self substring
]

{ #category : #testing }
GtSubstringFilter >> includesMethod: aCompiledMethod [
	^ (aCompiledMethod sourceCode
		findString: self substring
		startingAt: 1
		caseSensitive: false) > 0
]

{ #category : #printing }
GtSubstringFilter >> printOn: aStream [
	aStream
		print: self substring;
		nextPutAll: ' gtSubstringMatch'
]

{ #category : #accessing }
GtSubstringFilter >> substring [
	^ substring
]

{ #category : #accessing }
GtSubstringFilter >> substring: aString [
	substring := aString
]
