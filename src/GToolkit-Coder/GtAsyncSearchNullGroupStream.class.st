Class {
	#name : #GtAsyncSearchNullGroupStream,
	#superclass : #GtSearchGroupResult,
	#category : 'GToolkit-Coder-Filters - Streams'
}

{ #category : #'as yet unclassified' }
GtAsyncSearchNullGroupStream class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithGenericGroup.
]

{ #category : #'as yet unclassified' }
GtAsyncSearchNullGroupStream class >> mergeTypeWithTypedGroup: aGroupType [
	^ aGroupType
]

{ #category : #enumerating }
GtAsyncSearchNullGroupStream >> refreshItems [
	filtered
		ifTrue: [ ^ self ].	
	items := OrderedCollection new.
	filtered := true.
]
