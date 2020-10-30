Class {
	#name : #GtSearchInstanceMethodsFilter,
	#superclass : #GtSearchMethodsFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #comparing }
GtSearchInstanceMethodsFilter >> = anObject [
	^ self class = anObject class
]

{ #category : #comparing }
GtSearchInstanceMethodsFilter >> hash [
	^ self class hash
]

{ #category : #testing }
GtSearchInstanceMethodsFilter >> includesMethod: aCompiledMethod [
	^ aCompiledMethod methodClass isInstanceSide
]
