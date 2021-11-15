Class {
	#name : #GtTextualCoderViewModelFocusChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'source',
		'focused'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelFocusChanged >> focused [
	^ focused
]

{ #category : #accessing }
GtTextualCoderViewModelFocusChanged >> focused: anObject [
	focused := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelFocusChanged >> source [
	^ source
]

{ #category : #accessing }
GtTextualCoderViewModelFocusChanged >> source: anObject [
	source := anObject
]
