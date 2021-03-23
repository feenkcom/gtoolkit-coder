Class {
	#name : #GtPharoSourceCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#instVars : [
		'bindingStrategy',
		'selfObject'
	],
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

{ #category : #'api - coder model' }
GtPharoSourceCoderViewModel >> behavior [
	"Return a class (or trait) in the context of which the coder is opened"

	^ self subclassResponsibility
]

{ #category : #'private - bindings' }
GtPharoSourceCoderViewModel >> bindingStrategy [
	"Private. Return the underlying bindings strategy. Do not modify the object from the outside!"
	<return: #GtBindingStrategy>

	^ bindingStrategy
]

{ #category : #initialization }
GtPharoSourceCoderViewModel >> defaultBindingStrategy [
	^ GtHighlightingBindingStrategy new
]

{ #category : #'private - evaluation' }
GtPharoSourceCoderViewModel >> evaluationContext [
	^ super evaluationContext
		bindingStrategy: self bindingStrategy;
		receiverObject: self selfObject
]

{ #category : #'gt-extension' }
GtPharoSourceCoderViewModel >> gtInfo [
	^ super gtInfo, {
		#bindingStrategy -> self bindingStrategy.
		#selfObject -> self selfObject
	}
]

{ #category : #'api - coder model' }
GtPharoSourceCoderViewModel >> hasDeclaredGlobalNamed: aVariableName [
	^ self class environment includesKey: aVariableName
]

{ #category : #'api - coder model' }
GtPharoSourceCoderViewModel >> hasDeclaredVariableNamed: aVariableName [
	"Return true if a variable with a given name is declared"
	<return: #Boolean>

	^ false
]

{ #category : #initialization }
GtPharoSourceCoderViewModel >> initialize [
	super initialize.

	bindingStrategy := self defaultBindingStrategy
]

{ #category : #'api - coder model' }
GtPharoSourceCoderViewModel >> isDeprecatedGlobalNamed: aVariableName [
	^ self class environment
		at: aVariableName
		ifPresent: [ :anObject | anObject isBehavior and: [ anObject isDeprecated ] ]
		ifAbsent: [ false ]
]

{ #category : #'private - evaluation' }
GtPharoSourceCoderViewModel >> onBindingsReplaced [
	"Is sent when current variable bindings are replaced with new ones"
]

{ #category : #'api - accessing' }
GtPharoSourceCoderViewModel >> selfObject [
	"Return an object that should be bound to `self` during code evaluation"

	^ selfObject
]

{ #category : #'api - accessing' }
GtPharoSourceCoderViewModel >> selfObject: anObject [
	"Assign an object that should be bound to `self` during code evaluation"

	selfObject := anObject
]
