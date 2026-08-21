"
I am announced when a {{gtClass:GtTextualCoderTextHighlight}} is added to a {{gtClass:GtTextualCoderViewModel}}. I mirror {{gtClass:GtTextualCoderViewModelTextAttributesAdded}}.
"
Class {
	#name : #GtTextualCoderViewModelTextHighlightAdded,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'textHighlight'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelTextHighlightAdded >> documentId [
	"Answer the document my highlight belongs to. Derived, never cached."

	<return: #BlTextDocumentId>
	^ textHighlight ifNotNil: #documentId
]

{ #category : #accessing }
GtTextualCoderViewModelTextHighlightAdded >> textHighlight [
	<return: #GtTextualCoderTextHighlight>
	^ textHighlight
]

{ #category : #accessing }
GtTextualCoderViewModelTextHighlightAdded >> textHighlight: aGtTextualCoderTextHighlight [
	textHighlight := aGtTextualCoderTextHighlight
]
