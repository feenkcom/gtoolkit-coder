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
GtFilteredCodersModel >> additionalFilters [
	<return: #Collection of: #GtSearchFilter>

	^ additionalFilters
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> additionalFilters: aCollectionOfFilters [
	monitor critical: [ 
		additionalFilters := aCollectionOfFilters asArray.
		compositeFilter := self
			createCombinedFilterFor: filter
			andAdditionalFilters: additionalFilters.
		self refreshItemsStreamDueTo: GtFilteredCodersAdditionalFiltersReason new ]
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> compositeFilter [
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
		into: [ :sum :each | sum ifNil: [ each ] ifNotNil: [ sum | each ] ].

	aCompositeFilter := aCompositeFilter
		ifNil: [ aMainSearchFilter ]
		ifNotNil: [ aMainSearchFilter & aCompositeFilter ].

	^ aCompositeFilter
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> filter [
	<return: #GtSearchFilter>

	^ filter
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> filter: aGtSearchFilter [
	monitor critical: [ 
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
