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
	addOns addShortcut: GtSourceCoderInlineRenameShortcut new.
	addOns
		addMainAction: (GtCoderActivatableAction new
			title: 'Save' translated;
			icon: BrGlamorousVectorIcons accept;
			action: [ :aCoderUIModel :anEvent | self save ];
			enabled: [ :aCoderUIModel | aCoderUIModel isSaveEnabled ];
			updateWhen: GtMethodCoderSaveAbilityChanged).
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
		addMainAction: 'Inspect UI Model' translated
		icon: BrGlamorousVectorIcons inspect
		action: [ :aCoderUIModel :anEvent | self notifyObjectSpawn: aCoderUIModel ].
	addOns
		addMainAction: 'Copy Method Name' translated
		icon: BrGlamorousVectorIcons clipboard
		action: [ :aCoderUIModel :anEvent | self copyMethodNameToClipboard ].
	addOns clearChanges
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> renameAt: aTextPosition in: anEditorElement [
	self
		nodeAt: aTextPosition
		ifFound: [ :aNode |
			(aNode isMessage or: [ aNode isMethod ])
				ifTrue: [ ^ self renameMethod: anEditorElement ].
			aNode isVariable
				ifTrue: [ 
					aNode isLocallyDefined
						ifTrue: [ ^ self renameLocalVariableIn: anEditorElement ].
					(self behavior allInstVarNames includes: aNode name value)
						ifTrue: [ ^ self renameInstanceVariableIn: anEditorElement node: aNode ].
					(self classOrMetaClass classVariables
						anySatisfy: [ :assoc | assoc key asString = aNode name value ])
						ifTrue: [ ^ self renameClassVariableIn: anEditorElement ].
					Smalltalk globals
						at: aNode name value asSymbol
						ifPresent: [ :cls | 
							(cls isKindOf: Class)
								ifTrue: [ ^ self renameClassIn: anEditorElement ] ] ] ]
		ifNone: [  ]
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
GtMethodCoder >> renameInstanceVariableIn: editorElement node: aVariableNode [
	(GtRenameInstanceVariableController new
		coder: self;
		sourceElement: editorElement;
		originalNode: aVariableNode) execute
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> renameLocalVariableIn: editorElement [
	GtRenameAction pharoRenameLocalsOn: editorElement
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> renameMethod: editorElement [
	(GtRenameMethodController new
		coder: self;
		sourceElement: editorElement) execute
]
