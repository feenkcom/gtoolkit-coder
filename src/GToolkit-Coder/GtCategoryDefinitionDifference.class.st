Class {
	#name : #GtCategoryDefinitionDifference,
	#superclass : #GtCodeDefinitionDifference,
	#instVars : [
		'packageDifference',
		'tagDifference'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #initialization }
GtCategoryDefinitionDifference >> initialize [
	super initialize.
	
	packageDifference := GtNoDefinitionDifference new.
	tagDifference := GtNoDefinitionDifference new
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
