Class {
	#name : 'GtCompositeVariablesBindings',
	#superclass : 'Object',
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#instVars : [
		'bindings'
	],
	#category : 'GToolkit-VariableBindings-Bindings'
}

{ #category : 'comparing' }
GtCompositeVariablesBindings >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ bindings = anObject bindings
]

{ #category : 'adding' }
GtCompositeVariablesBindings >> addBindings: aGtVariablesBindings [
	bindings add: aGtVariablesBindings
]

{ #category : 'binding' }
GtCompositeVariablesBindings >> bindingNames [
	^ bindings flatCollect: [ :eachVariableBindings | eachVariableBindings bindingNames ]
]

{ #category : 'binding' }
GtCompositeVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	bindings do: [ :eachVariableBindings |
		(eachVariableBindings bindingOf: aSymbol)
			ifNotNil: [ :aVariable | ^ aVariable ] ].

	^ nil
]

{ #category : 'accessing' }
GtCompositeVariablesBindings >> bindings [

	^ bindings
]

{ #category : 'testing' }
GtCompositeVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ bindings anySatisfy: [ :eachVariableBindings | eachVariableBindings hasBindingOf: aSymbol ]
]

{ #category : 'comparing' }
GtCompositeVariablesBindings >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ bindings hash
]

{ #category : 'initialization' }
GtCompositeVariablesBindings >> initialize [
	super initialize.
	
	bindings := OrderedCollection new
]
