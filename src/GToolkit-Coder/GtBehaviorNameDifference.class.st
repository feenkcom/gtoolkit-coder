Class {
	#name : #GtBehaviorNameDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #converting }
GtBehaviorNameDifference >> asClassRefactoryChange: aClass in: aCompositeRefactoryChange [
	aCompositeRefactoryChange renameClass: aClass to: self newName
]

{ #category : #accessing }
GtBehaviorNameDifference >> newName [
	^ newName
]

{ #category : #accessing }
GtBehaviorNameDifference >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtBehaviorNameDifference >> oldName [
	^ oldName
]

{ #category : #accessing }
GtBehaviorNameDifference >> oldName: anObject [
	oldName := anObject
]

{ #category : #printing }
GtBehaviorNameDifference >> printOn: aStream [
	aStream 
		nextPutAll: 'Behavior name (';
		print: self oldName;
		nextPutAll: ' => ';
		print: self newName;
		nextPutAll: ')'
]
