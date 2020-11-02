Extension { #name : #RBTransformation }

{ #category : #'*GToolkit-Coder' }
RBTransformation >> gtDangers [
	<return: #Collection of: #GtRefactoringDanger>

	^ self gtPreconditions gtLeafChildren
		reject: #check
		thenCollect: [ :eachCondition | GtRefactoringDanger new
			condition: eachCondition;
			description: (eachCondition errorMacro expandMacrosWith: false) ]
]

{ #category : #'*GToolkit-Coder' }
RBTransformation >> gtPreconditions [
	^ self preconditions
]

{ #category : #'*GToolkit-Coder' }
RBTransformation >> gtTransform [
	self privateTransform
]
