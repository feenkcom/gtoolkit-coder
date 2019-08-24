Class {
	#name : #GtCoderExpandableBaselineStyler,
	#superclass : #GtCoderBodyStyler,
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #visiting }
GtCoderExpandableBaselineStyler >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	((#(baseline: baseline:with:) includes: aMessageNode selector) and: [ 
		aMessageNode arguments first isLiteralNode and: [
			Smalltalk  globals includesKey: ('BaselineOf', aMessageNode arguments first value) asSymbol]]) ifFalse: [ ^ self ].
	self
		styleFrom: aMessageNode arguments first startWithoutParentheses 
		to: aMessageNode arguments first stopWithoutParentheses
		with:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | editorElement method coder |
							method := Smalltalk  globals includesKey: ('BaselineOf', aMessageNode arguments first value) asSymbol>>#baseline:.
							coder := GtMethodCoder forMethod: method.
							coder subscribeToSystem.
							coder expanded: true.
							editorElement := coder asElement.
							editorElement border: (BlBorder paint: Color veryLightGray width: 1).
							editorElement margin: (BlInsets top: 3 right: 10 bottom: 10 left: 10) ] ])}
]
