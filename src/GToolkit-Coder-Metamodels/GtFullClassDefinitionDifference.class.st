Class {
	#name : #GtFullClassDefinitionDifference,
	#superclass : #GtBehaviorDefinitionDifference,
	#instVars : [
		'classSideDifference',
		'instanceSideDifference'
	],
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #accessing }
GtFullClassDefinitionDifference >> classSideDifference [
	^ classSideDifference
]

{ #category : #accessing }
GtFullClassDefinitionDifference >> classSideDifference: aMetaclassDefinitionDifference [
	classSideDifference := aMetaclassDefinitionDifference.
	self add: classSideDifference
]

{ #category : #accessing }
GtFullClassDefinitionDifference >> instanceSideDifference [
	^ instanceSideDifference
]

{ #category : #accessing }
GtFullClassDefinitionDifference >> instanceSideDifference: aClassDefinitionDifference [
	instanceSideDifference := aClassDefinitionDifference.
	self add: aClassDefinitionDifference
]
