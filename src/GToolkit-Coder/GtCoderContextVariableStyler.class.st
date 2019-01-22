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

{ #category : #testing }
GtCoderContextVariableStyler >> hasValueForVariableNamed: aVariableName [
	^ self 
		valueForVariableNamed: aVariableName 
		ifPresent: [ :value | true ] 
		ifAbsent: [ false ]
]

{ #category : #initialization }
GtCoderContextVariableStyler >> initializeVariables [
	variables notNil
		ifTrue: [ ^ self ].
	variables := Dictionary new.
	methodCoder instanceVariableNames do: [ :name | 
		variables at: name put: #instanceVariableValueFor: ].
	methodCoder tempNames do: [ :name | 
		variables at: name put: #tempNameValueFor: ].
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

{ #category : #styling }
GtCoderContextVariableStyler >> style: aText ast: ast [
	aText clearAttributes: [ :each | each isKindOf: GtPlaygroundEvaluatedCodeButtonAttribute ].
	self initializeVariables.
	super style: aText ast: ast
]

{ #category : #styling }
GtCoderContextVariableStyler >> styleVariableNode: aVariableNode [
	self subclassResponsibility
]

{ #category : #accessing }
GtCoderContextVariableStyler >> valueForVariableNamed: aVariableName ifPresent: presentBlock [
	^ self 
		valueForVariableNamed: aVariableName 
		ifPresent: presentBlock 
		ifAbsent: [ ^ self ]
]

{ #category : #accessing }
GtCoderContextVariableStyler >> valueForVariableNamed: aVariableName ifPresent: presentBlock ifAbsent: absentBloc [
	^ variables 
		at: aVariableName 
		ifPresent: [ :selector |
			| variableValue |
			variableValue := self methodCoder perform: selector  withEnoughArguments: {aVariableName}.
			presentBlock value: variableValue ]
		ifAbsent: absentBloc
]

{ #category : #visiting }
GtCoderContextVariableStyler >> visitArgumentNode: anArgumentNode [
	self styleVariableNode: anArgumentNode
]

{ #category : #visiting }
GtCoderContextVariableStyler >> visitInstanceVariableNode: aSelfNode [
	self styleVariableNode: aSelfNode
]

{ #category : #visiting }
GtCoderContextVariableStyler >> visitTemporaryNode: aNode [ 
	self styleVariableNode: aNode
]
