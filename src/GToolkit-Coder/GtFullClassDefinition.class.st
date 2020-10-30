Class {
	#name : #GtFullClassDefinition,
	#superclass : #GtBehaviorDefinition,
	#instVars : [
		'classSideDefinition',
		'instanceSideDefinition'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtFullClassDefinition class >> fromClass: aClass [
	^ self new fromClass: aClass
]

{ #category : #accessing }
GtFullClassDefinition >> classSideDefinition [
	^ classSideDefinition
]

{ #category : #'api - accepting' }
GtFullClassDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aClass [
	| instRefactorings classRefactorings |
	instRefactorings := (instanceSideDefinition
		difference: aGtCodeDefinitionDifference instanceSideDifference
		toRefactoringsOf: aClass instanceSide) asOrderedCollection.
	classRefactorings := (classSideDefinition
		difference: aGtCodeDefinitionDifference classSideDifference
		toRefactoringsOf: aClass classSide) asOrderedCollection.
	^ instRefactorings , classRefactorings
]

{ #category : #'api - accepting' }
GtFullClassDefinition >> difference: aGtCodeDefinitionDifference toRefactoringsOf: aBehavior in: anRBModel [
	| instRefactorings classRefactorings |
	instRefactorings := (instanceSideDefinition
		difference: aGtCodeDefinitionDifference instanceSideDifference
		toRefactoringsOf: aBehavior instanceSide
		in: anRBModel) asOrderedCollection.
	classRefactorings := (classSideDefinition
		difference: aGtCodeDefinitionDifference classSideDifference
		toRefactoringsOf: aBehavior classSide
		in: anRBModel) asOrderedCollection.
	^ instRefactorings , classRefactorings
]

{ #category : #'api - accepting' }
GtFullClassDefinition >> differenceWith: aGtCodeDefinition [
	^ GtFullClassDefinitionDifference new
		instanceSideDifference:
			(instanceSideDefinition
				differenceWith: aGtCodeDefinition instanceSideDefinition);
		classSideDifference:
			(classSideDefinition
				differenceWith: aGtCodeDefinition classSideDefinition);
		yourself
]

{ #category : #'instance creation' }
GtFullClassDefinition >> fromClass: aClass [
	name := aClass name.
	originalName := aClass name.
	instanceSideDefinition := GtClassDefinition fromClass: aClass instanceSide.
	classSideDefinition := GtMetaclassDefinition fromMetaclass: aClass classSide
]

{ #category : #accessing }
GtFullClassDefinition >> instanceSideDefinition [
	^ instanceSideDefinition
]
