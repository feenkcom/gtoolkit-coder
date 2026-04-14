Class {
	#name : #GtTextualCoderViewModelAddHighlightRequest,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'textHighlight',
		'textRange'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelAddHighlightRequest >> textHighlight [
	^ textHighlight
]

{ #category : #accessing }
GtTextualCoderViewModelAddHighlightRequest >> textHighlight: anObject [
	textHighlight := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelAddHighlightRequest >> textRange [
	^ textRange
]

{ #category : #accessing }
GtTextualCoderViewModelAddHighlightRequest >> textRange: anObject [
	textRange := anObject
]
