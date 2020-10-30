Class {
	#name : #GtSourceCoderBreadcrumbSpawnPackageAction,
	#superclass : #GtSourceCoderBreadcrumbAction,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnPackageAction >> name [
	<return: #String>

	^ self package name
]

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnPackageAction >> package [
	^ package
]

{ #category : #accessing }
GtSourceCoderBreadcrumbSpawnPackageAction >> package: aPackage [
	self
		assert: [ aPackage notNil ]
		description: [ 'Package must not be nil' ].
	
	package := aPackage
]

{ #category : #action }
GtSourceCoderBreadcrumbSpawnPackageAction >> performSourceCoderActionFrom: anElement [
	anElement phlow spawnTool: (GtPackageCoderTool package: self package)
]

{ #category : #printing }
GtSourceCoderBreadcrumbSpawnPackageAction >> printOn: aStream [
	aStream
		nextPutAll: 'Spawn ';
		nextPutAll: self package name;
		space;
		nextPutAll: 'package'
]
