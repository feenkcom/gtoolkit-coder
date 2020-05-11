Class {
	#name : #GtCoderExpandableMethodStyler,
	#superclass : #GtASTStyler,
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #visiting }
GtCoderExpandableMethodStyler >> visitMessageNode: aMessageNode [
	| aMethodClass |
	super visitMessageNode: aMessageNode.
	(aMessageNode isSelfSend or: [ aMessageNode isSuperSend ])
		ifFalse: [ ^ self ].
	aMethodClass := aMessageNode isSuperSend
			ifTrue: [ aMessageNode methodNode methodClass superclass ]
			ifFalse: [ aMessageNode methodNode methodClass ].
	(aMethodClass canUnderstand: aMessageNode selector)
		ifFalse: [ ^ self ].
	self
		styleFrom: aMessageNode keywordsIntervals last last
		to: aMessageNode keywordsIntervals last last
		with:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | editorElement method coder |
							method := aMethodClass lookupSelector: aMessageNode selector.
							coder := GtMethodCoder forExample: (aMethodClass gtExamplesFactory createExample: method).
							coder subscribeToSystem.
							coder expanded: true.
							editorElement := coder asElement.
							editorElement border: (BlBorder paint: Color veryLightGray width: 1).
							editorElement margin: (BlInsets top: 3 right: 10 bottom: 10 left: 10) ] ])}
]
