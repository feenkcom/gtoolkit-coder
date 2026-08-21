"
I am announced when a {{gtClass:GtTextualCoderTextHighlight}} is removed from a {{gtClass:GtTextualCoderViewModel}}. I mirror {{gtClass:GtTextualCoderViewModelTextAttributesRemoved}}.
"
Class {
	#name : #GtTextualCoderViewModelTextHighlightRemoved,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'textHighlight'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelTextHighlightRemoved >> documentId [
	"Answer the document my highlight belonged to. Derived, never cached."

	<return: #BlTextDocumentId>
	^ textHighlight ifNotNil: #documentId
]

{ #category : #accessing }
GtTextualCoderViewModelTextHighlightRemoved >> textHighlight [
	<return: #GtTextualCoderTextHighlight>
	^ textHighlight
]

{ #category : #accessing }
GtTextualCoderViewModelTextHighlightRemoved >> textHighlight: aGtTextualCoderTextHighlight [
	textHighlight := aGtTextualCoderTextHighlight
]
