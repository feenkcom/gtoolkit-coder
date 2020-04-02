Extension { #name : #RBCompositeRefactoryChange }

{ #category : #'*GToolkit-Coder' }
RBCompositeRefactoryChange >> gtWhatToDisplay [
	^ self changes flatCollect: [ :eachChange | eachChange gtWhatToDisplay ]
]
