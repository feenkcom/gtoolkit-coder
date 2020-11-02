Class {
	#name : #GtTagDefinitionDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #accessing }
GtTagDefinitionDifference >> newName [
	^ newName
]

{ #category : #accessing }
GtTagDefinitionDifference >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtTagDefinitionDifference >> oldName [
	^ oldName
]

{ #category : #accessing }
GtTagDefinitionDifference >> oldName: anObject [
	oldName := anObject
]

{ #category : #printing }
GtTagDefinitionDifference >> printOn: aStream [
	aStream 
		nextPutAll: 'Tag (';
		print: self oldName;
		nextPutAll: ' => ';
		print: self newName;
		nextPutAll: ')'
]
