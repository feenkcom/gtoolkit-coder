Class {
	#name : #GtSearchTypedGroupResult,
	#superclass : #GtSearchGroupResult,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'as yet unclassified' }
GtSearchTypedGroupResult class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithTypedGroup: self.
]

{ #category : #'as yet unclassified' }
GtSearchTypedGroupResult class >> mergeTypeWithTypedGroup: aGroupType [
	^ aGroupType = self 
		ifTrue: [ self ]
		ifFalse: [ GtSearchGroupResult ]
]
