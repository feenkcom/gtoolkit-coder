Class {
	#name : #GtCoderContextVariableStyler,
	#superclass : #GtCoderBodyStyler,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#instVars : [
		'methodCoder',
		'variables',
		'interval'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #accessing }
GtCoderContextVariableStyler >> initializeVariables [
	variables notNil
		ifTrue: [ ^ self ].
	variables := Dictionary new.
	variables at: 'self' put: methodCoder receiver.
	methodCoder instanceVariableNamesAndValuesDo: [ :name :value | variables at: name put: value ].
	methodCoder tempNamesAndValuesDo: [ :name :value | variables at: name put: value ].
	interval := methodCoder session pcRangeForContext: methodCoder context
]

{ #category : #accessing }
GtCoderContextVariableStyler >> methodCoder [
	^ methodCoder
]

{ #category : #accessing }
GtCoderContextVariableStyler >> methodCoder: aMethodCoder [
	methodCoder := aMethodCoder
]

{ #category : #accessing }
GtCoderContextVariableStyler >> style: aText ast: ast [
	aText clearAttributes: [ :each | each isKindOf: GtPlaygroundEvaluatedCodeButtonAttribute ].
	self initializeVariables.
	super style: aText ast: ast
]

{ #category : #visiting }
GtCoderContextVariableStyler >> visitVariableNode: aVariableNode [
	variables
		at: aVariableNode name
		ifPresent: [ :value | 
			self
				styleFrom: aVariableNode start
				to: aVariableNode stop
				with:
					{(GtPlaygroundEvaluatedCodeButtonAttribute new
						beNotOverwritableByStyler;
						result: value;
						paint: (Color fromHexString: #'90CAF9'))} ].
	super visitVariableNode: aVariableNode
]
