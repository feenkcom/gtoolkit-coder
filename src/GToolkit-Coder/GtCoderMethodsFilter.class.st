Class {
	#name : #GtCoderMethodsFilter,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'logical operations' }
GtCoderMethodsFilter >> & aFilter [
	^ GtCoderIntersectionFilter forFilter: self filter: aFilter
]

{ #category : #converting }
GtCoderMethodsFilter >> asCollection [
	^ GtCoderMethodsCollection forFilter: self
]

{ #category : #ui }
GtCoderMethodsFilter >> gtItemsFor: aView [
	"this is a view that is polymorphic with the one defined in ${method:Collection>>#gtItemsFor:}$"
	<gtView>
	^ aView explicit
		title: 'Items' translated;
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

{ #category : #accessing }
GtCoderMethodsFilter >> isEmpty [
	^ self asCollection isEmpty
]

{ #category : #'logical operations' }
GtCoderMethodsFilter >> not [
	^ GtCoderNegationFilter new originalFilter: self
]

{ #category : #testing }
GtCoderMethodsFilter >> notEmpty [
	^ self isEmpty not
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
