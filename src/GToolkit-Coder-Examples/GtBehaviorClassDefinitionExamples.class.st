Class {
	#name : #GtBehaviorClassDefinitionExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Behavior'
}

{ #category : #'instance creation' }
GtBehaviorClassDefinitionExamples >> fromClass [
	<gtExample>
	| aDefinition |

	aDefinition := GtClassDefinition fromClass: GtBehaviorCoderDummyClass.

	self assert: aDefinition name equals: #GtBehaviorCoderDummyClass.
	self assert: aDefinition hasParent not.

	self assert: aDefinition traits parent == aDefinition.
	self assert: aDefinition traits size equals: 1.
	self assert: (aDefinition traits at: 1) name equals: #TGtBehaviorCoderDummyTrait.
	self assert: (aDefinition traits at: 1) parent == aDefinition.
	
	self assert: aDefinition slots parent == aDefinition.
	self assert: aDefinition slots size equals: 4.
	
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
