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

{ #category : #accessing }
GtCoderContextVariableStyler >> style: aText ast: ast [
	aText clearAttributes: [ :each | each isKindOf: self class ].
	self initializeVariables.
	super style: aText ast: ast
]

{ #category : #'as yet unclassified' }
GtCoderContextVariableStyler >> valueForVariableNamed: aVariableName ifPresent: presentBlock [
	^ self 
		valueForVariableNamed: aVariableName 
		ifPresent: presentBlock 
		ifAbsent: [ ^ self ]
]

{ #category : #'as yet unclassified' }
GtCoderContextVariableStyler >> valueForVariableNamed: aVariableName ifPresent: presentBlock ifAbsent: absentBloc [
	^ variables 
		at: aVariableName 
		ifPresent: [ :selector |
			| variableValue |
			variableValue := self methodCoder perform: selector  withEnoughArguments: {aVariableName}.
			presentBlock value: variableValue ]
		ifAbsent: absentBloc
]
