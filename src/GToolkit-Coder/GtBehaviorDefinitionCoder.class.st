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

{ #category : #'as yet unclassified' }
GtBehaviorDefinitionCoder class >> forBehavior: aBehavior [
	^ self new forBehavior: aBehavior
]

{ #category : #accessing }
GtBehaviorDefinitionCoder >> behavior [
	^ behavior
]

{ #category : #accessing }
GtBehaviorDefinitionCoder >> definition [
	^ GtBehaviorDefinition fromBehavior: self behavior
]

{ #category : #'api - initialization' }
GtBehaviorDefinitionCoder >> forBehavior: aBehavior [
	behavior := aBehavior.
	definition := nil
]
