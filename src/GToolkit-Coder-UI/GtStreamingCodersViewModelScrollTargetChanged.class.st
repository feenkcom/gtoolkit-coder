Class {
	#name : #GtStreamingCodersViewModelScrollTargetChanged,
	#superclass : #Announcement,
	#instVars : [
		'scrollTarget'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtStreamingCodersViewModelScrollTargetChanged >> scrollTarget [

	^ scrollTarget
]

{ #category : #accessing }
GtStreamingCodersViewModelScrollTargetChanged >> scrollTarget: anObject [

	scrollTarget := anObject
]
