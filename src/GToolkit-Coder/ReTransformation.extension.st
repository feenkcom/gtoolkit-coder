Extension { #name : #ReTransformation }

{ #category : #'*GToolkit-Coder' }
ReTransformation >> gtDangers [
	<return: #Collection of: #GtRefactoringDanger>

	^ self gtPreconditions gtLeafChildren
		reject: #check
		thenCollect: [ :eachCondition | GtRefactoringDanger new
			condition: eachCondition;
			description: (eachCondition errorMacro expandMacrosWith: false) ]
]

{ #category : #'*GToolkit-Coder' }
ReTransformation >> gtPreconditions [
	^ self preconditions
]

{ #category : #'*GToolkit-Coder' }
ReTransformation >> gtTransform [
	self privateTransform
]
