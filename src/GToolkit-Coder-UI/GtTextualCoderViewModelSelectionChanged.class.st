Class {
	#name : #GtTextualCoderViewModelSelectionChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'source',
		'selection'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
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
GtTextualCoderViewModelSelectionChanged >> source [
	^ source
]

{ #category : #accessing }
GtTextualCoderViewModelSelectionChanged >> source: anObject [
	source := anObject
]
