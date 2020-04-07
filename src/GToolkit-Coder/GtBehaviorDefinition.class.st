Class {
	#name : #GtBehaviorDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'ringDefinition',
		'originalName'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtBehaviorDefinition class >> fromBehavior: aBehavior [
	^ aBehavior isClass
		ifTrue: [ aBehavior isMeta
			ifTrue: [ GtMetaclassDefinition fromMetaclass: aBehavior ]
			ifFalse: [ GtClassDefinition fromClass: aBehavior ] ]
		ifFalse: [ aBehavior isTrait
			ifTrue: [ GtTraitDefinition fromTrait: aBehavior ]
			ifFalse: [ self error: 'Uknown entity' ] ]
]

{ #category : #'api - accepting' }
GtBehaviorDefinition >> difference: aGtCodeDefinitionDiffrence toRefactoringsOf: aBehavior [
	^ self subclassResponsibility
]

{ #category : #'api - accepting' }
GtBehaviorDefinition >> difference: aGtCodeDefinitionDiffrence toRefactoringsOf: aBehavior in: anRBModel [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtBehaviorDefinition >> name [
	<return: #Symbol>

	^ ringDefinition name
]

{ #category : #accessing }
GtBehaviorDefinition >> name: aSymbol [
	ringDefinition name: aSymbol asSymbol
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
