Class {
	#name : #GtPackageDefinitionDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Differences'
}

{ #category : #accessing }
GtPackageDefinitionDifference >> newName [
	^ newName
]

{ #category : #accessing }
GtPackageDefinitionDifference >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtPackageDefinitionDifference >> oldName [
	^ oldName
]

{ #category : #accessing }
GtPackageDefinitionDifference >> oldName: anObject [
	oldName := anObject
]

{ #category : #printing }
GtPackageDefinitionDifference >> printOn: aStream [
	aStream 
		nextPutAll: 'Package (';
		print: self oldName;
		nextPutAll: ' => ';
		print: self newName;
		nextPutAll: ')'
]
