Class {
	#name : 'GtSharedVariablesBindings',
	#superclass : 'Object',
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#instVars : [
		'bindings'
	],
	#category : 'GToolkit-VariableBindings-Bindings'
}

{ #category : 'binding' }
GtSharedVariablesBindings >> bindingNames [
	^ bindings keys
]

{ #category : 'binding' }
GtSharedVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ bindings
		at: aSymbol
		ifAbsentPut: [ WorkspaceVariable key: aSymbol ]
]

{ #category : 'testing' }
GtSharedVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ bindings includesKey: aSymbol
]

{ #category : 'initialization' }
GtSharedVariablesBindings >> initialize [
	super initialize.
	
	bindings := Dictionary new
]
