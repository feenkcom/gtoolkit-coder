Class {
	#name : #GtCoderMethodsFilter,
	#superclass : #Object,
	#category : #'GToolkit-Coder'
}

{ #category : #'logical operations' }
GtCoderMethodsFilter >> & aFilter [
	^ GtCoderIntersectionFilter forFilter: self filter: aFilter
]

{ #category : #converting }
GtCoderMethodsFilter >> asCollection [
	^ GtCoderMethodsCollection forFilter: self
]

{ #category : #accessing }
GtCoderMethodsFilter >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 0;
		stencil: [ self asCollection ]
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
GtCoderMethodsFilter >> select: aBlock [
	^ self & (GtCoderBlockFilter forBlock: aBlock)
]

{ #category : #accessing }
GtCoderMethodsFilter >> size [
	^ self asCollection size
]

{ #category : #'logical operations' }
GtCoderMethodsFilter >> | aFilter [
	^ GtCoderUnionFilter forFilter: self filter: aFilter
]
