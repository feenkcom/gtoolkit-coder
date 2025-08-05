Class {
	#name : #GtTextualCoderViewModel,
	#superclass : #GtExpandableCoderViewModel,
	#instVars : [
		'stylers',
		'mainActions',
		'contextActions',
		'contextMenuActions',
		'shortcuts',
		'cursors',
		'selection',
		'extraTextAttributes',
		'styledText',
		'isTextModifiedPromise',
		'completionStrategy',
		'debuggerInSpace',
		'nodeAttributeMap'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> addLocateDebuggerInSpaceAction: aSpace [
	debuggerInSpace := aSpace asWeakReference.

	aSpace
		addEventHandlerOn: BlSpaceClosedEvent
		do: [ :anEvent | self onDebuggerSpaceCloseEvent: anEvent ].

	self requestUpdateAddOns
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> addOnsFuture [
	"Return a future that will be resolved to coder addons"
	<return: #TAsyncFuture>
	^ self computeAddOnsFuture
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
	<return: #GtTextualCoderTextAttributes>
	^ self
		addTextAttributes: { aTextAttribute }
		from: aStartPosition
		to: anEndPosition
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> addTextAttribute: aTextAttribute onText: aText from: aStartPosition to: anEndPosition [
	<return: #GtTextualCoderTextAttributes>
	^ self
		addTextAttributes: { aTextAttribute }
		onText: aText
		from: aStartPosition
		to: anEndPosition
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> addTextAttributes: aCollectionOfTextAttributes from: aStartPosition to: anEndPosition [
	<return: #GtTextualCoderTextAttributes>
	
	^ self
		addTextAttributes: aCollectionOfTextAttributes
		onText: self sourceText
		from: aStartPosition
		to: anEndPosition
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> addTextAttributes: aCollectionOfTextAttributes onText: aText from: aStartPosition to: anEndPosition [
	<return: #GtTextualCoderTextAttributes>
	| aMarkerAttribute newCoderTextAttributes |
	
	aMarkerAttribute := BrTextInvisibleMarkerAttribute new beNotOverwritableByStyler.
	
	"we change the sourceText directly to not trigger the styler recomputation"
	aText attribute: aMarkerAttribute from: aStartPosition to: anEndPosition.
	
	newCoderTextAttributes := GtTextualCoderTextAttributes new
		markerAttribute: aMarkerAttribute;
		textAttributes: aCollectionOfTextAttributes.
	
	extraTextAttributes add: newCoderTextAttributes.
	self announce: (GtTextualCoderViewModelTextAttributesAdded new
		coderTextAttributes: newCoderTextAttributes;
		text: aText;
		startPosition: aStartPosition;
		stopPosition: anEndPosition).

	^ newCoderTextAttributes
]

{ #category : #'api - styling' }
GtTextualCoderViewModel >> allSavedAttributesForStyler: aStyler [
	^ (self nodeAttributeMapForStyler: aStyler) values
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> applyTextEditCommand: aTextEditCommand [
	self announce: (GtTextualCoderViewModelTextEditCommandRequestAnnouncement new
		textualCoderViewModel: self;
		textEditCommand: aTextEditCommand"; 
		updateStrategy: GtCoderUpdateStrategy new makeAsynchronous")
]

{ #category : #converting }
GtTextualCoderViewModel >> asEditorState [
	<return: #BrTextEditorCompositeMemento>
	| anEditorText aMemento |
	
	anEditorText := self coderModel currentSourceText copy.

	self extraTextAttributes do: [ :eachCoderAttributes |
		eachCoderAttributes applyOnEditorText: anEditorText ].

	aMemento := BrTextEditorCompositeMemento new
		addMemento: (BrTextEditorCursorsMemento new cursors: cursors copy);
		addMemento: (BrTextEditorSelectionMemento new selection: selection copy).

	self hasStyledText
		ifTrue: [
			aMemento addMemento: (BrTextEditorStyledTextMemento new
				text: self styledText;
				styler: self compositeStyler) ]
		ifFalse: [
		 	aMemento
				addMemento: (BrTextEditorTextMemento new text: anEditorText);
				addMemento: (BrTextEditorStylerMemento new styler: self compositeStyler) ].

	^ aMemento
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> astAsyncDo: aBlock [
	^ self coderModel astAsyncDo: aBlock
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> astAwait [
	self
		deprecated: 'Please use #astSync instead.'
		transformWith: '`@receiver astAwait' -> '`@receiver astSync'.

	^ self astSync
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> astSync [
	^ self coderModel astSync
]

{ #category : #accessing }
GtTextualCoderViewModel >> completionStrategy [
	<return: #GtCompletionStrategy>

	^ completionStrategy
		ifNil: [ completionStrategy := self newCompletionStrategy ]
]

{ #category : #accessing }
GtTextualCoderViewModel >> completionStrategy: aGtCompletionStrategy [
	completionStrategy := aGtCompletionStrategy
]

{ #category : #'api - stylers' }
GtTextualCoderViewModel >> compositeStyler [
	^ GtCoderAstCompositeStyler new
		coderViewModel: self;
		stylers: self stylers;
		yourself
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> computeAddOnsFuture [
	"Return a future that will be resolved to coder addons"
	<return: #TAsyncFuture>
	| aCoderModel |

	aCoderModel := self coderModel.
	^ aCoderModel coderAstFuture map: [ :aCoderAst |
		| theAst newAddOns pragmas |
		
		GtCoderAddOnsComputationStartedSignal new
			coderViewModel: self;
			emit.

		theAst := aCoderAst ast.

		pragmas := aCoderModel
			pragmasNamed: GtCoderModel astExtensionsPragma
			inHierarchy: aCoderModel class.

		newAddOns := aCoderModel newAddOns.
		newAddOns ast: aCoderAst.
		"extra addons"
		newAddOns addAddOns: aCoderModel addOns.
		aCoderModel initializeShortcuts: newAddOns.
		aCoderModel initializeAddOns: newAddOns viewModel: self.
		theAst ifNotNil: [
			pragmas reverseDo: [ :eachPragma |
				[ 
				
				BlFrameTelemetry telemetryComputationStartSignal: eachPragma.
				
				aCoderModel
					perform: eachPragma methodSelector
					withEnoughArguments: { theAst . newAddOns . self }.
					
				BlFrameTelemetry telemetryComputationEndSignal: eachPragma.

				GtCoderAddOnCreatedSignal new
					coderViewModel: self;
					addOnClass: eachPragma methodClass;
					addOnSelector: eachPragma methodSelector;
					emit. ]
				on: Error
				do: [ :anError |
					BlFrameTelemetry telemetryComputationEndSignal: eachPragma.
				
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
		
		GtCoderAddOnsComputationFinishedSignal new
			coderViewModel: self;
			emit.
		
		newAddOns ]
]

{ #category : #'private - addons' }
GtTextualCoderViewModel >> computeContextMenuAstAddOns [
	<return: #GtCoderAddOns>
	| aCoderModel newAddOns pragmas theAst |

	aCoderModel := self coderModel.

	theAst := aCoderModel astSync.
	pragmas := aCoderModel
		pragmasNamed: #gtCoderContextMenuAddOns:
		inHierarchy: aCoderModel class.

	newAddOns := aCoderModel newAddOns.
	theAst ifNotNil: [
		pragmas do: [ :eachPragma |
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
	<return: #Collection of: #GtCoderContextMenuAction>
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

{ #category : #accessing }
GtTextualCoderViewModel >> extraTextAttributes [
	^ extraTextAttributes
]

{ #category : #'gt-extension' }
GtTextualCoderViewModel >> gtInfo [
	^ Array streamContents: [ :aStream |
		aStream nextPut: (#coderModel -> self coderModel).
		aStream nextPut: (#cursors -> self cursors).
		aStream nextPut: (#selection -> self selection).
		aStream nextPut: (#addOns -> self addOns wait).
		aStream nextPut: (#ast -> self astSync).
		aStream nextPut: (#stylers -> self stylers).
		aStream nextPut: (#mainActions -> self mainActions).
		aStream nextPut: (#contextActions -> self contextActions).
		aStream nextPut: (#contextMenuActions -> self contextMenuActions).
		aStream nextPut: (#shortcuts -> self shortcuts).
		aStream nextPut: (#attributes -> self extraTextAttributes).
		aStream nextPut: (#hasFocus -> self focused).
		aStream nextPut: (#expanded -> self expanded).
		aStream nextPut: (#wantsHeader -> self wantsHeader) ]
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
			text: [ :eachItem :eachIndex | eachItem key asRopedText foreground: Color gray ]
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

{ #category : #'api - styled text' }
GtTextualCoderViewModel >> hasStyledText [
	<return: #Boolean>
	<propertyTester: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyTesterTemplate'>

	^ styledText notNil
]

{ #category : #initialization }
GtTextualCoderViewModel >> initialize [
	super initialize.

	extraAddOns := GtTextualCoderAddOns new.
	stylers := #().
	shortcuts := #().
	mainActions := #().
	contextActions := #().
	contextMenuActions := #().

	cursors := BrTextEditorMultipleCursor new.
	selection := BlCompositeSelection new.
	extraTextAttributes := OrderedCollection new.
	nodeAttributeMap := Dictionary new
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> isTextModifiedPromise [
	"Return a promise which is resolved to true if the text is modified,
	false otherwise. Should be used together with {{gtClass:GtTextualCoderViewModelTextChanged}} to update
	the modification status in the UI"
	<return: #TAsyncPromise of: #Boolean>
	
	^ isTextModifiedPromise ifNil: [ isTextModifiedPromise := self coderModel isModifiedPromise ]
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> locateDebuggerInSpaceAction [
	| aSpace |
	debuggerInSpace ifNil: [ ^ nil ].
	aSpace := debuggerInSpace at: 1.
	aSpace ifNil: [ ^ nil ].

	^ GtCoderLocateDebuggerAction new weakSpace: debuggerInSpace
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
GtTextualCoderViewModel >> moveCursorAtEnd [
	"Move the cursor at the end of the textual snippet"

	self moveCursorTo: self sourceText size
]

{ #category : #'api - cursors' }
GtTextualCoderViewModel >> moveCursorAtStart [
	"Move the cursor at the end of the textual snippet"

	self moveCursorTo: 0
]

{ #category : #'api - cursors' }
GtTextualCoderViewModel >> moveCursorTo: aCursorIndex [
	self cursors: (BrTextEditorCursor at: aCursorIndex)
]

{ #category : #accessing }
GtTextualCoderViewModel >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #accessing }
GtTextualCoderViewModel >> nodeAttributeMapForStyler: aStyler [
	^ nodeAttributeMap at: aStyler class ifAbsentPut: [Dictionary new]
]

{ #category : #'private - notifying' }
GtTextualCoderViewModel >> notifyCursorsChanged: aBrTextEditorCursor from: aSourceObject [
	self announce: (GtTextualCoderViewModelCursorsChanged new
		textualCoderViewModel: self;
		cursors: aBrTextEditorCursor;
		source: aSourceObject)
]

{ #category : #'private - notifying' }
GtTextualCoderViewModel >> notifySelectionChanged: aBlCompositeSelection from: aSourceObject [
	self announce: (GtTextualCoderViewModelSelectionChanged new selection: aBlCompositeSelection; source: aSourceObject)
]

{ #category : #'api - styled text' }
GtTextualCoderViewModel >> notifyStyledTextChanged [
	"Override this notify method to announce changes to the property"
	<propertyChangeNotifier: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#notifyPropertyChangedTemplate'>
	self announce: (GtTextualCoderViewModelStyledTextChanged new
		styledText: self styledText).
]

{ #category : #'private - event handling' }
GtTextualCoderViewModel >> onAddOnsChanged: theAddOns [
	"Is sent by Coder Element from a UI thread when new add-ons are computed"
	| someContextActions |
	super onAddOnsChanged: theAddOns.

	self shortcuts: theAddOns shortcuts.
	self mainActions: theAddOns mainActions.

	someContextActions := theAddOns contextActions.
	self locateDebuggerInSpaceAction ifNotNil: [ :anAction | 
		someContextActions := someContextActions copyWith: anAction ].
	self contextActions: someContextActions.

	self contextMenuActions: theAddOns contextMenuActions.
	self stylers: theAddOns stylers
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> onCoderModelChanged [
	super onCoderModelChanged
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModel >> onDebuggerSpaceCloseEvent: anEvent [
	| aCurrentSpace |
	debuggerInSpace ifNil: [ ^ self ].
	aCurrentSpace := debuggerInSpace at: 1.
	aCurrentSpace ifNil: [ ^ self ].

	aCurrentSpace = anEvent space ifFalse: [ ^ self ].
	debuggerInSpace := nil.
	self requestUpdateAddOns
]

{ #category : #'api - styled text' }
GtTextualCoderViewModel >> onNewStyledTextSet: aNewStyledText [
	"Is sent after a new value of the styledText is assigned"
	<propertySetHook: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onNewPropertySetHookTemplate'>
]

{ #category : #'api - styled text' }
GtTextualCoderViewModel >> onPreviousStyledTextUnset: aPreviousStyledText [
	"Is sent after a previous value of the styledText is de-assigned"
	<propertyUnsetHook: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onPreviousPropertyUnsetHookTemplate'>
]

{ #category : #'private - event handling' }
GtTextualCoderViewModel >> onSourceCodeChanged: anSourceCodeChangedAnnouncement [
	"source code changed, meaning that the styled text is no longer correct"
	self unsetStyledText.
	
	addOnPromise := nil.
	isTextModifiedPromise := nil.

	self announce: (GtTextualCoderViewModelTextChanged new
		textualCoderViewModel: self;
		text: self coderModel currentSourceText;
		updateStrategy: anSourceCodeChangedAnnouncement updateStrategy)
]

{ #category : #'private - event handling' }
GtTextualCoderViewModel >> onSourceCodeReplaced: aSourceCodeReplacedAnnouncement [
	"source code replaced to a new one. It most likely means that the origin of
	the source text has changed."
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> removeAllCoderTextAttributes: aCollectionOfGtTextualCoderTextAttributes [
	aCollectionOfGtTextualCoderTextAttributes do: [ :eachCoderTextAttribute |
		self removeCoderTextAttributes: eachCoderTextAttribute ]
]

{ #category : #'api - refactorings' }
GtTextualCoderViewModel >> removeAttribute: anAttribute [
	| attributes |
	attributes := self extraTextAttributes select: [ :each | each textAttributes includes: anAttribute ].
	self removeAllCoderTextAttributes: attributes
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

{ #category : #'api - shortcuts' }
GtTextualCoderViewModel >> removeStylersOfClass: aGtCoderStylerClass [
	extraAddOns removeStylersOfClass: aGtCoderStylerClass
]

{ #category : #'api - actions' }
GtTextualCoderViewModel >> requestSearch [
	"Request the view model to start the saving process. We first send a corresponding announcement to
	allow UI to intercept the saving request and show, for example, a confirmation dialog. If an announcement
	was not consumed (= handled) proceed with the default save action"
	| anAnnouncement |

	anAnnouncement := GtSourceCoderViewModelSearchTextRequested new textualCoderViewModel: self.
	self announce: anAnnouncement.
]

{ #category : #'api - attribute state' }
GtTextualCoderViewModel >> resetNodeAttributeMapForStyler: aStyler [
	nodeAttributeMap at: aStyler class put: Dictionary new
]

{ #category : #'api - attribute state' }
GtTextualCoderViewModel >> saveAttribute: folder forNode: aNode andStyler: aStyler [
	(self nodeAttributeMapForStyler: aStyler) at: aNode put: folder
]

{ #category : #'api - scrolling' }
GtTextualCoderViewModel >> scrollToLine: aLineIndex withCharacterPosition: aCharacterPosition [
	aLineIndex ifNil: [ ^ self ].
	aCharacterPosition ifNil: [ ^ self ].

	self
		announce: (GtTextualCoderViewModelScrollToCharacterPositionAnnouncement new
				textualCoderViewModel: self;
				lineIndex: aLineIndex;
				characterPosition: aCharacterPosition)
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
	"Return a collection of current editor shortcuts that are computed based on the coder add-ons and extra view-model add-ons.
	Do not modify the returned collection as it will be recomputed when ast or add-ons change; instead use #addShortcut:"
	<return: #Collection of: #BlBasicShortcut>
	
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
	<return: #AsyncPromise of: #Boolean>

	^ addOnPromise
		ifNil: [ true asAsyncPromise ]
		ifNotNil: [ :theAddOnsPromise | theAddOnsPromise then: [ :theAddOns | theAddOns shouldBeUpdated ] ]
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> sourceText [
	<return: #BlText>

	^ self coderModel currentSourceText
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> sourceText: aNewSourceText from: aSourceObject synchronously: isSynchronous [
	self 
		sourceText: aNewSourceText 
		from: aSourceObject 
		synchronously: isSynchronous  
		dueToEvent: nil
]

{ #category : #'api - text' }
GtTextualCoderViewModel >> sourceText: aNewSourceText from: aSourceObject synchronously: isSynchronous  dueToEvent: aTextModifiedEvent [
	self coderModel
		currentSourceText: aNewSourceText
		with: (GtCoderUpdateStrategy new
			source: aSourceObject;
			isSynchronous: isSynchronous)
		dueTo: aTextModifiedEvent
]

{ #category : #'api - styled text' }
GtTextualCoderViewModel >> styledText [
	<return: #Object>
	<propertyGetter: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyGetterTemplate'>

	^ styledText
]

{ #category : #'api - styled text' }
GtTextualCoderViewModel >> styledText: aNewStyledText [
	<propertySetter: #styledText>
	<propertyAnnouncement: #GtTextualCoderViewModelStyledTextChanged>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertySetterTemplate'>

	(self hasStyledText
		and: [ self styledText = aNewStyledText ])
			ifTrue: [ ^ self ].
	
	self hasStyledText
		ifTrue: [
			| aPreviousStyledText |
			aPreviousStyledText := styledText.
			styledText := nil.
			self onPreviousStyledTextUnset: aPreviousStyledText ].
	styledText := aNewStyledText.
	self onNewStyledTextSet: aNewStyledText.
	self notifyStyledTextChanged
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
	
	"when stylers change we should reset the styled text, since there is no guarantee it will be a valid one"
	self unsetStyledText.
	self announce: GtTextualCoderViewModelStylersChanged new.
	self announce: GtTextualCoderViewModelReadyToRestyle new
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> subscribeToCoderModel [
	super subscribeToCoderModel.
	
	self coderModel weak
		when: GtCoderSourceCodeReplaced
		send: #onSourceCodeReplaced:
		to: self.
	
	self coderModel weak
		when: GtCoderSourceCodeChanged
		send: #onSourceCodeChanged:
		to: self
]

{ #category : #'api - styled text' }
GtTextualCoderViewModel >> unsetStyledText [
	<propertyUnsetter: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyUnsetterTemplate'>
	| aPreviousStyledText |

	self hasStyledText
		ifFalse: [ ^ self ].

	aPreviousStyledText := styledText.
	styledText := nil.
	self onPreviousStyledTextUnset: aPreviousStyledText.
	self notifyStyledTextChanged
]

{ #category : #'api - coder model' }
GtTextualCoderViewModel >> unsubscribeFromCoderModel [
	super unsubscribeFromCoderModel.
	
	self coderModel unsubscribe: self
]
