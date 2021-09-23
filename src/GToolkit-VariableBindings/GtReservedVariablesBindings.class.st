Class {
	#name : 'GtReservedVariablesBindings',
	#superclass : 'Object',
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#category : 'GToolkit-VariableBindings-Bindings'
}

{ #category : 'binding' }
GtReservedVariablesBindings >> bindingNames [
	^ self class environment reservedVariables
]

{ #category : 'binding' }
GtReservedVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ self class environment reservedVariables
		at: aSymbol
		ifAbsent: [ nil ]
]

{ #category : 'testing' }
GtReservedVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ self class environment reservedVariables includesKey: aSymbol
]
