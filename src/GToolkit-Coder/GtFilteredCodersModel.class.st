Class {
	#name : #GtFilteredCodersModel,
	#superclass : #GtStreamingCodersModel,
	#instVars : [
		'filter',
		'additionalFilters'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtFilteredCodersModel class >> forFilter: aGtSearchFilter [
	^ self new filter: aGtSearchFilter
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> additionalFilters [
	^ additionalFilters
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> additionalFilters: aCollectionOfFilters [
	monitor critical: [ 
		additionalFilters := aCollectionOfFilters asArray.
		self itemsStream: (self createItemsStreamForFilter: filter andAdditionalFilters: additionalFilters) ]
]

{ #category : #'private - instance creation' }
GtFilteredCodersModel >> createItemsStreamForFilter: aMainSearchFilter andAdditionalFilters: aCollectionOfFilters [
	"Given a main search filter and a potentially empty collection of additional filters,
	create a stream over the results of a composition of those filters"
	<return: #TAsyncStream>
	| aCompositeFilter |
	
	aCompositeFilter := aCollectionOfFilters
		inject: nil
		into: [ :sum :each | sum ifNil: [ each ] ifNotNil: [ sum | each ] ].

	aCompositeFilter := aCompositeFilter
		ifNil: [ aMainSearchFilter ]
		ifNotNil: [ aMainSearchFilter & aCompositeFilter ].

	^ aCompositeFilter asAsyncStream
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> filter [
	^ filter
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> filter: aGtSearchFilter [
	monitor critical: [ 
		filter := aGtSearchFilter.
		self itemsStream: (self createItemsStreamForFilter: filter andAdditionalFilters: additionalFilters) ]
]

{ #category : #initialization }
GtFilteredCodersModel >> initialize [
	super initialize.
	
	additionalFilters := #()
]
