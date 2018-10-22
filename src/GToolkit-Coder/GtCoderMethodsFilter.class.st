Class {
	#name : #GtCoderMethodsFilter,
	#superclass : #Object,
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtCoderMethodsFilter >> highlighter [
	^ nil
]

{ #category : #testing }
GtCoderMethodsFilter >> includeMethod: aCompiledMethod [
	self subclassResponsibility
]
