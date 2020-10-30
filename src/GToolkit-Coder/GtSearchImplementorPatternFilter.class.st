Class {
	#name : #GtSearchImplementorPatternFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchImplementorPatternFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		creator: [ :value | self pattern: value ]
		named: 'Implementor'
		order: 10
		completion:
			(GtStringsCompletionStrategy new
				completions: aMethodsCoder selectorNames)
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

{ #category : #accessing }
GtSearchImplementorPatternFilter >> filterValueString [
	^ self pattern
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
