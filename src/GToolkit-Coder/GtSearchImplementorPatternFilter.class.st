Class {
	#name : #GtSearchImplementorPatternFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchImplementorPatternFilter class >> filterDescriptorFor: aMethodCoder [
	^ GtFilterDescriptor
		forClass: self
		named: 'Implementor'
		order: 10
		getter: #pattern
]

{ #category : #'instance creation' }
GtSearchImplementorPatternFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #comparing }
GtSearchImplementorPatternFilter >> = anObject [
	^ self class = anObject class
		and: [ self pattern asLowercase = anObject pattern asLowercase ]
]

{ #category : #printing }
GtSearchImplementorPatternFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self pattern printString;
		nextPutAll: ' implementors matching'
]

{ #category : #comparing }
GtSearchImplementorPatternFilter >> hash [
	^ self class hash bitXor: self pattern asLowercase hash
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
