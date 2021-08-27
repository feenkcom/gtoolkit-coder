Class {
	#name : 'GtAsyncSearchTypedGroupStream',
	#superclass : 'GtAsyncSearchGroupStream',
	#instVars : [
		'announcer'
	],
	#category : 'GToolkit-Coder-Filters - Streams'
}

{ #category : 'as yet unclassified' }
GtAsyncSearchTypedGroupStream class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithTypedGroup: self.
]

{ #category : 'as yet unclassified' }
GtAsyncSearchTypedGroupStream class >> mergeTypeWithTypedGroup: aGroupType [
	^ aGroupType = self 
		ifTrue: [ self ]
		ifFalse: [ GtSearchGroupResult ]
]

{ #category : 'accessing' }
GtAsyncSearchTypedGroupStream >> announcer [
	^ announcer
]

{ #category : 'initialization' }
GtAsyncSearchTypedGroupStream >> initialize [
	super initialize.
	announcer := Announcer new.
	self subscribe
]

{ #category : 'subscription' }
GtAsyncSearchTypedGroupStream >> subscribe [
]
