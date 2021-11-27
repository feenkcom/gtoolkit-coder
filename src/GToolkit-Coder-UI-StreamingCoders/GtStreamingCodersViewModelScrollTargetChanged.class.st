Class {
	#name : #GtStreamingCodersViewModelScrollTargetChanged,
	#superclass : #Announcement,
	#instVars : [
		'scrollTarget'
	],
	#category : #'GToolkit-Coder-UI-StreamingCoders-Events'
}

{ #category : #accessing }
GtStreamingCodersViewModelScrollTargetChanged >> scrollTarget [

	^ scrollTarget
]

{ #category : #accessing }
GtStreamingCodersViewModelScrollTargetChanged >> scrollTarget: anObject [

	scrollTarget := anObject
]
