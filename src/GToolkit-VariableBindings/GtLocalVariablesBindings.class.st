Class {
	#name : #GtLocalVariablesBindings,
	#superclass : #Object,
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#instVars : [
		'bindings'
	],
	#category : 'GToolkit-VariableBindings-Bindings'
}

{ #category : #comparing }
GtLocalVariablesBindings >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ bindings = anObject bindings
]

{ #category : #binding }
GtLocalVariablesBindings >> bindingNames [
	^ bindings keys
]

{ #category : #binding }
GtLocalVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ bindings
		at: aSymbol
		ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLocalVariablesBindings >> bindings [

	^ bindings
]

{ #category : #testing }
GtLocalVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ bindings includesKey: aSymbol
]

{ #category : #comparing }
GtLocalVariablesBindings >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ bindings hash
]

{ #category : #initialization }
GtLocalVariablesBindings >> initialize [
	super initialize.
	
	bindings := Dictionary new
]

{ #category : #accessing }
GtLocalVariablesBindings >> localAt: aSymbol put: anObject [ 
	self
		assert: [ aSymbol isSymbol ]
		description: [ 'Variable name should be a symbol' ].
	
	bindings 
		at: aSymbol 
		put: (WorkspaceVariable key: aSymbol value: anObject)
]
