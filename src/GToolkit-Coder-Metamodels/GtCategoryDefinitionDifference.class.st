Class {
	#name : #GtCategoryDefinitionDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'packageDifference',
		'tagDifference',
		'oldCategory',
		'newCategory'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #converting }
GtCategoryDefinitionDifference >> asClassRefactorings: aClass in: anRBModel [
	^ RBMoveClassToPackageRefactoring
		model: anRBModel
		move: aClass name
		to: self newCategory
]

{ #category : #testing }
GtCategoryDefinitionDifference >> hasDifference [
	^ packageDifference hasDifference or: [ tagDifference hasDifference ]
]

{ #category : #initialization }
GtCategoryDefinitionDifference >> initialize [
	super initialize.
	
	packageDifference := GtNoDefinitionDifference new.
	tagDifference := GtNoDefinitionDifference new
]

{ #category : #accessing }
GtCategoryDefinitionDifference >> newCategory [
	^ newCategory
]

{ #category : #accessing }
GtCategoryDefinitionDifference >> newCategory: anObject [
	newCategory := anObject
]

{ #category : #accessing }
GtCategoryDefinitionDifference >> oldCategory [
	^ oldCategory
]

{ #category : #accessing }
GtCategoryDefinitionDifference >> oldCategory: anObject [
	oldCategory := anObject
]

{ #category : #accessing }
GtCategoryDefinitionDifference >> packageDifference [
	^ packageDifference
]

{ #category : #accessing }
GtCategoryDefinitionDifference >> packageDifference: anObject [
	packageDifference := anObject
]

{ #category : #printing }
GtCategoryDefinitionDifference >> printOn: aStream [
	aStream nextPutAll: 'Category'
]

{ #category : #accessing }
GtCategoryDefinitionDifference >> tagDifference [
	^ tagDifference
]

{ #category : #accessing }
GtCategoryDefinitionDifference >> tagDifference: anObject [
	tagDifference := anObject
]
