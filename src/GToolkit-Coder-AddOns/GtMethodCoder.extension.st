Extension { #name : #GtMethodCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> initializeAddOns [
	super initializeAddOns.
	"addOns addStyler: GtCoderCommentStyler new."
	addOns addStyler: (GtFixItStyler new sourceCoder: self).
	addOns
		addMainAction: 'Save' translated
		icon: BrGlamorousVectorIcons accept
		action: [ :anEditorElement | self save ].
	addOns
		addDropDownWithPreviewAction: 'Remove' translated
		icon: BrGlamorousVectorIcons remove
		action: [ :anEditorElement | self removeFrom: anEditorElement ]
		stencil: [ :element | self buildRemoveMethodLabel: element ].
	addOns
		addMainAction: 'Browse' translated
		icon: BrGlamorousVectorIcons browse
		action: [ :anEditorElement | self browseFrom: anEditorElement ].
	addOns
		addMainAction: 'Inspect Compiled Method' translated
		icon: BrGlamorousVectorIcons inspect
		action: [ :anEditorElement | anEditorElement phlow spawnObject: self compiledMethod ].
	addOns clearChanges
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> renameClassIn: editorElement [
	(GtRenameClassController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> renameClassVariableIn: editorElement [
	(GtRenameClassVariableController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> renameInstanceVariableIn: editorElement [
	(GtRenameInstanceVariableController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> renameMethod: editorElement [
	(GtRenameMethodController new
		coder: self;
		sourceElement: editorElement) execute
]
