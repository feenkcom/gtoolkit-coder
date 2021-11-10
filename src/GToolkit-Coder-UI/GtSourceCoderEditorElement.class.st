Class {
	#name : #GtSourceCoderEditorElement,
	#superclass : #GtTextualCoderEditorElement,
	#category : #'GToolkit-Coder-UI-Coder - Textual'
}

{ #category : #'api - textual coder view model' }
GtSourceCoderEditorElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.
	
	self textualCoderViewModel evaluationResult
		ifNil: [ evaluationHighlighter hideResult ]
		ifNotNil: [ :aResult | evaluationHighlighter displayResult: aResult ]
]
