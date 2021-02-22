Class {
	#name : #GtSourceCoderFocusChanged,
	#superclass : #Announcement,
	#instVars : [
		'source',
		'focused'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Events'
}

{ #category : #accessing }
GtSourceCoderFocusChanged >> focused [
	^ focused
]

{ #category : #accessing }
GtSourceCoderFocusChanged >> focused: anObject [
	focused := anObject
]

{ #category : #accessing }
GtSourceCoderFocusChanged >> source [
	^ source
]

{ #category : #accessing }
GtSourceCoderFocusChanged >> source: anObject [
	source := anObject
]
