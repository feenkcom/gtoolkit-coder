Class {
	#name : #GtTextualCoderViewModelTextAttributesAdded,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'coderTextAttributes',
		'startPosition',
		'stopPosition',
		'text',
		'documentId'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> coderTextAttributes [
	^ coderTextAttributes
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> coderTextAttributes: anObject [
	coderTextAttributes := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> documentId [
	^ documentId
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> documentId: anObject [
	documentId := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> startPosition [
	^ startPosition
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> startPosition: anObject [
	startPosition := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> stopPosition [
	^ stopPosition
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> stopPosition: anObject [
	stopPosition := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> text [

	^ text
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> text: anObject [

	text := anObject
]
