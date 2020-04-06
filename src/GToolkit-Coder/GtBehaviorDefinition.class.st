Class {
	#name : #GtBehaviorDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'ringDefinition',
		'originalName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtBehaviorDefinition class >> fromBehavior: aBehavior [
	^ aBehavior isClass
		ifTrue: [ aBehavior isMeta
			ifTrue: [ GtMetaclassDefinition new ]
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
