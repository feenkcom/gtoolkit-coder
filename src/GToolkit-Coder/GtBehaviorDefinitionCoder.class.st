Class {
	#name : #GtBehaviorDefinitionCoder,
	#superclass : #GtCoderModel,
	#traits : 'TGtCoderTrait',
	#classTraits : 'TGtCoderTrait classTrait',
	#instVars : [
		'behavior',
		'definition'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtBehaviorDefinitionCoder class >> forBehavior: aBehavior [
	^ self new forBehavior: aBehavior
]

{ #category : #accessing }
GtBehaviorDefinitionCoder >> behavior [
	<return: #Behavior>

	^ behavior
]

{ #category : #accessing }
GtBehaviorDefinitionCoder >> definition [
	^ definition ifNil: [ definition := self definitionFrom: self behavior ]
]

{ #category : #'api - initialization' }
GtBehaviorDefinitionCoder >> definitionFrom: aBehavior [
	^ GtBehaviorDefinition fromBehavior: aBehavior
]

{ #category : #accessing }
GtBehaviorDefinitionCoder >> difference [
	<return: #GtCodeDefinitionDifference>
	
	^ self definition differenceWith: (self definitionFrom: self behavior)
]

{ #category : #'api - initialization' }
GtBehaviorDefinitionCoder >> forBehavior: aBehavior [
	behavior := aBehavior.
	definition := nil
]

{ #category : #accessing }
GtBehaviorDefinitionCoder >> refactorings [	
	^  self definition difference: self difference toRefactoringsOf: self behavior
]
