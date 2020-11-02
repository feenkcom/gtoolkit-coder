Class {
	#name : #GtBehaviorDefinitionDifference,
	#superclass : #GtCompositeDefinitionDifference,
	#category : #'GToolkit-Coder-Metamodels-Behavior - Differences'
}

{ #category : #'api - behavior difference' }
GtBehaviorDefinitionDifference >> nameFrom: anOldName to: aNewName [
	self add: (GtBehaviorNameDifference new oldName: anOldName; newName: aNewName)
]
