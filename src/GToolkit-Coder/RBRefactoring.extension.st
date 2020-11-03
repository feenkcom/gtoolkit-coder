Extension { #name : #RBRefactoring }

{ #category : #'*GToolkit-Coder' }
RBRefactoring >> gtDangers [
	<return: #Collection of: #GtRefactoringDanger>

	^ self gtPreconditions gtLeafChildren
		reject: #check
		thenCollect: [ :eachCondition | GtRefactoringDanger new
			condition: eachCondition;
			description: (eachCondition errorMacro expandMacrosWith: false) ]
]

{ #category : #'*GToolkit-Coder' }
RBRefactoring >> gtExecute: isForce [
	isForce
		ifTrue: [ self transform ]
		ifFalse: [ self primitiveExecute ].
	RBRefactoryChangeManager instance performChange: self changes; addUndoPointer: 1
]

{ #category : #'*GToolkit-Coder' }
RBRefactoring >> gtPreconditions [
	^ self preconditions
]

{ #category : #'*GToolkit-Coder' }
RBRefactoring >> gtTransform [
	self transform
]
