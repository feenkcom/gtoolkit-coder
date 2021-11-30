Class {
	#name : #GtStreamingCodersViewModelScrollTargetChanged,
	#superclass : #Announcement,
	#instVars : [
		'scrollTarget'
	],
	#category : #'GToolkit-Coder-StreamingCoders-UI-Events'
}

{ #category : #accessing }
GtStreamingCodersViewModelScrollTargetChanged >> scrollTarget [

	^ scrollTarget
]

{ #category : #accessing }
GtStreamingCodersViewModelScrollTargetChanged >> scrollTarget: anObject [

	scrollTarget := anObject
]
