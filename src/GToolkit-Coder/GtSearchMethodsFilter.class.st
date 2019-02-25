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

{ #category : #testing }
GtSearchMethodsFilter >> matches: anObject [
	^ anObject isCompiledMethod and: [ 
		self includesMethod: anObject ]
]
