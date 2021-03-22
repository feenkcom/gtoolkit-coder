Class {
	#name : #GtPharoSourceCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#instVars : [
		'bindingStrategy',
		'selfObject'
	],
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

{ #category : #accessing }
GtPharoSourceCoderViewModel >> bindingStrategy [
	<return: #GtBindingStrategy>

	^ bindingStrategy
]

{ #category : #accessing }
GtPharoSourceCoderViewModel >> bindingStrategy: aGtBindingStrategy [
	bindingStrategy := aGtBindingStrategy
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

{ #category : #accessing }
GtPharoSourceCoderViewModel >> selfObject [
	"Return an object that should be bound to `self` during code evaluation"

	^ selfObject
]

{ #category : #accessing }
GtPharoSourceCoderViewModel >> selfObject: anObject [
	"Assign an object that should be bound to `self` during code evaluation"

	selfObject := anObject
]
