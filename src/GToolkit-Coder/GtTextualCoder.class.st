Class {
	#name : #GtTextualCoder,
	#superclass : #GtCoderModel,
	#instVars : [
		'sourceCode',
		'completionStrategy',
		'astCache',
		'astMonitor',
		'astCommand'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - addons' }
GtTextualCoder >> addCopyCutPasteContextMenuAddOnsTo: coderAddOns [
	<gtCoderContextMenuAddOns: 10>
	coderAddOns
		addContextMenuItem: 'Cut'
			action: [ :anEditorElement | anEditorElement editor cutSelected ];
		addContextMenuItem: 'Copy'
			action: [ :anEditorElement | anEditorElement editor copySelected ];
		addContextMenuItem: 'Paste'
			action: [ :anEditorElement | anEditorElement editor paste ]
]

{ #category : #'private - addons' }
GtTextualCoder >> addOnChanged: aSymbol [
	aSymbol = #stylers
		ifTrue: [ self notifyStylersUpdated ].
	super addOnChanged: aSymbol
]

{ #category : #'private - addons' }
GtTextualCoder >> addOnsClass [
	^ GtSourceCoderAddOns
]

{ #category : #'api - text' }
GtTextualCoder >> appendString: aString [
	self critical: [
		self sourceCode appendString: aString.
		self sourceChanged ]
]

{ #category : #'api - accessing' }
GtTextualCoder >> ast [
	^ self subclassResponsibility
]

{ #category : #'private - ast' }
GtTextualCoder >> astCache [
	^ astMonitor critical: [ astCache ]
]

{ #category : #'private - ast' }
GtTextualCoder >> astCache: anAssociation [
	astMonitor critical: [ astCache := anAssociation ].
	self onAstChanged
]

{ #category : #'api - text' }
GtTextualCoder >> collapsedText [
	<return: #BlText>

	^ self sourceCode collapsedText
]

{ #category : #'api - accessing' }
GtTextualCoder >> completionStrategy [
	<return: #GtCompletionStrategy>

	^ completionStrategy
		ifNil: [ completionStrategy := self newCompletionStrategy ]
]

{ #category : #'api - accessing' }
GtTextualCoder >> completionStrategy: aGtCompletionStrategy [
	completionStrategy := aGtCompletionStrategy
]

{ #category : #'api - text' }
GtTextualCoder >> correctFrom: aFromIndex to: aToIndex with: aString [
	self critical: [
		self sourceCode
			replaceFrom: aFromIndex
			to: aToIndex
			withString: aString.
		self sourceChanged.
		self notifyCorrectionFrom: aFromIndex to: aToIndex with: aString ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceString [
	"Return a String representation of the current source text"
	<return: #String>

	^ self critical: [ self sourceCode sourceString ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceString: aString [
	"Set a new source text"

	self critical: [
		self sourceCode currentSourceString: aString.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceText: aText [
	"Set a new source text"

	self critical: [ 
		self sourceCode currentSourceText: aText.
		self sourceChanged ]
]

{ #category : #'api - text' }
GtTextualCoder >> currentSourceTextSynchronously: aText [
	"Set a new source text"

	self critical: [
		self sourceCode currentSourceText: aText.
		self sourceChangedWith: GtCoderUpdateStragegy new makeSynchronous ]
]

{ #category : #'api - text' }
GtTextualCoder >> deleteSourceTextFrom: aFromIndex to: aToIndex [
	self critical: [
		self sourceCode delete: aFromIndex to: aToIndex.
		self sourceChanged ]
]

{ #category : #'gt-extensions' }
GtTextualCoder >> gtViewStylersFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewStylersFor: aView ]
]

{ #category : #initialize }
GtTextualCoder >> initialize [
	super initialize.

	astMonitor := Monitor new.
	self reset
]

{ #category : #initialize }
GtTextualCoder >> initializeShortcuts [
]

{ #category : #testing }
GtTextualCoder >> isModified [
	<return: #Boolean>

	^ self sourceCode isModified
]

{ #category : #'instance creation' }
GtTextualCoder >> newCompletionStrategy [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
GtTextualCoder >> newSourceStylerFrom: anEditorElement [
	<return: #BlTextStyler>

	^ self subclassResponsibility
]

{ #category : #'private - notifying' }
GtTextualCoder >> notifySourceChangedWith: anUpdateStragegy [
	"Notify the text editor that it should update the text (for example due to refactoring changes)"
	
	self announce: (GtCoderSourceCodeChanged new 
		updateStragegy: anUpdateStragegy;
		coder: self;
		source: anUpdateStragegy announcementSource)
]

{ #category : #'private - notifying' }
GtTextualCoder >> notifyStylersUpdated [
	"Is sent when AddOn stylers changed. It also means that the text editor should restyle the text"

	self announce: (GtCoderStylerChanged new
		coder: self;
		stylers: self addOns stylers copy)
]

{ #category : #'private - ast' }
GtTextualCoder >> onAstChanged [
]

{ #category : #private }
GtTextualCoder >> pragmasNamed: aSymbol inHierarchy: aClass [
	| actions |
	actions := OrderedCollection new.
	aClass withAllSuperclassesDo: [ :each | actions addAll: (Pragma allNamed: aSymbol in: each) ].
	actions sort: [ :a :b | a arguments first < b arguments first ].
	^ actions
]

{ #category : #'api - text' }
GtTextualCoder >> requestStyleSourceText [
	"Request the text editor to restyle the text (for example due to environmental changes)"

	self resetASTCache.
	self announce: (GtCoderStyleTextRequest new coder: self)
]

{ #category : #'api - text' }
GtTextualCoder >> requestStyleSourceTextAndAfterDo: aBlock [
	"Request the text editor to restyle the text (for example due to environmental changes)"

	self resetASTCache.
	self
		announce:
			(GtCoderStyleTextRequest new
				coder: self;
				afterAction: aBlock)
]

{ #category : #'api - text' }
GtTextualCoder >> requestUpdateCollapsedText [
	"Request to update the collapsed text, for example due to changes in the current source text.
	It is not guaranteed that the collapsed text actually changes as for example in the method coder
	opened on a compiled method"

	self sourceCode resetCollapsedText.
	self announce: (GtCoderCollapsedLabelChanged new coder: self)
]

{ #category : #initialize }
GtTextualCoder >> reset [
	self resetASTCache.

	"initialized lazily in #sourceCode"
	sourceCode := nil.
	completionStrategy := nil
]

{ #category : #'private - ast' }
GtTextualCoder >> resetASTCache [
	self astCache: (nil -> nil)
]

{ #category : #'event handling' }
GtTextualCoder >> sourceChanged [
	self sourceChangedWith: GtCoderUpdateStragegy new makeAsynchronous
]

{ #category : #'event handling' }
GtTextualCoder >> sourceChangedWith: anUpdateStrategy [
	self requestUpdateCollapsedText.
	self requestUpdateAddOns.
	
	self notifySourceChangedWith: anUpdateStrategy
]

{ #category : #'api - accessing' }
GtTextualCoder >> sourceCode [
	<return: #GtCoderSourceCode>

	sourceCode ifNil: [ self sourceCode: (GtCoderExplicitSourceCode new source: '') ].
	^ sourceCode
]

{ #category : #'api - accessing' }
GtTextualCoder >> sourceCode: aGtCoderSourceCode [
	"Set the source code of this coder to a given one and notify about the changes"
	
	self 
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStragegy new makeAsynchronous
]

{ #category : #'api - accessing' }
GtTextualCoder >> sourceCode: aGtCoderSourceCode withStrategy: anUpdateStragegy [
	"Set the source code of this coder to a given one and notify about the changes"
	
	sourceCode := aGtCoderSourceCode.
	self sourceChangedWith: anUpdateStragegy.
]

{ #category : #'api - accessing' }
GtTextualCoder >> sourceCodeSynchronously: aGtCoderSourceCode [
	self
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStragegy new makeSynchronous
]

{ #category : #'api - text' }
GtTextualCoder >> sourceText [
	"Return the source text for this coder. The computation of the source text may be expensive, use me with caution.
	If the operation you would like to perform on the source text is optional consider using #sourceTextDo:"
	<return: #BlText>

	^ self sourceCode sourceText
]

{ #category : #'api - text' }
GtTextualCoder >> sourceTextDo: aBlock [
	"Evaluate a given block with my source code text if present"

	^ self sourceCode sourceTextDo: aBlock
]

{ #category : #'api - addons' }
GtTextualCoder >> stylers [
	^ self addOns stylers
]

{ #category : #'private - addons' }
GtTextualCoder >> terminateAddOnsCommand [
	addOnCommand
		ifNil: [ ^ self ].
	addOnCommand terminate.
	addOnCommand := nil
]

{ #category : #'api - addons' }
GtTextualCoder >> updateAddOns [
	"Start the update of the addons in a context of a given element"

	addOnMonitor
		critical: [			 
			BlUseAsyncFeatures 
				ifEnabledDo: [ 
					self terminateAddOnsCommand.
					addOnCommand := self updateAddOnsCommand.
					addOnCommand name: 'AddOns: ' , self identityHash printString.
					BlTktWorkerProvider coderPool schedule: addOnCommand ]
				otherwise: [ 
					self updateAddOnsCommand execute ] ]
]

{ #category : #'private - addons' }
GtTextualCoder >> updateAddOnsCommand [
	^ [
		| updatedAddOns pragmas ast |
		ast := self ast.
		pragmas := self
			pragmasNamed: #gtAstCoderAddOns:
			inHierarchy: self class.
		updatedAddOns := self addOns copy.
		pragmas
			reverseDo:
				[ :each | self perform: each methodSelector with: ast with: updatedAddOns ].
		addOns := updatedAddOns.
		addOns markAsUpdated.
		updatedAddOns changesDo: [ :each | self addOnChanged: each ].
		updatedAddOns clearChanges
	] asBlTktTerminableCommand
]

{ #category : #'api - addons' }
GtTextualCoder >> updateContextMenuAddOnsFrom: anEditorElement [
	| updatedAddOns pragmas |
	pragmas := self
		pragmasNamed: #gtCoderContextMenuAddOns:
		inHierarchy: self class.
	updatedAddOns := self addOns copy.
	updatedAddOns clearContextMenu.
	pragmas
		do: [ :each | self perform: each methodSelector withEnoughArguments: { updatedAddOns. anEditorElement } ].
	addOns := updatedAddOns.
	updatedAddOns clearChanges
]
