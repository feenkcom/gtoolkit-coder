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
GtFilteredCodersModel >> additionalFilters: aCollectionOfFilters [
	monitor critical: [ 
		additionalFilters := aCollectionOfFilters asArray.
		self notifyChanged ]
]

{ #category : #'api - converting' }
GtFilteredCodersModel >> asAsyncStream [
	<return: #TAsyncStream>

	^ self filteredItemsStream map: [ :eachItem | self privateFetchCoderFor: eachItem ]
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> filter [
	^ filter
]

{ #category : #'api - accessing' }
GtFilteredCodersModel >> filter: aGtSearchFilter [
	monitor critical: [ 
		filter := aGtSearchFilter.
		self notifyChanged ]
]

{ #category : #'api - converting' }
GtFilteredCodersModel >> filteredItemsStream [
	| aCompositeFilter |
	
	aCompositeFilter := additionalFilters
		inject: nil
		into: [ :sum :each | sum ifNil: [ each ] ifNotNil: [ sum | each ] ].
		
	aCompositeFilter := aCompositeFilter
		ifNil: [ filter ]
		ifNotNil: [ filter & aCompositeFilter ].

	^ aCompositeFilter asAsyncStream
]

{ #category : #initialization }
GtFilteredCodersModel >> initialize [
	super initialize.
	
	additionalFilters := #()
]
