"
I am a text highlight recorded by a {{gtClass:GtTextualCoderViewModel}}.

I hold a `BrTextHighlight` and the `BrTextCharacterRange` it applies to. The range carries the `BlTextDocumentId` of the text the range was computed against, so I can only ever be applied to that exact document version.

I am kept separately from {{gtClass:GtTextualCoderTextAttributes}} because `BlTextHighlightAttribute` is only valid inside `BrTextEditorModel>>#addHighlight:overRange:`, `#addHighlight:overMarker:` and `#removeHighlightsWithId:`. Highlights are applied after the extra text attributes, so they paint over them.

Being recorded rather than fire-and-forget is what lets a coder element re-apply me once its editor catches up with the coder model's document.
"
Class {
	#name : #GtTextualCoderTextHighlight,
	#superclass : #Object,
	#instVars : [
		'textHighlight',
		'textRange'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #actions }
GtTextualCoderTextHighlight >> applyOnEditorElement: aTextEditorElement [
	"Apply me on the given editor element. The editor compares my range's document id with
	the document it edits and ignores me when they differ, so applying me on a stale editor
	is harmless."

	aTextEditorElement addHighlight: textHighlight overRange: textRange
]

{ #category : #accessing }
GtTextualCoderTextHighlight >> documentId [
	"Answer the id of the document my range was computed against."

	<return: #BlTextDocumentId>
	^ textRange ifNotNil: #documentId
]

{ #category : #accessing }
GtTextualCoderTextHighlight >> id [
	"Answer the id identifying my highlight, used to remove it again."

	^ textHighlight ifNotNil: #id
]

{ #category : #printing }
GtTextualCoderTextHighlight >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: self id;
		nextPutAll: ' over ';
		print: textRange;
		nextPut: $)
]

{ #category : #actions }
GtTextualCoderTextHighlight >> removeFromEditorElement: aTextEditorElement [
	aTextEditorElement removeHighlightsWithId: self id
]

{ #category : #accessing }
GtTextualCoderTextHighlight >> textHighlight [
	<return: #BrTextHighlight>
	^ textHighlight
]

{ #category : #accessing }
GtTextualCoderTextHighlight >> textHighlight: aBrTextHighlight [
	textHighlight := aBrTextHighlight
]

{ #category : #accessing }
GtTextualCoderTextHighlight >> textRange [
	<return: #BrTextCharacterRange>
	^ textRange
]

{ #category : #accessing }
GtTextualCoderTextHighlight >> textRange: aBrTextCharacterRange [
	textRange := aBrTextCharacterRange
]
