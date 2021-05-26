Class {
	#name : #GtTextualCoderViewModelTextChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'text',
		'updateStrategy'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelTextChanged >> isSynchronous [
	^ self updateStrategy isSynchronous
]

{ #category : #accessing }
GtTextualCoderViewModelTextChanged >> source [
	^ self updateStrategy source
]

{ #category : #accessing }
GtTextualCoderViewModelTextChanged >> text [
	^ text
]

{ #category : #accessing }
GtTextualCoderViewModelTextChanged >> text: anObject [
	text := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelTextChanged >> updateStrategy [
	^ updateStrategy
]

{ #category : #accessing }
GtTextualCoderViewModelTextChanged >> updateStrategy: anObject [
	updateStrategy := anObject
]
