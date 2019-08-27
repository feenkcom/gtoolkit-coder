Class {
	#name : #GtCoderExpandableBaselineStyler,
	#superclass : #GtCoderBodyStyler,
	#instVars : [
		'completionAttributes'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #private }
GtCoderExpandableBaselineStyler >> isNonEmptyLiteralStringNode: nameNode [
	^ nameNode isLiteralNode
		and: [ nameNode value isString and: [ nameNode value notEmpty ] ]
]

{ #category : #private }
GtCoderExpandableBaselineStyler >> styleBaselineMessage: aMessageNode [
	| stringNode |
	stringNode := aMessageNode arguments first.
	(self isNonEmptyLiteralStringNode: stringNode)
		ifFalse: [ ^ self ].
	self
		styleFrom: stringNode startWithoutParentheses + 1
		to: stringNode stopWithoutParentheses - 1
		with:
			{(GtCompletionStrategyAttribute new
				strategy: GtBaselineOfClassCompletionStrategy new)}.
	(Smalltalk globals
		includesKey: ('BaselineOf' , stringNode value) asSymbol)
		ifFalse: [ ^ self ].
	self
		styleFrom: stringNode startWithoutParentheses
		to: stringNode stopWithoutParentheses
		with:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | editorElement method coder |
							method := (Smalltalk globals
								at: ('BaselineOf' , stringNode value) asSymbol) >> #baseline:.
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

{ #category : #private }
GtCoderExpandableBaselineStyler >> stylePackageMessage: aMessageNode [
	| nameNode |
	nameNode := aMessageNode arguments first.
	(self isNonEmptyLiteralStringNode: nameNode)
		ifFalse: [ ^ self ].
	self
		styleFrom: nameNode startWithoutParentheses + 1
		to: nameNode stopWithoutParentheses - 1
		with:
			{(GtCompletionStrategyAttribute new
				strategy: GtBaselinePackageCompletionStrategy new)}
]

{ #category : #visiting }
GtCoderExpandableBaselineStyler >> visitMessageNode: aMessageNode [
	super visitMessageNode: aMessageNode.
	(#(baseline: #baseline:with:) includes: aMessageNode selector)
		ifTrue: [ self styleBaselineMessage: aMessageNode ].
	(#(package: #package:with:) includes: aMessageNode selector)
		ifTrue: [ self stylePackageMessage: aMessageNode ]
]
