Class {
	#name : #GtTextualCoderViewModelCursorsChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'source',
		'cursors'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelCursorsChanged >> cursors [
	^ cursors
]

{ #category : #accessing }
GtTextualCoderViewModelCursorsChanged >> cursors: anObject [
	cursors := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelCursorsChanged >> source [
	^ source
]

{ #category : #accessing }
GtTextualCoderViewModelCursorsChanged >> source: anObject [
	source := anObject
]
