Extension { #name : #RePullUpMethodRefactoring }

{ #category : #'*GToolkit-Coder-UI' }
RePullUpMethodRefactoring >> gtDescription [
	^ 'Push up method ' , self methodClassName , '>>' , selectors anyOne
]

{ #category : #'*GToolkit-Coder-UI' }
RePullUpMethodRefactoring >> methodClassName [
	^ class name
]
