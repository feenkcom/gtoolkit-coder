Class {
	#name : #GtSourceCoderEditorElementEvaluationHighlighter,
	#superclass : #Object,
	#instVars : [
		'editorElement',
		'updateRequester',
		'evaluationResult',
		'highlighterAttributes'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #'private - ui' }
GtSourceCoderEditorElementEvaluationHighlighter >> addHighlight: anEvaluationResult [
	| anEvaluatedSource anEvaluatedInterval theSourceStartInText theSourceEndInText anUnderlineAttribute aResultButtonAttribute |
	
	"(GtCoderPrintStringAttribute forString: value printString)"
	
	anEvaluatedSource := anEvaluationResult sourceString.
	anEvaluatedInterval := anEvaluationResult sourceInterval.
	
	theSourceStartInText := self text finder
		caseSensitiveSubstring: anEvaluatedSource;
		startAtPosition: anEvaluatedInterval first;
		searchClosest.
	
	"what did we evaluate?"
	theSourceStartInText isZero
		ifTrue: [ ^ self ].

	theSourceEndInText := (theSourceStartInText + anEvaluatedSource size - 1) min: self text size.
	
	anEvaluationResult isSuccess
		ifTrue: [
			highlighterAttributes := {
				anUnderlineAttribute := BlTextDecorationAttribute new
					underline;
					color: (Color fromHexString: #'90CAF9');
					thickness: 1;
					beNotOverwritableByStyler.
				aResultButtonAttribute := GtPlaygroundEvaluatedCodeButtonAttribute new 
					result: anEvaluationResult value;
					coder: anEvaluationResult sourceCoder; "Pass the coder to get the spawn destination"
					beNotOverwritableByStyler }.
			"(self text 
				from: theSourceStartInText
				to: theSourceEndInText) attribute: anUnderlineAttribute."
			(self text 
				from: theSourceEndInText
				to: theSourceEndInText) attribute: aResultButtonAttribute ].
]

{ #category : #accessing }
GtSourceCoderEditorElementEvaluationHighlighter >> editorElement [
	^ editorElement
]

{ #category : #accessing }
GtSourceCoderEditorElementEvaluationHighlighter >> editorElement: anObject [
	editorElement := anObject.
	updateRequester element: editorElement
]

{ #category : #accessing }
GtSourceCoderEditorElementEvaluationHighlighter >> evaluationResult [
	^ evaluationResult
]

{ #category : #'api - highlighter' }
GtSourceCoderEditorElementEvaluationHighlighter >> highlight: anEvaluationResult [
	evaluationResult = anEvaluationResult
		ifTrue: [ ^ self ].
	evaluationResult := anEvaluationResult.
	updateRequester requestUpdate
]

{ #category : #'api - highlighter' }
GtSourceCoderEditorElementEvaluationHighlighter >> highlightSynchronously: anEvaluationResult [
	evaluationResult = anEvaluationResult
		ifTrue: [ ^ self ].
	evaluationResult := anEvaluationResult.
	self updateHighlight
]

{ #category : #initialization }
GtSourceCoderEditorElementEvaluationHighlighter >> initialize [
	super initialize.
	
	editorElement := nil.
	evaluationResult := nil.
	
	updateRequester := GtPhlowUpdateRequester new.
	updateRequester action: [ self updateHighlight ].
	highlighterAttributes := #()
]

{ #category : #'private - ui' }
GtSourceCoderEditorElementEvaluationHighlighter >> removeHighlight [
	self text removeAttributes: highlighterAttributes.
	highlighterAttributes := #()
]

{ #category : #accessing }
GtSourceCoderEditorElementEvaluationHighlighter >> text [
	^ self editorElement text
]

{ #category : #'private - ui' }
GtSourceCoderEditorElementEvaluationHighlighter >> updateHighlight [
	self removeHighlight.
	evaluationResult
		ifNotNil: [ :anEvaluationResult | self addHighlight: anEvaluationResult ]
]
