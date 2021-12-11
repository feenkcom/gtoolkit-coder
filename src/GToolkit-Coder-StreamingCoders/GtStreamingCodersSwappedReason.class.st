Class {
	#name : #GtStreamingCodersSwappedReason,
	#superclass : #GtStreamingCodersStreamChangedReason,
	#instVars : [
		'coderA',
		'coderB'
	],
	#category : #'GToolkit-Coder-StreamingCoders-Events'
}

{ #category : #accessing }
GtStreamingCodersSwappedReason >> coderA [

	^ coderA
]

{ #category : #accessing }
GtStreamingCodersSwappedReason >> coderA: anObject [

	coderA := anObject
]

{ #category : #accessing }
GtStreamingCodersSwappedReason >> coderB [

	^ coderB
]

{ #category : #accessing }
GtStreamingCodersSwappedReason >> coderB: anObject [

	coderB := anObject
]
