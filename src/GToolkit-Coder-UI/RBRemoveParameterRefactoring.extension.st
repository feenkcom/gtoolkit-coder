Extension { #name : #RBRemoveParameterRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBRemoveParameterRefactoring >> gtDescription [
	^ 'Remove parameter ' , argument , ' from ' , class name , '>>' , oldSelector
]
