Class {
	#name : #GtAsyncSearchTypedGroupStream,
	#superclass : #GtAsyncSearchGroupStream,
	#instVars : [
		'announcer'
	],
	#category : #'GToolkit-SearchFilters-Results'
}

{ #category : #'as yet unclassified' }
GtAsyncSearchTypedGroupStream class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithTypedGroup: self.
]

{ #category : #'as yet unclassified' }
GtAsyncSearchTypedGroupStream class >> mergeTypeWithTypedGroup: aGroupType [
	^ aGroupType = self 
		ifTrue: [ self ]
		ifFalse: [ GtAsyncSearchGroupStream ]
]

{ #category : #accessing }
GtAsyncSearchTypedGroupStream >> announcer [
	^ announcer
]

{ #category : #initialization }
GtAsyncSearchTypedGroupStream >> initialize [
	super initialize.
	announcer := Announcer new.
	self subscribe
]

{ #category : #subscription }
GtAsyncSearchTypedGroupStream >> subscribe [
]
