Extension { #name : #GtSourceCoder }

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
	^ [ GtSourceCoderHeaderLook ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSourceCoder >> withHeader [
	self coderLook: [ GtSourceCoderHeaderLook ]
]
