Class {
	#name : 'GtContextVariablesBindings',
	#superclass : 'Object',
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#instVars : [
		'context'
	],
	#category : 'GToolkit-VariableBindings-Bindings'
}

{ #category : 'comparing' }
GtContextVariablesBindings >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ context = anObject context
]

{ #category : 'binding' }
GtContextVariablesBindings >> bindingNames [
	^ context tempNames
]

{ #category : 'binding' }
GtContextVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>
	| var |
	var := context lookupVar: aSymbol.
	var
		ifNil: [ ^ nil ].
	var isLocalVariable
		ifFalse: [ ^ nil ].
	^ var
]

{ #category : 'accessing' }
GtContextVariablesBindings >> context [

	^ context
]

{ #category : 'accessing' }
GtContextVariablesBindings >> context: anObject [

	context := anObject
]

{ #category : 'testing' }
GtContextVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ (self bindingOf: aSymbol) notNil
]

{ #category : 'comparing' }
GtContextVariablesBindings >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ context hash
]
