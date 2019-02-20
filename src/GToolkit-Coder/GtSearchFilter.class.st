Class {
	#name : #GtSearchFilter,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'logical operations' }
GtSearchFilter >> & aFilter [
	^ GtSearchIntersectionFilter forFilter: self filter: aFilter
]

{ #category : #evaluating }
GtSearchFilter >> applyInScope: aSearchScope [
	^ self resultType new
		scope: aSearchScope;
		filter: self
]

{ #category : #converting }
GtSearchFilter >> asCollection [
	^ self applyInScope: self defaultFilterScope
]

{ #category : #accessing }
GtSearchFilter >> defaultFilterScope [
	^ GtSearchImageScope new
]

{ #category : #ui }
GtSearchFilter >> gtItemsFor: aView [
	"this is a view that is polymorphic with the one defined in ${method:Collection>>#gtItemsFor:}$"
	<gtView>
	^ aView explicit
		title: 'Items' translated;
		priority: 0;
		stencil: [ self asCollection ]
]

{ #category : #accessing }
GtSearchFilter >> highlighter [
	self subclassResponsibility
]

{ #category : #testing }
GtSearchFilter >> isMethodFilter [
	^ false
]

{ #category : #testing }
GtSearchFilter >> matches: anObject [
	self subclassResponsibility
]

{ #category : #accessing }
GtSearchFilter >> resultType [
	self subclassResponsibility
]

{ #category : #'logical operations' }
GtSearchFilter >> | aFilter [
	^ GtSearchUnionFilter forFilter: self filter: aFilter
]
