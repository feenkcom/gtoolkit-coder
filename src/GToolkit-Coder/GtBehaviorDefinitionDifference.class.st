Class {
	#name : #GtBehaviorDefinitionDifference,
	#superclass : #GtCompositeDefinitionDifference,
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'api - refactoring' }
GtBehaviorDefinitionDifference >> applyOn: aBehavior [
]

{ #category : #'api - behavior difference' }
GtBehaviorDefinitionDifference >> nameFrom: anOldName to: aNewName [
	self add: (GtClassNameDifference new oldName: anOldName; newName: aNewName)
]

{ #category : #'api - refactoring' }
GtBehaviorDefinitionDifference >> refactorOn: aBehavior [
]
