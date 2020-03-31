Class {
	#name : #GtClassNameDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #accessing }
GtClassNameDifference >> newName [
	^ newName
]

{ #category : #accessing }
GtClassNameDifference >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtClassNameDifference >> oldName [
	^ oldName
]

{ #category : #accessing }
GtClassNameDifference >> oldName: anObject [
	oldName := anObject
]

{ #category : #printing }
GtClassNameDifference >> printOn: aStream [
	aStream 
		nextPutAll: 'Class name (';
		print: self oldName;
		nextPutAll: ' => ';
		print: self newName;
		nextPutAll: ')'
]
