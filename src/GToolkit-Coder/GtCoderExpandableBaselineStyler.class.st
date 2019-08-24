Class {
	#name : #GtCoderExpandableBaselineStyler,
	#superclass : #GtCoderBodyStyler,
	#instVars : [
		'completionAttributes'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #visiting }
GtCoderExpandableBaselineStyler >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	((#(baseline: #baseline:with:) includes: aMessageNode selector)
		and: [ aMessageNode arguments first isLiteralNode
				and: [ aMessageNode arguments first value isString
						and: [ aMessageNode arguments first value notEmpty ] ] ])
		ifFalse: [ ^ self ].
	self
		styleFrom: aMessageNode arguments first startWithoutParentheses + 1
		to: aMessageNode arguments first stopWithoutParentheses - 1
		with:
			{(GtCompletionStrategyAttribute new
				strategy: GtBaselineCompletionStrategy new)}.
	(Smalltalk globals
		includesKey: ('BaselineOf' , aMessageNode arguments first value) asSymbol)
		ifFalse: [ ^ self ].
	self
		styleFrom: aMessageNode arguments first startWithoutParentheses
		to: aMessageNode arguments first stopWithoutParentheses
		with:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | editorElement method coder |
							method := (Smalltalk globals
								at: ('BaselineOf' , aMessageNode arguments first value) asSymbol)
								>> #baseline:.
							coder := GtMethodCoder forMethod: method.
							coder subscribeToSystem.
							coder expanded: true.
							editorElement := coder asElement.
							editorElement
								border: (BlBorder paint: Color veryLightGray width: 1).
							editorElement
								margin:
									(BlInsets
										top: 3
										right: 10
										bottom: 10
										left: 10) ] ])}
]
