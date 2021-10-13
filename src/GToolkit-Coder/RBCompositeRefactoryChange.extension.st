Extension { #name : #RBCompositeRefactoryChange }

{ #category : #'*GToolkit-Coder' }
RBCompositeRefactoryChange >> gtWithoutChanges [
	^ self shallowCopy
		changes: #();
		yourself
]
