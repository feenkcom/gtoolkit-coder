Class {
	#name : #GtSearchNullGroupResult,
	#superclass : #GtSearchGroupResult,
	#category : 'GToolkit-Coder-Filters'
}

{ #category : #'as yet unclassified' }
GtSearchNullGroupResult class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithGenericGroup.
]

{ #category : #'as yet unclassified' }
GtSearchNullGroupResult class >> mergeTypeWithTypedGroup: aGroupType [
	^ aGroupType
]

{ #category : #enumerating }
GtSearchNullGroupResult >> refreshItems [
	filtered
		ifTrue: [ ^ self ].	
	items := OrderedCollection new.
	filtered := true.
]
