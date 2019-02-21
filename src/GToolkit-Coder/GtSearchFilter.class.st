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

{ #category : #accessing }
GtSearchFilter >> defaultFilterScope [
	^ GtSearchNullFilter new
]

{ #category : #ui }
GtSearchFilter >> gtItemsFor: aView [
	"this is a view that is polymorphic with the one defined in ${method:Collection>>#gtItemsFor:}$"
	<gtView>
	^ self result gtItemsFor: aView
]

{ #category : #accessing }
GtSearchFilter >> highlighter [
	^ nil
]

{ #category : #testing }
GtSearchFilter >> matches: anObject [
	self subclassResponsibility
]

{ #category : #'logical operations' }
GtSearchFilter >> not [
	^ GtSearchNegationFilter new originalFilter: self
]

{ #category : #converting }
GtSearchFilter >> result [
	^ self applyInScope: self defaultFilterScope
]

{ #category : #accessing }
GtSearchFilter >> resultType [
	^ GtSearchNullGroupResult
]

{ #category : #'logical operations' }
GtSearchFilter >> select: aBlock [
	^ self & (GtSearchBlockFilter forBlock: aBlock)
]

{ #category : #'logical operations' }
GtSearchFilter >> | aFilter [
	^ GtSearchUnionFilter forFilter: self filter: aFilter
]
