Extension { #name : #GtMethodCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> copyMethodNameToClipboard [
	self compiledMethod ifNotNil: [ :aCompiledMethod | 
		Clipboard clipboardText: aCompiledMethod printString ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> initializeAddOns [
	super initializeAddOns.
	"addOns addStyler: GtCoderCommentStyler new."
	addOns addStyler: (GtFixItStyler new sourceCoder: self).
	addOns
		addMainAction: 'Save' translated
		icon: BrGlamorousVectorIcons accept
		action: [ :aCoderUIModel :anEvent | self save ].
	addOns
		addDropDownWithPreviewAction: 'Remove' translated
		icon: BrGlamorousVectorIcons remove
		action: [ :aButtonElement :aButtonModel :anEvent | self remove ]
		stencil: [ :element | self buildRemoveMethodLabel: element ].
	addOns
		addMainAction: 'Browse' translated
		icon: BrGlamorousVectorIcons browse
		action: [ :aCoderUIModel :anEvent | self browseFrom: anEvent currentTarget ].
	addOns
		addMainAction: 'Inspect Compiled Method' translated
		icon: BrGlamorousVectorIcons inspect
		action: [ :aCoderUIModel :anEvent | self notifyObjectSpawn: self compiledMethod ].
	addOns
		addMainAction: 'Copy Method Name' translated
		icon: BrGlamorousVectorIcons clipboard
		action: [ :aCoderUIModel :anEvent | self copyMethodNameToClipboard ].
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
