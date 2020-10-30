Class {
	#name : #GtSourceCoderBreadcrumbSpawnClassAction,
	#superclass : #GtSourceCoderBreadcrumbAction,
	#instVars : [
		'classOrMetaClass'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnClassAction >> classOrMetaClass [
	^ classOrMetaClass
]

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnClassAction >> classOrMetaClass: aClass [
	self
		assert: [ aClass notNil ]
		description: [ 'Class must not be nil' ].

	classOrMetaClass := aClass
]

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnClassAction >> name [
	<return: #String>

	^ self classOrMetaClass name
]

{ #category : #action }
GtSourceCoderBreadcrumbSpawnClassAction >> performSourceCoderActionFrom: anElement [
	anElement phlow spawnTool: (GtClassCoderTool observedClass: self classOrMetaClass)
]

{ #category : #printing }
GtSourceCoderBreadcrumbSpawnClassAction >> printOn: aStream [
	aStream
		nextPutAll: 'Spawn ';
		nextPutAll: self classOrMetaClass name;
		space;
		nextPutAll: 'class'
]
