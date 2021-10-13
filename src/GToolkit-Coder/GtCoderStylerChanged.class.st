"
1. Coder styler changed event
**

Is announced by the {{gtClass:GtCoderModel}} when stylers change.


"
Class {
	#name : #GtCoderStylerChanged,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'stylers'
	],
	#category : 'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderStylerChanged >> stylers [
	^ stylers
]

{ #category : #accessing }
GtCoderStylerChanged >> stylers: anObject [
	stylers := anObject
]
