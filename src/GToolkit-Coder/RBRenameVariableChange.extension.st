Extension { #name : #RBRenameVariableChange }

{ #category : #'*GToolkit-Coder' }
RBRenameVariableChange >> gtWhatToDisplay [
	^ self changes flatCollect: [ :eachChange | eachChange changes ]
]
