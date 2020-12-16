Extension { #name : #GtMethodCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> addRefactoringContextMenuAddOnsTo: coderAddOns from: anEditorElement [
	<gtCoderContextMenuAddOns: 20>
	self addExtractMethodTo: coderAddOns from: anEditorElement.
	(self rbSelectedNodeFrom: anEditorElement)
		ifNotNil: [ :ast | 
			self addInstanceAccessorRefactoringsFor: ast to: coderAddOns.
			self addClassAccessorRefactoringsFor: ast to: coderAddOns.
			self addRemoveParameterRefactoringFor: ast to: coderAddOns.
			ast
				withAllParentsDo: [ :node | self addInlineSelfMessageFor: node to: coderAddOns ].
			ast
				withAllParentsDo: [ :node | self addInlineTempFor: node to: coderAddOns ].
			ast
				withAllParentsDo: [ :node | self addExtractTempFor: node to: coderAddOns ] ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> copyMethodNameToClipboard [
	self compiledMethod ifNotNil: [ :aCompiledMethod | 
		Clipboard clipboardText: aCompiledMethod printString ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> exampleAstFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(self compiledMethod notNil
		and: [ anAST notNil
				and: [ anAST methodNode
						ifNotNil: [ :node | 
							node pragmas
								anySatisfy: [ :each | each isParseError not and: [ each selector = #gtExample ] ] ]
						ifNil: [ false ] ] ])
		ifFalse: [
			coderAddOns removeStylerOfType: GtCoderExampleStatusStyler.
			coderAddOns
				removeContextAction: 'Play Example' translated.
			coderAddOns
				removeContextAction: 'Play and Inspect Example Result' translated.
			coderAddOns
				removeContextAction: 'Inspect Example Object' translated.
			coderAddOns
				removeContextAction: 'Debug Example' translated.
			^ self ].
	coderAddOns
		addStyler:
			(GtCoderExampleStatusStyler new
				coder: self;
				classOrMetaClass: self behavior).
	(self canExecuteExample or: [ anAST methodNode numArgs isZero ])
		ifFalse: [ ^ self ].

	coderAddOns
		addContextAction: 'Play Example' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aCoderUIModel :anEvent | self playExample ]
		id: GtMethodCoderPlayExampleActionId.
	coderAddOns
		addContextAction: 'Play and Inspect Example Result' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | self playAndInspectExample ]
		id: GtMethodCoderPlayAndInspectExampleActionId.
	coderAddOns
		addContextAction: 'Inspect Example Object' translated
		icon: BrGlamorousVectorIcons eg
		action: [ :aCoderUIModel :anEvent | self notifyObjectSpawn: self example ].
	coderAddOns
		addContextAction: 'Debug Example' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :aCoderUIModel :anEvent | self debugExample ]
		id: GtMethodCoderDebugExampleActionId
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtMethodCoder >> initializeAddOns [
	super initializeAddOns.
	"addOns addStyler: GtCoderCommentStyler new."
	addOns addStyler: (GtFixItStyler new sourceCoder: self).
	addOns addShortcut: GtSourceCoderInlineRenameShortcut new.
	addOns
		addMainAction: (GtCoderActivatableAction new
			id: GtMethodCoderSaveActionId;
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
			(aNode isMessage or: [ aNode isMethod or: [ aNode isMethodPattern ] ])
				ifTrue: [ ^ self renameMethod: anEditorElement node: aNode ].
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
GtMethodCoder >> renameMethod: editorElement node: aMessageOrMethodOrMethodPatternNode [
	(GtRenameMethodController new
		coder: self;
		sourceElement: editorElement;
		originalNode: aMessageOrMethodOrMethodPatternNode) execute
]
