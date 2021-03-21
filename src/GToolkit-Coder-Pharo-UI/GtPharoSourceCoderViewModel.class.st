Class {
	#name : #GtPharoSourceCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

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

{ #category : #'api - coder model' }
GtPharoSourceCoderViewModel >> isDeprecatedGlobalNamed: aVariableName [
	^ self class environment
		at: aVariableName
		ifPresent: [ :anObject | anObject isBehavior and: [ anObject isDeprecated ] ]
		ifAbsent: [ false ]
]
