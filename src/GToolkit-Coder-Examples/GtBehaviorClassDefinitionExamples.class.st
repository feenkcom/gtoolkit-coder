Class {
	#name : #GtBehaviorClassDefinitionExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Behavior'
}

{ #category : #'examples - validation' }
GtBehaviorClassDefinitionExamples >> definitionWithEmptyNameIsInvalid [
	<gtExample>
	| definition |
	definition := self fromClass.
	definition name: ''.
	
	self assert: definition name equals: ''.
	self assert: definition isValidForCreation not.
]

{ #category : #'examples - validation' }
GtBehaviorClassDefinitionExamples >> definitionWithSameNameIsInvalid [
	<gtExample>
	| definition |
	definition := self fromClass.
	
	self assert: definition name equals: self targetClass name.
	self assert: definition isValidForCreation not.
]

{ #category : #'instance creation' }
GtBehaviorClassDefinitionExamples >> fromClass [
	<gtExample>
	| aDefinition |

	aDefinition := GtClassDefinition fromClass: self targetClass.

	self assert: aDefinition name equals: #GtBehaviorCoderDummyClass.
	self assert: aDefinition hasParent not.

	self assert: aDefinition traits parent == aDefinition.
	self assert: aDefinition traits size equals: 1.
	self assert: (aDefinition traits at: 1) name equals: #TGtBehaviorCoderDummyTrait.
	self assert: (aDefinition traits at: 1) parent == aDefinition.
	
	self assert: aDefinition slots parent == aDefinition.
	self assert: aDefinition slots size equals: 3.
	
	self assert: (aDefinition slots at: 1) name equals: #instVarA.
	self assert: (aDefinition slots at: 1) type equals: #InstanceVariableSlot.
	self assert: (aDefinition slots at: 1) parent == aDefinition.
	
	self assert: (aDefinition slots at: 2) name equals: #instVarB.
	self assert: (aDefinition slots at: 2) type equals: #InstanceVariableSlot.
	self assert: (aDefinition slots at: 2) parent == aDefinition.
	
	self assert: (aDefinition slots at: 3) name equals: #instVarC.
	self assert: (aDefinition slots at: 3) type equals: #InstanceVariableSlot.
	self assert: (aDefinition slots at: 3) parent == aDefinition.

	^ aDefinition
]

{ #category : #access }
GtBehaviorClassDefinitionExamples >> targetClass [
	^ GtBehaviorCoderDummyClass
]
