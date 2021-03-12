Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> addClassAccessorRefactoringsFor: aNode to: coderAddOns [
	aNode isVariable
		ifFalse: [ ^ self ].
	(aNode whoDefines: aNode name) notNil
		ifTrue: [ ^ self ].
	(self behavior allClassVarNames includes: aNode name asSymbol)
		ifFalse: [ ^ self ].
	coderAddOns
		addContextMenuItem: (self createLabel: 'Abstract variable' description: aNode name)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self abstractClassVar: aNode ].
	(self isAccessorMethodFor: aNode)
		ifFalse: [
			coderAddOns
				addContextMenuItem: (self createLabel: 'Create accessors' description: aNode name)
				hover: [ self highlightNode: aNode ]
				leave: [ self removeHighlight ]
				action: [ :element | self createAccessorsFor: aNode instanceVariable: false ] ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> addExtractMethodTo: coderAddOns from: anEditorElement [
	| nodes |
	nodes := self rbSelectedNodesFrom: anEditorElement.
	nodes isNil
		ifTrue: [ ^ self ].
	coderAddOns
		addContextMenuItem: 'Extract method'
		hover: [ self highlightFrom: nodes first start to: nodes last stop ]
		leave: [ self removeHighlight ]
		action: [ :element | self extractMethod: element ]
		id: GtMethodCoderExtractMethodContextMenuItemId
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> addExtractTempFor: aNode to: coderAddOns [
	aNode isValue
		ifFalse: [ ^ self ].
	aNode isUsed
		ifFalse: [ ^ self ].
	aNode isVariable
		ifTrue: [ ^ self ].
	aNode isAssignment
		ifTrue: [ ^ self ].
	aNode parent isAssignment
		ifTrue: [ ^ self ].
	coderAddOns
		addContextMenuItem:
			(self
				createLabel: 'Extract temporary'
				description: (self nodeDescription: aNode))
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self extractTemporaryVariable: aNode in: element ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> addInlineSelfMessageFor: aNode to: coderAddOns [
	aNode isMessage
		ifFalse: [ ^ self ].
	aNode receiver isSelf
		ifFalse: [ ^ self ].
	coderAddOns
		addContextMenuItem: (self createLabel: 'Inline Message' description: aNode selector)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self inlineMessageSendIn: aNode ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> addInlineTempFor: aNode to: coderAddOns [
	aNode isAssignment
		ifFalse: [ ^ self ].
	aNode variable gtIsLocal
		ifFalse: [ ^ self ].
	coderAddOns
		addContextMenuItem:
			(self
				createLabel: 'Inline Assignment'
				description: aNode variable name)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self inlineTemporaryVariableIn: aNode ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> addInstanceAccessorRefactoringsFor: aNode to: coderAddOns [
	aNode isVariable
		ifFalse: [ ^ self ].
	(aNode whoDefines: aNode name) notNil
		ifTrue: [ ^ self ].
	(self behavior allInstVarNames includes: aNode name)
		ifFalse: [ ^ self ].
	coderAddOns
		addContextMenuItem: (self createLabel: 'Abstract variable' description: aNode name)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self abstractInstVar: aNode ].
	(self isAccessorMethodFor: aNode)
		ifTrue: [ coderAddOns
				addContextMenuItem: (self createLabel: 'Protect variable' description: aNode name)
				hover: [ self highlightNode: aNode ]
				leave: [ self removeHighlight ]
				action: [ :element | self protectInstVar: aNode ] ]
		ifFalse: [ coderAddOns
				addContextMenuItem: (self createLabel: 'Create accessors' description: aNode name)
				hover: [ self highlightNode: aNode ]
				leave: [ self removeHighlight ]
				action: [ :element | self createAccessorsFor: aNode instanceVariable: true ] ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> addRefactoringContextMenuAddOnsTo: coderAddOns from: anEditorElement [
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
GtPharoMethodCoder >> addRemoveParameterRefactoringFor: aNode to: coderAddOns [
	aNode isVariable
		ifFalse: [ ^ self ].
	aNode parent isMethod
		ifFalse: [ ^ self ].
	aNode parent body
		nodesDo: [ :each | 
			each = aNode
				ifTrue: [ ^ self ] ].
	coderAddOns
		addContextMenuItem: (self createLabel: 'Remove parameter' description: aNode name)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self removeParameter: aNode ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> copyMethodNameToClipboard [
	self compiledMethod ifNotNil: [ :aCompiledMethod | 
		Clipboard clipboardText: aCompiledMethod printString ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> exampleAstFor: anAST into: coderAddOns [
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
GtPharoMethodCoder >> extractMethod: editorElement [
	(GtExtractMethodController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> initializeAddOns [
	super initializeAddOns.
	"addOns addStyler: GtCoderCommentStyler new."
	addOns addStyler: (GtFixItStyler new sourceCoder: self).
	addOns addStyler: BrRBTextStyler new.
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
GtPharoMethodCoder >> renameAt: aTextPosition in: anEditorElement [
	self
		nodeAt: aTextPosition
		ifFound: [ :aNode | 
			(aNode isMessage or: [ aNode isMethod or: [ aNode isMethodPattern ] ])
				ifTrue: [ ^ self renameMethod: anEditorElement node: aNode ].
			aNode isVariable
				ifTrue: [ aNode isLocallyDefined
						ifTrue: [ ^ self renameLocalVariableIn: anEditorElement ].
					(self behavior allInstVarNames includes: aNode name value)
						ifTrue: [ ^ self renameInstanceVariableIn: anEditorElement node: aNode ].
					(self behavior classVariables
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
GtPharoMethodCoder >> renameClassIn: editorElement [
	(GtRenameClassController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> renameClassVariableIn: editorElement [
	(GtRenameClassVariableController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> renameInstanceVariableIn: editorElement node: aVariableNode [
	(GtRenameInstanceVariableController new
		coder: self;
		sourceElement: editorElement;
		originalNode: aVariableNode) execute
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> renameLocalVariableIn: editorElement [
	GtRenameAction pharoRenameLocalsOn: editorElement
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoMethodCoder >> renameMethod: editorElement node: aMessageOrMethodOrMethodPatternNode [
	(GtRenameMethodController new
		coder: self;
		sourceElement: editorElement;
		originalNode: aMessageOrMethodOrMethodPatternNode) execute
]
