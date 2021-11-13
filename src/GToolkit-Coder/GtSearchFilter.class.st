Class {
	#name : #GtSearchFilter,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Filters'
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

{ #category : #evaluating }
GtSearchFilter >> applyInScopeStream: aStream [
	^ self resultType new
		forFilter: self
		scope: aStream
]

{ #category : #converting }
GtSearchFilter >> asAsyncStream [
	^ self result
]

{ #category : #converting }
GtSearchFilter >> asCoder [
	^ self result asCoder
]

{ #category : #converting }
GtSearchFilter >> asElement [
	^ self asCoder asElement
]

{ #category : #accessing }
GtSearchFilter >> defaultFilterScope [
	^ AsyncEmptyStream new
]

{ #category : #iterating }
GtSearchFilter >> do: aBlock [
	((self result do: aBlock)
		inject: 0 into: [ :total :each | total + 1 ])
			wait
]

{ #category : #converting }
GtSearchFilter >> gtExamples [
	| examples |
	examples := OrderedCollection new.
	self result do: [ :each | examples addAll: each gtExamples ].
	^ GtExampleGroup withAll: examples
]

{ #category : #accessing }
GtSearchFilter >> highlighter [
	^ nil
]

{ #category : #accessing }
GtSearchFilter >> isEmpty [
	^ self result isEmpty
]

{ #category : #testing }
GtSearchFilter >> matches: anObject [
	self subclassResponsibility
]

{ #category : #'logical operations' }
GtSearchFilter >> not [
	^ GtSearchNegationFilter new originalFilter: self
]

{ #category : #testing }
GtSearchFilter >> notEmpty [
	^ self result hasNext wait
]

{ #category : #converting }
GtSearchFilter >> result [
	^ self applyInScopeStream: self defaultFilterScope
]

{ #category : #accessing }
GtSearchFilter >> resultType [
	^ GtAsyncSearchNullGroupStream
]

{ #category : #'logical operations' }
GtSearchFilter >> select: aBlock [
	^ self & (GtSearchBlockFilter forBlock: aBlock)
]

{ #category : #accessing }
GtSearchFilter >> size [
	^ self result size
]

{ #category : #testing }
GtSearchFilter >> value: anObject [
	"To be polymorphic with block closures"

	^ self matches: anObject
]

{ #category : #'logical operations' }
GtSearchFilter >> | aFilter [
	^ GtSearchUnionFilter forFilter: self filter: aFilter
]
