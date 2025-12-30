Extension { #name : #RBPullUpMethodRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBPullUpMethodRefactoring >> gtDescription [
	^ 'Push up method ' , self methodClassName , '>>' , selectors anyOne
]

{ #category : #'*GToolkit-Coder-UI' }
RBPullUpMethodRefactoring >> methodClassName [
	^ class name
]
