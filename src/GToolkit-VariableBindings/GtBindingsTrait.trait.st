Trait {
	#name : #GtBindingsTrait,
	#category : #'GToolkit-VariableBindings-Core'
}

{ #category : #converting }
GtBindingsTrait >> allNames [ 
	^ self asDictionary keys
]

{ #category : #converting }
GtBindingsTrait >> asDictionary [
	<return: #Dictionary>
	^ self explicitRequirement
]

{ #category : #adding }
GtBindingsTrait >> at: aSymbol put: anObject [ 
	"Set bindings for a variable named aSymbol and value anObject."
	self explicitRequirement
]

{ #category : #accessing }
GtBindingsTrait >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #LiteralVariable or: nil>
	^ self explicitRequirement
]

{ #category : #testing }
GtBindingsTrait >> hasBindingOf: aSymbol [
	<return: #Boolean>
	^ self explicitRequirement
]
