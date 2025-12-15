Class {
	#name : #GtTextualCoderViewModelSelectionChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'source',
		'selection',
		'shouldUpdateCursor'
	],
	#category : 'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelSelectionChanged >> selection [
	^ selection
]

{ #category : #accessing }
GtTextualCoderViewModelSelectionChanged >> selection: anObject [
	selection := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelSelectionChanged >> shouldUpdateCursor [
	^ shouldUpdateCursor ifNil: [ false ]
]

{ #category : #accessing }
GtTextualCoderViewModelSelectionChanged >> shouldUpdateCursor: aBoolean [
	shouldUpdateCursor := aBoolean
]

{ #category : #accessing }
GtTextualCoderViewModelSelectionChanged >> source [
	^ source
]

{ #category : #accessing }
GtTextualCoderViewModelSelectionChanged >> source: anObject [
	source := anObject
]
