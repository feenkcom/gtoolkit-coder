Extension { #name : #RBPushDownMethodRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBPushDownMethodRefactoring >> gtDescription [
	^ 'Push down method ' , self superclassName , '>>' , selectors anyOne
]

{ #category : #'*GToolkit-Coder-UI' }
RBPushDownMethodRefactoring >> superclassName [
	^ class name
]
