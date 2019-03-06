Class {
	#name : #GtCoderExpandableMethodStyler,
	#superclass : #GtCoderBodyStyler,
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #visiting }
GtCoderExpandableMethodStyler >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	"aMessageNode isUnary
		ifFalse: [ ^ self ]."
	aMessageNode isSelfSend
		ifFalse: [ ^ self ].
	(aMessageNode methodNode methodClass canPerform: aMessageNode selector)
		ifFalse: [ ^ self ].
	"(aMessageNode methodNode methodClass lookupSelector: aMessageNode selector) isGTExampleMethod
		ifFalse: [ ^ self ]."
	self
		styleFrom: aMessageNode keywordsIntervals last last
		to: aMessageNode keywordsIntervals last last
		with:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | editorElement method coder |
							method := aMessageNode methodNode methodClass lookupSelector: aMessageNode selector.
							coder := GtMethodCoder forExample: (method methodClass gtExamplesFactory createExample: method).
							coder expanded: true.
							editorElement := coder asElement.
							editorElement border: (BlBorder paint: Color veryLightGray width: 1).
							editorElement margin: (BlInsets top: 3 right: 10 bottom: 10 left: 10) ] ])}
]
