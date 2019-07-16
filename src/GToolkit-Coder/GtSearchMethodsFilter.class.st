Class {
	#name : #GtSearchMethodsFilter,
	#superclass : #GtSearchTypedEntitiesFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchMethodsFilter class >> resultType [
	^ GtSearchMethodGroupResult 
]

{ #category : #accessing }
GtSearchMethodsFilter >> defaultFilterScope [
	^ GtSearchImageMethodsFilter new
]

{ #category : #testing }
GtSearchMethodsFilter >> includesMethod: aCompiledMethod [
	self subclassResponsibility
]

{ #category : #accessing }
GtSearchMethodsFilter >> linesOfCode [
	^ self result sumNumbers: [:method | method linesOfCode]
]

{ #category : #testing }
GtSearchMethodsFilter >> matches: anObject [
	^ anObject isCompiledMethod and: [ 
		self includesMethod: anObject ]
]
