Class {
	#name : #GtFilteredCodersModel,
	#superclass : #GtStreamingCodersModel,
	#instVars : [
		'filter',
		'additionalFilters',
		'compositeFilter'
	],
	#category : #'GToolkit-Coder-StreamingCoders-Coder'
}

{ #category : #'instance creation' }
GtFilteredCodersModel class >> forFilter: aGtSearchFilter [
	^ self new filter: aGtSearchFilter
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> addOrReplaceFilter: aFilter [
	"Add or replace one additional filter.
	A filter of the same class is replaced by the given filter."

	| newFilters isChanged |
	isChanged := false.
	newFilters := self additionalFilters
			collect: [ :eachFilter | 
				eachFilter filterType = aFilter filterType
					ifTrue: [ 
						isChanged := true.
						aFilter ]
					ifFalse: [ 
						eachFilter ] ].
						
	isChanged ifFalse: [ 
		newFilters := newFilters , {aFilter} ].
	self additionalFilters: newFilters
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> addOrReplaceFilters: aCollectionOfFilters [
	"Add or replace given additional filters.
	Each filter of the same filter type (class) is replaced by the given filters."

	| newFilters isChanged usedFilters |
	isChanged := false.
	usedFilters := OrderedCollection new.
	newFilters := self additionalFilters
			collect: [ :existingFilter | 
				aCollectionOfFilters
					detect: [ :givenFilter | 
						existingFilter filterType = givenFilter filterType ] 
					ifFound: [ :givenFilter |
						isChanged := true.
						usedFilters add: givenFilter.
						givenFilter ] 
					ifNone: [
						existingFilter ] ].
						
	newFilters := newFilters , (aCollectionOfFilters copyWithoutAll: usedFilters).
	self additionalFilters: newFilters
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> additionalFilters [
	<return: #Collection of: #GtSearchFilter>

	^ additionalFilters
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> additionalFilters: aCollectionOfFilters [
	| aNewCollection |
	aNewCollection := aCollectionOfFilters asArray.
	additionalFilters = aNewCollection ifTrue: [ ^ self ].
	mutex critical: [ 
		additionalFilters := aNewCollection.
		compositeFilter := self
			createCombinedFilterFor: filter
			andAdditionalFilters: additionalFilters.
		self refreshItemsStreamDueTo: GtFilteredCodersAdditionalFiltersReason new ].
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> compositeFilter [
	"I am combination of:
	- the main filter (see the `filter` method), and
	- additional filters (see the `additionalFilters` method).
	If `filter` is kind of input filter, `compositeFilter` is kind of output filter."

	<return: #GtSearchFilter>
	^ compositeFilter
]

{ #category : #'private - instance creation' }
GtFilteredCodersModel >> createCombinedFilterFor: aMainSearchFilter andAdditionalFilters: aCollectionOfFilters [
	"Given a main search filter and a potentially empty collection of additional filters,
	create a composition of those filters"
	<return: #GtSearchFilter>
	| aCompositeFilter |
	
	aCompositeFilter := aCollectionOfFilters
		inject: nil
		into: [ :sum :each | sum ifNil: [ each ] ifNotNil: [ sum & each ] ].

	aCompositeFilter := aCompositeFilter
		ifNil: [ aMainSearchFilter ]
		ifNotNil: [ aMainSearchFilter & aCompositeFilter ].

	^ aCompositeFilter
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> filter [
	"I am a main filter whose items may be futher filtered using additional filters"

	<return: #GtSearchFilter>
	^ filter
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> filter: aGtSearchFilter [
	mutex critical: [ 
		filter := aGtSearchFilter.
		compositeFilter := self
			createCombinedFilterFor: filter
			andAdditionalFilters: additionalFilters.
		self refreshItemsStreamDueTo: GtFilteredCodersFilterReason new ]
]

{ #category : #initialization }
GtFilteredCodersModel >> initialize [
	super initialize.
	
	filter := GtSearchNullFilter new.
	additionalFilters := #().
	compositeFilter := GtSearchNullFilter new.
]

{ #category : #'private - instance creation' }
GtFilteredCodersModel >> newItemsStream [
	^ compositeFilter asAsyncStream
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> requesterContextDo: aBlock [
	^ filter requesterContextDo: aBlock
]
