Class {
	#name : #GtReservedVariablesBindings,
	#superclass : #Object,
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#category : #'GToolkit-VariableBindings-Bindings'
}

{ #category : #comparing }
GtReservedVariablesBindings >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
]

{ #category : #binding }
GtReservedVariablesBindings >> bindingNames [
	^ self pseudoVariables keys collect: [ :each | each asSymbol ]
]

{ #category : #binding }
GtReservedVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ self pseudoVariables 
			at: aSymbol
			ifAbsent: [ nil ]
]

{ #category : #testing }
GtReservedVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ self pseudoVariables
			includesKey: aSymbol
]

{ #category : #comparing }
GtReservedVariablesBindings >> hash [
	^ self class hash
]

{ #category : #binding }
GtReservedVariablesBindings >> pseudoVariables [
	^ self
		forPharo12: [ self class environment pseudoVariables ]
		forPharo11AndPharo10: [ self class environment reservedVariables ]
]
