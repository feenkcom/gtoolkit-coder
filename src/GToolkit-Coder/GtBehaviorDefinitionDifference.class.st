Class {
	#name : #GtBehaviorDefinitionDifference,
	#superclass : #GtCompositeDefinitionDifference,
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'api - behavior difference' }
GtBehaviorDefinitionDifference >> nameFrom: anOldName to: aNewName [
	self add: (GtBehaviorNameDifference new oldName: anOldName; newName: aNewName)
]
