Class {
	#name : 'GtSearchTypedGroupResult',
	#superclass : 'GtSearchGroupResult',
	#instVars : [
		'announcer'
	],
	#category : 'GToolkit-Coder-Filters'
}

{ #category : 'as yet unclassified' }
GtSearchTypedGroupResult class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithTypedGroup: self.
]

{ #category : 'as yet unclassified' }
GtSearchTypedGroupResult class >> mergeTypeWithTypedGroup: aGroupType [
	^ aGroupType = self 
		ifTrue: [ self ]
		ifFalse: [ GtSearchGroupResult ]
]

{ #category : 'accessing' }
GtSearchTypedGroupResult >> announcer [
	^ announcer
]

{ #category : 'initialization' }
GtSearchTypedGroupResult >> initialize [
	super initialize.
	announcer := Announcer new.
	self subscribe
]

{ #category : 'subscription' }
GtSearchTypedGroupResult >> subscribe [
]
