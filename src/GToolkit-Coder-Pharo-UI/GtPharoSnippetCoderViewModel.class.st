Class {
	#name : #GtPharoSnippetCoderViewModel,
	#superclass : #GtPharoSourceCoderViewModel,
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

{ #category : #'api - coder model' }
GtPharoSnippetCoderViewModel >> behavior [
	^ self selfObject class
]

{ #category : #initialization }
GtPharoSnippetCoderViewModel >> defaultBindingStrategy [
	| defaultBindings |
	
	defaultBindings := GtLocalSnippetBindings new.
	defaultBindings sharedBindings: GtSnippetBindings new.

	^ GtSnippetBindingStrategy new bindings: defaultBindings
]

{ #category : #'api - coder model' }
GtPharoSnippetCoderViewModel >> hasDeclaredVariableNamed: aVariableName [
	"Return true if a variable with a given name is declared"
	<return: #Boolean>

	(super hasDeclaredVariableNamed: aVariableName)
		ifTrue: [ ^ true ].

	"in case of the workspace we ignore non-capitalized variables as they are temporary variables
	and are always declared"
	aVariableName first isUppercase not
		ifTrue: [ ^ true ].

	^ false
]

{ #category : #'api - coder model' }
GtPharoSnippetCoderViewModel >> onCoderModelChanged [
	super onCoderModelChanged.

	self bindingStrategy bindings
		localAt: #thisCoderViewModel
		put: self.
		
	self bindingStrategy bindings
		localAt: #thisCoder
		put: self coderModel
]

{ #category : #'api - bindings' }
GtPharoSnippetCoderViewModel >> sharedBindings [
	^ self bindingStrategy bindings sharedBindings
]

{ #category : #'api - bindings' }
GtPharoSnippetCoderViewModel >> sharedBindings: aGtSnippetBindings [
	self bindingStrategy bindings sharedBindings: aGtSnippetBindings
]
