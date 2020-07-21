Class {
	#name : #GtCoderExpandableMethodStyler,
	#superclass : #GtASTStyler,
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #visiting }
GtCoderExpandableMethodStyler >> visitMessageNode: aMessageNode [
	| aMethodClass type |
	super visitMessageNode: aMessageNode.
	aMethodClass := self
		typeOf: aMessageNode receiver
		in: aMessageNode methodNode methodClass.
	aMethodClass isNil
		ifTrue: [ ^ self ].
	(aMethodClass canUnderstand: aMessageNode selector)
		ifFalse: [ ^ self ].
	self
		styleFrom: aMessageNode keywordsIntervals last last
		to: aMessageNode keywordsIntervals last last
		with:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | editorElement coder |
							(aMethodClass lookupSelector: aMessageNode selector)
								ifNil: [ BlElement new ]
								ifNotNil: [ :method | 
									coder := GtMethodCoder
										forExample: (aMethodClass gtExamplesFactory createExample: method).
									coder subscribeToSystem.
									coder expanded: true.
									coder
										coderLook: [ GtSourceCoderHeaderLook + GtMethodCoderCategoryLook ].
									editorElement := coder asElement.
									editorElement
										border: (BlBorder paint: Color veryLightGray width: 1).
									editorElement
										margin:
											(BlInsets
												top: 3
												right: 10
												bottom: 10
												left: 10) ] ] ])}
]
