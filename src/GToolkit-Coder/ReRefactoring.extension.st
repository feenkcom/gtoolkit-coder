Extension { #name : #ReRefactoring }

{ #category : #'*GToolkit-Coder' }
ReRefactoring >> gtDangers [
	<return: #Collection of: #GtRefactoringDanger>

	^ self gtPreconditions gtLeafChildren
		reject: #check
		thenCollect: [ :eachCondition | GtRefactoringDanger new
			condition: eachCondition;
			description: (eachCondition errorMacro expandMacrosWith: false) ]
]

{ #category : #'*GToolkit-Coder' }
ReRefactoring >> gtPreconditions [
	^ self preconditions
]

{ #category : #'*GToolkit-Coder' }
ReRefactoring >> gtTransform [
	self transform
]
