Class {
	#name : #GtSearchFilter,
	#superclass : #Object,
	#category : #'GToolkit-SearchFilters'
}

{ #category : #'logical operations' }
GtSearchFilter >> & aFilter [
	^ GtSearchIntersectionFilter forFilter: self filter: aFilter
]

{ #category : #evaluating }
GtSearchFilter >> applyInScope: aStream [
	^ self resultType new
		forFilter: self
		scope: aStream
]

{ #category : #converting }
GtSearchFilter >> asAsyncStream [
	^ self result
]

{ #category : #accessing }
GtSearchFilter >> defaultFilterScope [
	^ AsyncEmptyStream new
]

{ #category : #iterating }
GtSearchFilter >> do: aBlock [
	(self result do: aBlock) wait
]

{ #category : #testing }
GtSearchFilter >> isEmpty [
	^ self notEmpty not
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
	^ self applyInScope: self defaultFilterScope
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
	^ (self result inject: 0 into: [ :counter :eachItem | counter + 1 ]) wait
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
