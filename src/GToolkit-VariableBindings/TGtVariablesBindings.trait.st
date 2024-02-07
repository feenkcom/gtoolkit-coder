Trait {
	#name : #TGtVariablesBindings,
	#category : #'GToolkit-VariableBindings-Bindings'
}

{ #category : #converting }
TGtVariablesBindings >> asDictionary [
	| aDictionary |
	
	aDictionary := Dictionary new.
	self bindingNames do: [ :eachBindingName |
		aDictionary at: eachBindingName put: (self bindingOf: eachBindingName) ].

	^ aDictionary
]

{ #category : #binding }
TGtVariablesBindings >> bindingNames [
	^ self explicitRequirement
]

{ #category : #binding }
TGtVariablesBindings >> bindingOf: aSymbol [
	"aSymbol is a variable name.
	Return a literal variable if the variable has a value assigned.
	Return nil, if the variable has no value assigned."
	<return: #Variable or: nil>

	^ self explicitRequirement
]

{ #category : #binding }
TGtVariablesBindings >> bindingValueOf: aSymbol [
	"aSymbol is a variable name.
	Return a value of the variable."

	^ (self bindingOf: aSymbol) ifNotNil: [ :aBinding | aBinding value ]
]

{ #category : #binding }
TGtVariablesBindings >> bindingValueOf: aSymbol ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	"aSymbol is a variable name.
	Return a value of variable name"

	(self hasBindingOf: aSymbol)
		ifTrue: [ aPresentBlock cull: (self bindingValueOf: aSymbol) ]
		ifFalse: [ anAbsentBlock value ]
]

{ #category : #testing }
TGtVariablesBindings >> hasBindingOf: aSymbol [
	<return: #Boolean>

	^ self explicitRequirement
]
