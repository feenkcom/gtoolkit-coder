Extension { #name : #GtSourceCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> addRefactoringChangesPreview: aRefactoring at: position whenComplete: aBlock [
	self removeRefactoringAttribute.
	aRefactoring isNil
		ifTrue: [ ^ self ].
	(self sourceText from: position to: position)
		attributes:
			{(GtRefactoringChangesAttribute new
				refactoring: aRefactoring;
				completionAction: aBlock)}
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> breadcrumbActions [
	<return: #Array of: #GtSourceCoderBreadcrumbAction>

	^ #()
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> browseClassFrom: anEditorElement [
	self
		pharoBehaviorInSelectionOrAtCursorInEditor: anEditorElement editor
		ifFound: [ :aBehavior | anEditorElement phlow spawnTool: (GtClassCoderTool observedClass: aBehavior) ]
		ifNone: [  ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> defaultCoderLook [
	^ [ GtMethodCoderHeaderLook ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> removeRefactoringAttribute [
	self sourceText
		clearAttributes: [ :each | each class = GtRefactoringChangesAttribute ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> withHeader [
	self coderLook: [ GtMethodCoderHeaderLook ]
]
