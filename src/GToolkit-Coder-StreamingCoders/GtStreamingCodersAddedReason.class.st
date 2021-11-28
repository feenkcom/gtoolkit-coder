Class {
	#name : #GtStreamingCodersAddedReason,
	#superclass : #GtStreamingCodersStreamChangedReason,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-StreamingCoders-Events'
}

{ #category : #accessing }
GtStreamingCodersAddedReason >> coder [

	^ coder
]

{ #category : #accessing }
GtStreamingCodersAddedReason >> coder: anObject [

	coder := anObject
]
