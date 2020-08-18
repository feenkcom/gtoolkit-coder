Class {
	#name : #GtSearchMethodsWithClassPatternFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchMethodsWithClassPatternFilter class >> filterDescriptorFor: aMethodCoder [
	aMethodCoder isForClass
		ifTrue: [ ^ nil ].
	^ GtFilterDescriptor
		forClass: self
		named: 'Class'
		order: 20
		getter: #pattern
		setter: #pattern:
		completion: GtClassesCompletionStrategy new
]

{ #category : #'instance creation' }
GtSearchMethodsWithClassPatternFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #comparing }
GtSearchMethodsWithClassPatternFilter >> = anObject [
	^ self class = anObject class
		and: [ self pattern asLowercase = anObject pattern asLowercase ]
]

{ #category : #printing }
GtSearchMethodsWithClassPatternFilter >> gtDisplayOn: stream [
	stream
		nextPutAll: self pattern printString;
		nextPutAll: ' classes matching'
]

{ #category : #comparing }
GtSearchMethodsWithClassPatternFilter >> hash [
	^ self class hash bitXor: self pattern asLowercase hash
]

{ #category : #testing }
GtSearchMethodsWithClassPatternFilter >> includesMethod: aCompiledMethod [
	| aClassName |
	aClassName := aCompiledMethod methodClass name asLowercase.
	^ pattern isEmpty or: [ (aClassName indexOfSubCollection: pattern asLowercase) > 0 ]
]

{ #category : #accessing }
GtSearchMethodsWithClassPatternFilter >> pattern [
	^ pattern
]

{ #category : #accessing }
GtSearchMethodsWithClassPatternFilter >> pattern: aString [
	pattern := aString
]
