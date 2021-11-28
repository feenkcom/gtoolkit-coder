Class {
	#name : #GtStreamingCodersRemovedReason,
	#superclass : #GtStreamingCodersStreamChangedReason,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-StreamingCoders-Events'
}

{ #category : #accessing }
GtStreamingCodersRemovedReason >> coder [

	^ coder
]

{ #category : #accessing }
GtStreamingCodersRemovedReason >> coder: anObject [

	coder := anObject
]
