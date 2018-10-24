Class {
	#name : #GtCoderMethodsFilter,
	#superclass : #Object,
	#category : #'GToolkit-Coder'
}

{ #category : #'logical operations' }
GtCoderMethodsFilter >> & aFilter [
	^ GtCoderIntersectionFilter forFilter: self filter: aFilter
]

{ #category : #accessing }
GtCoderMethodsFilter >> highlighter [
	^ nil
]

{ #category : #testing }
GtCoderMethodsFilter >> includeMethod: aCompiledMethod [
	self subclassResponsibility
]

{ #category : #'logical operations' }
GtCoderMethodsFilter >> | aFilter [
	^ GtCoderUnionFilter forFilter: self filter: aFilter
]
