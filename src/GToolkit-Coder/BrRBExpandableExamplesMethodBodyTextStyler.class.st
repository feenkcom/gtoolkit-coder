Class {
	#name : #BrRBExpandableExamplesMethodBodyTextStyler,
	#superclass : #BrRBHighlightingMethodBodyTextStyler,
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #testing }
BrRBExpandableExamplesMethodBodyTextStyler >> extraStyle: aText ast: ast [
	| selfSendsExamples |
	selfSendsExamples := ast allChildren
		select: [ :each | 
			each isMessage
				and: [ each isSelfSend
						and: [ each isUnary
								and: [ (ast methodNode methodClass canPerform: each selector)
										and: [ (ast methodNode methodClass lookupSelector: each selector) isGTExampleMethod ] ] ] ] ].
	selfSendsExamples
		do: [ :each | 
			self
				addAttributes:
					{(BrTextExpandButtonAttribute new
						attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
								beAppend;
								stencil: [ | editorElement method coder |
									method := ast methodNode methodClass lookupSelector: each selector.
									coder := GtMethodExampleCoder forExample: (method methodClass gtExamplesFactory createExample: method).
									coder expanded: true.
									editorElement := coder asElement.
									editorElement border: (BlBorder paint: Color veryLightGray width: 1).
									editorElement
										margin:
											(BlInsets
												top: 0
												right: 10
												bottom: 10
												left: 10) ] ])}
				from: each stop
				to: each stop ]
]
