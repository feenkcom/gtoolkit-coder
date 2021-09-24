Class {
	#name : 'GtEmptyVariablesBindings',
	#superclass : 'Object',
	#traits : 'TGtVariablesBindings',
	#classTraits : 'TGtVariablesBindings classTrait',
	#category : 'GToolkit-VariableBindings-Bindings'
}

{ #category : 'comparing' }
GtEmptyVariablesBindings >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
]

{ #category : 'binding' }
GtEmptyVariablesBindings >> bindingNames [
	^ #()
]

{ #category : 'binding' }
GtEmptyVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ nil
]

{ #category : 'testing' }
GtEmptyVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ false
]

{ #category : 'comparing' }
GtEmptyVariablesBindings >> hash [
	^ self class hash
]
