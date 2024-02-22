Extension { #name : #RBPullUpMethodRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBPullUpMethodRefactoring >> gtDescription [
	^ 'Pull up method ' , class name , '>>' , selectors anyOne
]
