Class {
	#name : #GtSearchFilter,
	#superclass : #Object,
	#category : #'GToolkit-SearchFilters'
}

{ #category : #accessing }
GtSearchFilter class >> allSearchFilterMethods [
	| methods |
	methods := ((Pragma allNamed: 'gtSearchFilter')
			select: [ :each | each method methodClass isClassSide and: [ each method numArgs = 0 ] ])
			collect: [ :each | each method ].
	^ methods
]

{ #category : #accessing }
GtSearchFilter class >> allSearchFilters [
	^ (self allSearchFilterMethods
		collect: [ :each | 
			([ each methodClass instanceSide perform: each selector ]
				on: Error
				do: [ :ex | ex return ])
				ifNotNil: [ :filter | 
					filter filterLabel
						ifNil: [ (filter
								labeled: each methodClass instanceSide name asString , ' ' , each selector)
								methodDefinition: each;
								yourself ]
						ifNotNil: [ filter ] ] ]) reject: #isNil
]

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
GtSearchFilter >> contents [

	"Convenience method. By analogy with PositionableStream>>#contents.
	Sometimes you really want the actual result, and not a future.
	For example:
		(#gtExample gtPragmas & #assert: gtSenders) contents
			asOrderedCollection sort: [ :a :b | a size < b size ]
	will return the actual result array so you can sort it.
	The async way to do that would be:
		((#gtExample gtPragmas & #assert: gtSenders) result toArray 
			then: [ :anArray | anArray sorted: [ :a :b | a size < b size ] ]) await
	"

	^ self result toArray wait
]

{ #category : #accessing }
GtSearchFilter >> defaultFilterScope [
	^ AsyncEmptyStream new
]

{ #category : #iterating }
GtSearchFilter >> do: aBlock [
	(self result do: aBlock) wait
]

{ #category : #accessing }
GtSearchFilter >> filterLabel [
	^ nil
]

{ #category : #accessing }
GtSearchFilter >> filterValueString [
	^ nil
]

{ #category : #testing }
GtSearchFilter >> isEmpty [
	^ self notEmpty not
]

{ #category : #accessing }
GtSearchFilter >> labeled: aString [
	^ GtLabeledSearchFilter new
		filter: self;
		filterLabel: aString;
		methodDefinition: thisContext sender method method;
		yourself
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
