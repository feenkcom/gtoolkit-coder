Class {
	#name : #GtAsyncSearchNullGroupStream,
	#superclass : #GtAsyncSearchGroupStream,
	#category : #'GToolkit-SearchFilters-Results'
}

{ #category : #'as yet unclassified' }
GtAsyncSearchNullGroupStream class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithGenericGroup.
]

{ #category : #'as yet unclassified' }
GtAsyncSearchNullGroupStream class >> mergeTypeWithTypedGroup: aGroupType [
	^ aGroupType
]

{ #category : #'private - updating' }
GtAsyncSearchNullGroupStream >> filteredItemsStream [
	^ AsyncEmptyStream new
]
