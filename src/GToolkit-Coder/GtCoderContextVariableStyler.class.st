Class {
	#name : #GtCoderContextVariableStyler,
	#superclass : #GtRBASTStyler,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#instVars : [
		'methodCoder',
		'variables',
		'interval'
	],
	#category : 'GToolkit-Coder-Styler/Highlighter'
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
	methodCoder instanceVariableNodesDo: [ :aVariableNode | 
		variables at: aVariableNode key put: aVariableNode ].
	methodCoder temporaryVariableNodesDo: [ :aVariableNode | 
		variables at: aVariableNode key put: aVariableNode ].
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
		ifPresent: [ :variableNode |
			presentBlock value: variableNode value ]
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
