Class {
	#name : #GtCoderExpandableBaselineStyler,
	#superclass : #GtCoderBodyStyler,
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #visiting }
GtCoderExpandableBaselineStyler >> visitMessageNode: aMessageNode [
	| aMethodClass |
	super visitMessageNode: aMessageNode.
	(#(baseline: baseline:with:) includes: aMessageNode selector) ifFalse: [ ^ self ].
	self
		styleFrom: aMessageNode arguments first startWithoutParentheses 
		to: aMessageNode arguments first stopWithoutParentheses
		with:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | editorElement method coder |
							method := aMessageNode arguments first inspect lookupSelector: aMessageNode selector.
							coder := GtMethodCoder forExample: (aMethodClass gtExamplesFactory createExample: method).
							coder subscribeToSystem.
							coder expanded: true.
							editorElement := coder asElement.
							editorElement border: (BlBorder paint: Color veryLightGray width: 1).
							editorElement margin: (BlInsets top: 3 right: 10 bottom: 10 left: 10) ] ])}
]
