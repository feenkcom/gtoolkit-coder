Class {
	#name : #GtTextualCoderViewModel,
	#superclass : #GtCoderUIModel,
	#instVars : [
		'addOns',
		'addOnMonitor',
		'addOnCommand',
		'addOnCommandBlock',
		'extraAddOns',
		'stylers',
		'mainActions',
		'contextActions',
		'contextMenuActions',
		'shortcuts',
		'hasFocus',
		'expanded',
		'cursors',
		'selection',
		'extraTextAttributes'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> addOnsAsyncDo: aBlock [
	addOnMonitor critical: [
		addOnCommand ifNotNil: [
			| aUniqueSubscriber |
			aUniqueSubscriber := Object new.
			"the add-ons are being computed, subscribe to the ast changed announcement to wait until is finishes"
			^ self
				when: GtTextualCoderViewModelAddOnsChanged
				doOnce: [ :anAnnouncement | aBlock value: anAnnouncement addOns ]
				for: aUniqueSubscriber ].

		"the add-ons are already computed, return it directly"
		addOns ifNotNil: [ :theAddOns | ^ aBlock value: theAddOns ].

		addOnCommandBlock := [
			| theComputedAddOns |

			theComputedAddOns := self computeAddOns.
			addOnMonitor critical: [
				addOns := theComputedAddOns.
				addOnCommand := nil.
				addOnCommandBlock := nil ].
			self onAddOnsChanged: theComputedAddOns.
			aBlock value: theComputedAddOns.
			self announce: (GtTextualCoderViewModelAddOnsChanged new addOns: theComputedAddOns) ].
		addOnCommand := addOnCommandBlock asBlTktTerminableCommand asBlTktLoggingCommand.

		BlUseAsyncFeatures 
			ifEnabledDo: [ BlTktWorkerProvider coderAddOnsPool schedule: addOnCommand ]
			otherwise: [ addOnCommand execute ] ]
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> addOnsAwait [
	| theAddOns |
	
	theAddOns := nil.
	self addOnsAwaitDo: [ :theComputedAddOns | theAddOns := theComputedAddOns ].
	^ theAddOns
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> addOnsAwaitDo: aBlock [
	| aSemaphore theAddOns |
	
	aSemaphore := Semaphore new.
	theAddOns := nil.
	self addOnsAsyncDo: [ :theComputedAddOns |
		theAddOns := theComputedAddOns.
		aSemaphore signal ].
	
	aSemaphore wait: 5 seconds.
	aBlock value: theAddOns
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModel >> addShortcut: aShortcut [
	"Add an extra shortcut add-on independent from the dynamically computed add-ons"

	extraAddOns addShortcut: aShortcut
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModel >> addStyler: aGtCoderStyler [
	"Add an extra styler add-on independent from the dynamically computed add-ons"

	extraAddOns addStyler: aGtCoderStyler
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModel >> addStylers: aCollectionOfGtCoderStyler [
	"Add extra styler add-ons independent from the dynamically computed add-ons"

	aCollectionOfGtCoderStyler do: [ :eachStyler | self addStyler: eachStyler ]
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> addTextAttribute: aTextAttribute from: aStartPosition to: anEndPosition [
	<return: #GtTextualCoderViewModel>
	^ self
		addTextAttributes: { aTextAttribute }
		from: aStartPosition
		to: anEndPosition
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> addTextAttributes: aCollectionOfTextAttributes from: aStartPosition to: anEndPosition [
	<return: #GtTextualCoderViewModel>
	| aCurrentText aMarkerAttribute newCoderTextAttributes |
	
	aMarkerAttribute := BrTextInvisibleMarkerAttribute new beNotOverwritableByStyler.
	
	"we change the sourceText directly to not trigger the styler recomputation"
	aCurrentText := self sourceText.
	aCurrentText attribute: aMarkerAttribute from: aStartPosition to: anEndPosition.
	
	newCoderTextAttributes := GtTextualCoderTextAttributes new
		markerAttribute: aMarkerAttribute;
		textAttributes: aCollectionOfTextAttributes.
	
	extraTextAttributes add: newCoderTextAttributes.
	self announce: (GtTextualCoderViewModelTextAttributesAdded new
		coderTextAttributes: newCoderTextAttributes;
		startPosition: aStartPosition;
		stopPosition: anEndPosition).

	^ newCoderTextAttributes
]

{ #category : #converting }
GtTextualCoderViewModel >> asEditorState [
	| anEditorText |

	anEditorText := self coderModel sourceText copy.

	self extraTextAttributes do: [ :eachCoderAttributes |
		eachCoderAttributes applyOnEditorText: anEditorText ].

	^ BrTextEditorCompositeMemento new
		addMemento: (BrTextEditorTextMemento new text: anEditorText);
		addMemento: (BrTextEditorCursorsMemento new cursors: cursors copy);
		addMemento: (BrTextEditorSelectionMemento new selection: selection copy);
		addMemento: (BrTextEditorStylerMemento new styler: self compositeStyler)
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> astAwait [
	^ self coderModel astAwait
]

{ #category : #'api - expansion' }
GtTextualCoderViewModel >> collapse [
	self expanded: false
]

{ #category : #'api - stylers' }
GtTextualCoderViewModel >> compositeStyler [
	^ GtCoderAstCompositeStyler new
		coderViewModel: self;
		stylers: self stylers;
		yourself
]

{ #category : #'private - addons' }
GtTextualCoderViewModel >> computeAddOns [
	| aCoderModel newAddOns pragmas theAst |
		
	aCoderModel := self coderModel.
	
	theAst := aCoderModel astAwait.
	pragmas := aCoderModel
		pragmasNamed: #gtAstCoderAddOns:
		inHierarchy: aCoderModel class.

	newAddOns := aCoderModel newAddOns.
	"extra addons"
	newAddOns addAddOns: aCoderModel addOns.
	aCoderModel initializeShortcuts: newAddOns.
	aCoderModel initializeAddOns: newAddOns.
	theAst ifNotNil: [
		pragmas reverseDo: [ :eachPragma |
			[ aCoderModel
				perform: eachPragma methodSelector
				withEnoughArguments: { theAst . newAddOns . self } ]
			on: Error
			do: [ :anError |
				"emit as a beacon signal"
				anError emit.
				
				NonInteractiveTranscript stderr
					nextPut: $[;
					print: eachPragma method printString;
					nextPut: $];
					space;
					print: anError;
					cr ] ] ].

	"view model add-ons override coder model add-ons"
	newAddOns addAddOns: extraAddOns.
	newAddOns markAsUpdated.
	^ newAddOns
]

{ #category : #'private - addons' }
GtTextualCoderViewModel >> computeContextMenuAstAddOns [
	| aCoderModel newAddOns pragmas theAst |

	aCoderModel := self coderModel.

	theAst := aCoderModel astAwait.
	pragmas := aCoderModel
		pragmasNamed: #gtCoderContextMenuAddOns:
		inHierarchy: aCoderModel class.

	newAddOns := aCoderModel newAddOns.
	theAst ifNotNil: [
		pragmas reverseDo: [ :eachPragma |
			[ aCoderModel
				perform: eachPragma methodSelector
				withEnoughArguments: { theAst . newAddOns . self } ]
			on: Error
			do: [ :anError |
				"emit as a beacon signal"
				anError emit.
				
				NonInteractiveTranscript stderr
					nextPut: $[;
					print: eachPragma method printString;
					nextPut: $];
					space;
					print: anError;
					cr ] ] ].

	^ newAddOns
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> contextActions [
	^ contextActions
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> contextActions: theContextActions [
	contextActions = theContextActions
		ifTrue: [ ^ self ].

	contextActions := theContextActions.
	self announce: GtTextualCoderViewModelContextActionsChanged new
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> contextMenuActions [
	^ contextMenuActions
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> contextMenuActions: theContextMenuActions [
	contextMenuActions = theContextMenuActions
		ifTrue: [ ^ self ].

	contextMenuActions := theContextMenuActions.
	self announce: GtTextualCoderViewModelContextMenuActionsChanged new
]

{ #category : #'api - cursors' }
GtTextualCoderViewModel >> cursors [
	<return: #BrTextEditorCursor>

	^ cursors
]

{ #category : #'api - cursors' }
GtTextualCoderViewModel >> cursors: aBrTextEditorCursor [
	self cursors: aBrTextEditorCursor from: self
]

{ #category : #'api - cursors' }
GtTextualCoderViewModel >> cursors: aBrTextEditorCursor from: aSourceObject [
	cursors = aBrTextEditorCursor
		ifTrue: [ ^ self ].
	
	cursors := aBrTextEditorCursor copy.
	self notifyCursorsChanged: cursors from: aSourceObject
]

{ #category : #accessing }
GtTextualCoderViewModel >> elementClass [
	^ GtTextualCoderEditorElement
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> ensureAddOns [
	self addOnsAsyncDo: [ :theAddOns | ]
]

{ #category : #'api - expansion' }
GtTextualCoderViewModel >> expand [
	self expanded: true
]

{ #category : #'api - expansion' }
GtTextualCoderViewModel >> expanded [
	^ expanded
]

{ #category : #'api - expansion' }
GtTextualCoderViewModel >> expanded: aBoolean [
	expanded = aBoolean
		ifTrue: [ ^ self ].

	expanded := aBoolean.
	self notifyExpansionChanged: expanded
]

{ #category : #accessing }
GtTextualCoderViewModel >> extraTextAttributes [
	^ extraTextAttributes
]

{ #category : #'api - focus' }
GtTextualCoderViewModel >> focused [
	<return: #Boolean>

	^ hasFocus
]

{ #category : #'api - focus' }
GtTextualCoderViewModel >> focused: aBoolean [
	self focused: aBoolean from: self
]

{ #category : #'api - focus' }
GtTextualCoderViewModel >> focused: aBoolean from: aSourceObject [
	hasFocus = aBoolean
		ifTrue: [ ^ self ].

	hasFocus := aBoolean.
	self notifyFocusChanged: hasFocus from: aSourceObject.

	codersUIModel ifNotNil: [ :theCoders |
		aBoolean
			ifTrue: [ theCoders focusCoderUIModel: self  ]
			ifFalse: [ theCoders unfocusCoderUIModel: self ] ]
]

{ #category : #'gt-extension' }
GtTextualCoderViewModel >> gtInfo [
	^ Array streamContents: [ :aStream |
		aStream nextPut: (#coderModel -> self coderModel).
		aStream nextPut: (#cursors -> self cursors).
		aStream nextPut: (#selection -> self selection).
		aStream nextPut: (#stylers -> self stylers).
		aStream nextPut: (#mainActions -> self mainActions).
		aStream nextPut: (#contextActions -> self contextActions).
		aStream nextPut: (#contextMenuActions -> self contextMenuActions).
		aStream nextPut: (#shortcuts -> self shortcuts).
		aStream nextPut: (#attributes -> self extraTextAttributes).
		aStream nextPut: (#hasFocus -> self focused).
		aStream nextPut: (#expanded -> self expanded) ]
]

{ #category : #'gt-extension' }
GtTextualCoderViewModel >> gtInfoFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Info';
		priority: 0;
		items: [ self gtInfo ];
		actionUpdateButtonTooltip: 'Refresh';
		column: 'Property' 
			item: [ :eachItem :eachIndex | eachItem key asRopedText foreground: Color gray ]
			width: 150;
		column: 'Value' 
			text: [ :eachItem | eachItem value gtDisplayText ];
		send: [ :assoc | assoc value ];
		updateWhen: GtTextualCoderViewModelAnnouncement in: self announcer
]

{ #category : #'api - selection' }
GtTextualCoderViewModel >> hasSelection [
	^ self selection isNotEmpty
]

{ #category : #initialization }
GtTextualCoderViewModel >> initialize [
	super initialize.
	
	extraAddOns := GtTextualCoderAddOns new.
	addOnMonitor := Monitor new.
	stylers := #().
	shortcuts := #().
	mainActions := #().
	contextActions := #().
	contextMenuActions := #().
	
	cursors := BrTextEditorMultipleCursor new.
	selection := BlCompositeSelection new.
	extraTextAttributes := OrderedCollection new.
	
	hasFocus := false.
	expanded := true
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> mainActions [
	^ mainActions
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> mainActions: theMainActions [
	mainActions = theMainActions
		ifTrue: [ ^ self ].

	mainActions := theMainActions.
	self announce: GtTextualCoderViewModelMainActionsChanged new
]

{ #category : #'api - cursors' }
GtTextualCoderViewModel >> moveCursorTo: aCursorIndex [
	self cursors: (BrTextEditorCursor at: aCursorIndex)
]

{ #category : #'private - notifying' }
GtTextualCoderViewModel >> notifyCursorsChanged: aBrTextEditorCursor from: aSourceObject [
	self announce: (GtTextualCoderViewModelCursorsChanged new cursors: aBrTextEditorCursor; source: aSourceObject)
]

{ #category : #'private - notifying' }
GtTextualCoderViewModel >> notifyExpansionChanged: aBoolean [
	self announce: (GtTextualCoderViewModelExpansionChanged new expanded: aBoolean)
]

{ #category : #'private - notifying' }
GtTextualCoderViewModel >> notifyFocusChanged: aBoolean from: aSourceObject [
	self announcerUIModel announce: (GtSourceCoderFocusChanged new 
		focused: aBoolean; 
		source: aSourceObject)
]

{ #category : #'private - notifying' }
GtTextualCoderViewModel >> notifySelectionChanged: aBlCompositeSelection from: aSourceObject [
	self announce: (GtTextualCoderViewModelSelectionChanged new selection: aBlCompositeSelection; source: aSourceObject)
]

{ #category : #'private - addons' }
GtTextualCoderViewModel >> onAddOnsChanged: theAddOns [
	"Is sent when new add-ons are computed"

	self stylers: theAddOns stylers.
	self shortcuts: theAddOns shortcuts.
	self mainActions: theAddOns mainActions.
	self contextActions: theAddOns contextActions.
	self contextMenuActions: theAddOns contextMenuActions
]

{ #category : #'private - event handling' }
GtTextualCoderViewModel >> onAstChanged: anAstChangedAnnouncement [	
	self announce: GtTextualCoderViewModelAstChanged new.

	addOnMonitor critical: [ addOns := nil ].

	self addOnsAsyncDo: [ :theAddOns | self announce: GtTextualCoderViewModelReadyToRestyle new ]
]

{ #category : #'private - event handling' }
GtTextualCoderViewModel >> onSourceCodeChanged: anSourceCodeChangedAnnouncement [
	self announce: (GtTextualCoderViewModelTextChanged new
		text: self coderModel sourceText;
		updateStrategy: anSourceCodeChangedAnnouncement updateStrategy).

	self coderModel terminateAstCommand.
	self terminateAddOnsCommand.

	self coderModel ensureAst
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> removeAllCoderTextAttributes: aCollectionOfGtTextualCoderTextAttributes [
	aCollectionOfGtTextualCoderTextAttributes do: [ :eachCoderTextAttribute |
		self removeCoderTextAttributes: eachCoderTextAttribute ]
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> removeCoderTextAttributes: aGtTextualCoderTextAttributes [
	| aCurrentText |

	self extraTextAttributes
		remove: aGtTextualCoderTextAttributes
		ifAbsent: [ ^ self ].

	"we change the sourceText directly to not trigger the styler recomputation"
	aCurrentText := self sourceText.
	aCurrentText removeAttributes: { aGtTextualCoderTextAttributes markerAttribute }, aGtTextualCoderTextAttributes textAttributes.

	self announce: (GtTextualCoderViewModelTextAttributesRemoved new coderTextAttributes: aGtTextualCoderTextAttributes)
]

{ #category : #'api - selection' }
GtTextualCoderViewModel >> select: aFromCursorIndex to: aToCursorIndex [
	self selection: (self selection copy select: aFromCursorIndex to: aToCursorIndex)
]

{ #category : #'api - selection' }
GtTextualCoderViewModel >> selectNone [
	self selection: BlCompositeSelection new
]

{ #category : #'api - selection' }
GtTextualCoderViewModel >> selection [
	<return: #BlCompositeSelection>

	^ selection
]

{ #category : #'api - selection' }
GtTextualCoderViewModel >> selection: aBlCompositeSelection [
	self
		selection: aBlCompositeSelection
		from: self
]

{ #category : #'api - selection' }
GtTextualCoderViewModel >> selection: aBlCompositeSelection from: aSourceObject [
	selection = aBlCompositeSelection
		ifTrue: [ ^ self ].
	
	selection := aBlCompositeSelection copy.
	self notifySelectionChanged: selection from: aSourceObject
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModel >> shortcuts [
	^ shortcuts
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModel >> shortcuts: aCollectionOfShortcuts [
	shortcuts = aCollectionOfShortcuts
		ifTrue: [ ^ self ].
	
	shortcuts := aCollectionOfShortcuts.
	self announce: GtTextualCoderViewModelShortcutsChanged new
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> shouldAddOnsBeUpdated [
	"Return true if addons should be updated, false otherwise. When a Coder Model is attached to the corresponding Element
	that element should check if addons need to be updated and if it is the case start the update with the help of ${method:GtCoderModel>>#updateAddOnsFrom:}$"
	<return: #Boolean>

	^ addOnMonitor critical: [
		addOns
			ifNil: [ true ]
			ifNotNil: [ :theAddOns | theAddOns shouldBeUpdated ] ]
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> sourceText [
	<return: #BlText>

	^ self coderModel sourceText
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> sourceText: aNewSourceText from: aSourceObject	 synchronously: isSynchronous [
	self coderModel
		currentSourceText: aNewSourceText
		with: (GtCoderUpdateStrategy new
			source: aSourceObject;
			isSynchronous: isSynchronous)
]

{ #category : #'api - stylers' }
GtTextualCoderViewModel >> stylers [
	^ stylers
]

{ #category : #'api - stylers' }
GtTextualCoderViewModel >> stylers: theStylers [
	stylers = theStylers
		ifTrue: [ ^ self ].

	stylers := theStylers.
	theStylers do: [ :eachStyler |
		(eachStyler respondsTo: #coderViewModel:)
			ifTrue: [ eachStyler coderViewModel: self ] ].
	self announce: GtTextualCoderViewModelStylersChanged new
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> subscribeToCoderModel [
	super subscribeToCoderModel.
	
	self coderModel weak
		when: GtCoderAstChanged
		send: #onAstChanged:
		to: self.
		
	self coderModel weak
		when: GtCoderSourceCodeChanged
		send: #onSourceCodeChanged:
		to: self
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> terminateAddOnsCommand [
	addOnMonitor critical: [
		addOnCommand ifNotNil: [ :anAddOnsCommand | anAddOnsCommand terminate ].
		addOnCommand := nil.
		addOnCommandBlock := nil ]
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> unsubscribeFromCoderModel [
	super unsubscribeFromCoderModel.
	
	self coderModel unsubscribe: self
]
