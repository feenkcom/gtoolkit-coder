Trait {
	#name : 'TGtVariablesBindings',
	#category : 'GToolkit-VariableBindings-Bindings'
}

{ #category : 'converting' }
TGtVariablesBindings >> asDictionary [
	| aDictionary |
	
	aDictionary := Dictionary new.
	self bindingNames do: [ :eachBindingName |
		aDictionary at: eachBindingName put: (self bindingOf: eachBindingName) ].

	^ aDictionary
]

{ #category : 'binding' }
TGtVariablesBindings >> bindingNames [
	^ self explicitRequirement
]

{ #category : 'binding' }
TGtVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ self explicitRequirement
]

{ #category : 'testing' }
TGtVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ self explicitRequirement
]
