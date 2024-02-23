Extension { #name : #RBInlineMethodRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RBInlineMethodRefactoring >> gtDescription [
	^ 'Inline method ' , class name , '>>' , sourceSelector
]
