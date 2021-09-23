Class {
	#name : 'GtGlobalVariablesBindings',
	#superclass : 'Object',
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#category : 'GToolkit-VariableBindings-Bindings'
}

{ #category : 'comparing' }
GtGlobalVariablesBindings >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
]

{ #category : 'binding' }
GtGlobalVariablesBindings >> bindingNames [
	^ self class environment keys
]

{ #category : 'binding' }
GtGlobalVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ self class environment bindingOf: aSymbol
]

{ #category : 'testing' }
GtGlobalVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ self class environment includesKey: aSymbol
]

{ #category : 'comparing' }
GtGlobalVariablesBindings >> hash [
	^ self class hash
]
