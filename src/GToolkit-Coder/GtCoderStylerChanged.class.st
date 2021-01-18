"
!Coder styler changed event
""""This is an asynchronous event""""

Is announced by the ${class:GtCoderModel}$ when stylers change.
"
Class {
	#name : #GtCoderStylerChanged,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'stylers'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderStylerChanged >> stylers [
	^ stylers
]

{ #category : #accessing }
GtCoderStylerChanged >> stylers: anObject [
	stylers := anObject
]
