Class {
	#name : #GtBehaviorDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'name',
		'originalName'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtBehaviorDefinition class >> fromBehavior: aBehavior [
	"Create a definition for editing the given behaviour."
	^ aBehavior isClass
		ifTrue: [ aBehavior isMeta
			ifTrue: [ GtMetaclassDefinition fromMetaclass: aBehavior ]
			ifFalse: [ GtFullClassDefinition fromClass: aBehavior ] ]
		ifFalse: [ aBehavior isTrait
			ifTrue: [ GtTraitDefinition fromTrait: aBehavior ]
			ifFalse: [ self error: 'Unknown entity' ] ]
]

{ #category : #'instance creation' }
GtBehaviorDefinition class >> targetDefinitionForBehavior: aBehavior [
	"Create a definition for exactly the type of the give behaviour. 
	I differ from ${method:GtBehaviorDefinition class>>#fromBehaviour:}$ 
	in how I handle definitions for classes and metaclasses "
	^ aBehavior isClass
		ifTrue: [ aBehavior isMeta
			ifTrue: [ GtMetaclassDefinition fromMetaclass: aBehavior ]
			ifFalse: [ GtClassDefinition fromClass: aBehavior ] ]
		ifFalse: [ aBehavior isTrait
			ifTrue: [ GtTraitDefinition fromTrait: aBehavior ]
			ifFalse: [ self error: 'Unknown entity' ] ]
]

{ #category : #accessing }
GtBehaviorDefinition >> classOrMetaClass [
	^ self class environment at: self originalName ifAbsent: [  ]
]

{ #category : #'api - accepting' }
GtBehaviorDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aBehavior [
	^ self subclassResponsibility
]

{ #category : #'api - accepting' }
GtBehaviorDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aBehavior in: anRBModel [
	^ self subclassResponsibility
]

{ #category : #testing }
GtBehaviorDefinition >> isForMetaclass [
	^ false
]

{ #category : #accessing }
GtBehaviorDefinition >> name [
	<return: #Symbol>

	^ name
]

{ #category : #accessing }
GtBehaviorDefinition >> name: aSymbol [
	| anOldName |
	
	anOldName := name.
	name := aSymbol asSymbol.

	name = anOldName
		ifTrue: [ ^ self ].

	self
		notifyBehaviorRenamed: self
		from: anOldName
		to: name
]

{ #category : #'private - notifying' }
GtBehaviorDefinition >> notifyBehaviorRenamed: aBehaviorDefinition from: anOldName to: aNewName [
	self dispatchEvent: (GtBehaviorRenamed new
		behavior: aBehaviorDefinition;
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #accessing }
GtBehaviorDefinition >> originalName [
	^ originalName
]

{ #category : #accessing }
GtBehaviorDefinition >> originalName: anObject [
	originalName := anObject
]

{ #category : #printing }
GtBehaviorDefinition >> printOn: aStream [
	aStream print: self name
]
