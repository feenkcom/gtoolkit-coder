Class {
	#name : #GtStreamingCodersStreamChanged,
	#superclass : #Announcement,
	#instVars : [
		'dueTo'
	],
	#category : #'GToolkit-Coder-StreamingCoders-Events'
}

{ #category : #accessing }
GtStreamingCodersStreamChanged >> dueTo [

	^ dueTo
]

{ #category : #accessing }
GtStreamingCodersStreamChanged >> dueTo: anObject [

	dueTo := anObject
]

{ #category : #accessing }
GtStreamingCodersStreamChanged >> isDueTo: aReasonClass [
	^ dueTo isKindOf: aReasonClass
]
