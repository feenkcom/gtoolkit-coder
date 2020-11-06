Class {
	#name : #GtSourceCoderBreadcrumbSpawnBehaviorAction,
	#superclass : #GtSourceCoderBreadcrumbAction,
	#instVars : [
		'methodBehavior'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnBehaviorAction >> foreground [
	^ self methodBehavior exists
		ifTrue: [ BrGlamorousColors defaultButtonTextColor ]
		ifFalse: [ BrGlamorousColors linkWithErrorColor ]
]

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnBehaviorAction >> methodBehavior [
	^ methodBehavior
]

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnBehaviorAction >> methodBehavior: anObject [
	methodBehavior := anObject
]

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnBehaviorAction >> name [
	<return: #String>

	^ self methodBehavior
		behaviorNameDo: [ :aName |
			self methodBehavior exists
				ifTrue: [ aName ]
				ifFalse: [ aName, ' (Deleted)' ] ]
		ifAbsent: [ '(Unspecified)' ]
]

{ #category : #action }
GtSourceCoderBreadcrumbSpawnBehaviorAction >> performSourceCoderActionFrom: anElement [

	self methodBehavior realBehaviorDo: [ :aBehavior |
		anElement phlow spawnTool: (GtClassCoderTool observedClass: aBehavior).
		^ self ].

	anElement phlow spawnTool: (GtInspectorTool forObject: self methodBehavior).
]

{ #category : #printing }
GtSourceCoderBreadcrumbSpawnBehaviorAction >> printOn: aStream [
	aStream
		nextPutAll: 'Spawn ';
		nextPutAll: self name;
		space;
		nextPutAll: 'class'
]
