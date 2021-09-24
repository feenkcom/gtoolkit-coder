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

{ #category : 'comparing' }
GtSharedVariablesBindings >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ bindings = anObject bindings
]

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

{ #category : 'accessing' }
GtSharedVariablesBindings >> bindings [

	^ bindings
]

{ #category : 'testing' }
GtSharedVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ bindings includesKey: aSymbol
]

{ #category : 'comparing' }
GtSharedVariablesBindings >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ bindings hash
]

{ #category : 'initialization' }
GtSharedVariablesBindings >> initialize [
	super initialize.
	
	bindings := Dictionary new
]
