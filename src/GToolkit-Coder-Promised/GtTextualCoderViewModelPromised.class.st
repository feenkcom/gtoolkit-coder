Class {
	#name : #GtTextualCoderViewModelPromised,
	#superclass : #GtSingleCoderViewModel,
	#instVars : [
		'addOnPromise',
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
		'extraTextAttributes',
		'styledText'
	],
	#category : #'GToolkit-Coder-Promised'
}

{ #category : #'api - add-ons' }
GtTextualCoderViewModelPromised >> addOns [
	^ self ensureAddOns
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModelPromised >> addShortcut: aShortcut [
	"Add an extra shortcut add-on independent from the dynamically computed add-ons"

	extraAddOns addShortcut: aShortcut
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModelPromised >> addStyler: aGtCoderStyler [
	"Add an extra styler add-on independent from the dynamically computed add-ons"

	extraAddOns addStyler: aGtCoderStyler
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModelPromised >> addStylers: aCollectionOfGtCoderStyler [
	"Add extra styler add-ons independent from the dynamically computed add-ons"

	aCollectionOfGtCoderStyler do: [ :eachStyler | self addStyler: eachStyler ]
]

{ #category : #'api - text' }
GtTextualCoderViewModelPromised >> addTextAttribute: aTextAttribute from: aStartPosition to: anEndPosition [
	<return: #GtTextualCoderTextAttributes>
	^ self
		addTextAttributes: { aTextAttribute }
		from: aStartPosition
		to: anEndPosition
]

{ #category : #'api - text' }
GtTextualCoderViewModelPromised >> addTextAttributes: aCollectionOfTextAttributes from: aStartPosition to: anEndPosition [
	<return: #GtTextualCoderTextAttributes>
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
GtTextualCoderViewModelPromised >> asEditorState [
	<return: #TAsyncPromise>
	
	^ self coderModel currentSourceText then: [ :aText |
		| anEditorText aMemento |
		
		anEditorText := aText copy.

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
		aMemento ]
]

{ #category : #'api - expansion' }
GtTextualCoderViewModelPromised >> collapse [
	self expanded: false
]

{ #category : #'api - stylers' }
GtTextualCoderViewModelPromised >> compositeStyler [
	^ GtCoderAstCompositeStyler new
		coderViewModel: self;
		stylers: self stylers;
		yourself
]

{ #category : #'private - addons' }
GtTextualCoderViewModelPromised >> computeAddOns [
	| aCoderModel  |

	aCoderModel := self coderModel.

	^ aCoderModel ast asyncThen: [ :aCoderAst |
		| theAst newAddOns pragmas |

		theAst := aCoderAst ast.

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
		newAddOns ].
]

{ #category : #'private - addons' }
GtTextualCoderViewModelPromised >> computeContextMenuAstAddOns [
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
GtTextualCoderViewModelPromised >> contextActions [
	^ contextActions
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModelPromised >> contextActions: theContextActions [
	contextActions = theContextActions
		ifTrue: [ ^ self ].

	contextActions := theContextActions.
	self announce: GtTextualCoderViewModelContextActionsChanged new
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModelPromised >> contextMenuActions [
	^ contextMenuActions
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModelPromised >> contextMenuActions: theContextMenuActions [
	contextMenuActions = theContextMenuActions
		ifTrue: [ ^ self ].

	contextMenuActions := theContextMenuActions.
	self announce: GtTextualCoderViewModelContextMenuActionsChanged new
]

{ #category : #'api - cursors' }
GtTextualCoderViewModelPromised >> cursors [
	<return: #BrTextEditorCursor>

	^ cursors
]

{ #category : #'api - cursors' }
GtTextualCoderViewModelPromised >> cursors: aBrTextEditorCursor [
	self cursors: aBrTextEditorCursor from: self
]

{ #category : #'api - cursors' }
GtTextualCoderViewModelPromised >> cursors: aBrTextEditorCursor from: aSourceObject [
	cursors = aBrTextEditorCursor
		ifTrue: [ ^ self ].
	
	cursors := aBrTextEditorCursor copy.
	self notifyCursorsChanged: cursors from: aSourceObject
]

{ #category : #accessing }
GtTextualCoderViewModelPromised >> elementClass [
	^ GtTextualCoderEditorElementPromised
]

{ #category : #'private - addons' }
GtTextualCoderViewModelPromised >> ensureAddOns [
	^ addOnPromise ifNil: [ addOnPromise := self computeAddOns then: [ :theAddOns | self onAddOnsChanged: theAddOns ]; yourself ]
]

{ #category : #'api - expansion' }
GtTextualCoderViewModelPromised >> expand [
	self expanded: true
]

{ #category : #'api - expansion' }
GtTextualCoderViewModelPromised >> expanded [
	^ expanded
]

{ #category : #'api - expansion' }
GtTextualCoderViewModelPromised >> expanded: aBoolean [
	expanded = aBoolean
		ifTrue: [ ^ self ].

	expanded := aBoolean.
	self notifyExpansionChanged: expanded
]

{ #category : #accessing }
GtTextualCoderViewModelPromised >> extraTextAttributes [
	^ extraTextAttributes
]

{ #category : #'api - focus' }
GtTextualCoderViewModelPromised >> focused [
	<return: #Boolean>

	^ hasFocus
]

{ #category : #'api - focus' }
GtTextualCoderViewModelPromised >> focused: aBoolean [
	self focused: aBoolean from: self
]

{ #category : #'api - focus' }
GtTextualCoderViewModelPromised >> focused: aBoolean from: aSourceObject [
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
GtTextualCoderViewModelPromised >> gtInfo [
	^ Array streamContents: [ :aStream |
		aStream nextPut: (#coderModel -> self coderModel).
		aStream nextPut: (#cursors -> self cursors).
		aStream nextPut: (#selection -> self selection).
		aStream nextPut: (#ast -> self coderModel ast wait).
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
GtTextualCoderViewModelPromised >> gtInfoFor: aView [
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
GtTextualCoderViewModelPromised >> hasSelection [
	^ self selection isNotEmpty
]

{ #category : #'api - styled text' }
GtTextualCoderViewModelPromised >> hasStyledText [
	<return: #Boolean>
	<propertyTester: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyTesterTemplate'>

	^ styledText notNil
]

{ #category : #initialization }
GtTextualCoderViewModelPromised >> initialize [
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
	
	hasFocus := false.
	expanded := true
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModelPromised >> mainActions [
	^ mainActions
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModelPromised >> mainActions: theMainActions [
	mainActions = theMainActions
		ifTrue: [ ^ self ].

	mainActions := theMainActions.
	self announce: GtTextualCoderViewModelMainActionsChanged new
]

{ #category : #'api - cursors' }
GtTextualCoderViewModelPromised >> moveCursorAtEnd [
	"Move the cursor at the end of the textual snippet"

	self moveCursorTo: self sourceText size
]

{ #category : #'api - cursors' }
GtTextualCoderViewModelPromised >> moveCursorAtStart [
	"Move the cursor at the end of the textual snippet"

	self moveCursorTo: 0
]

{ #category : #'api - cursors' }
GtTextualCoderViewModelPromised >> moveCursorTo: aCursorIndex [
	self cursors: (BrTextEditorCursor at: aCursorIndex)
]

{ #category : #'private - notifying' }
GtTextualCoderViewModelPromised >> notifyCursorsChanged: aBrTextEditorCursor from: aSourceObject [
	self announce: (GtTextualCoderViewModelCursorsChanged new cursors: aBrTextEditorCursor; source: aSourceObject)
]

{ #category : #'private - notifying' }
GtTextualCoderViewModelPromised >> notifyExpansionChanged: aBoolean [
	self announce: (GtTextualCoderViewModelExpansionChanged new expanded: aBoolean)
]

{ #category : #'private - notifying' }
GtTextualCoderViewModelPromised >> notifyFocusChanged: aBoolean from: aSourceObject [
	self announcerUIModel announce: (GtSourceCoderFocusChanged new 
		focused: aBoolean; 
		source: aSourceObject)
]

{ #category : #'private - notifying' }
GtTextualCoderViewModelPromised >> notifySelectionChanged: aBlCompositeSelection from: aSourceObject [
	self announce: (GtTextualCoderViewModelSelectionChanged new selection: aBlCompositeSelection; source: aSourceObject)
]

{ #category : #'api - styled text' }
GtTextualCoderViewModelPromised >> notifyStyledTextChanged [
	"Override this notify method to announce changes to the property"
	<propertyChangeNotifier: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#notifyPropertyChangedTemplate'>
	self announce: (GtTextualCoderViewModelStyledTextChanged new
		styledText: self styledText).
]

{ #category : #'private - event handling' }
GtTextualCoderViewModelPromised >> onAddOnsChanged: theAddOns [
	"Is sent when new add-ons are computed"

	self stylers: theAddOns stylers.
	self shortcuts: theAddOns shortcuts.
	self mainActions: theAddOns mainActions.
	self contextActions: theAddOns contextActions.
	self contextMenuActions: theAddOns contextMenuActions.
	
	self announce: GtTextualCoderViewModelReadyToRestyle new
]

{ #category : #'api - styled text' }
GtTextualCoderViewModelPromised >> onNewStyledTextSet: aNewStyledText [
	"Is sent after a new value of the styledText is assigned"
	<propertySetHook: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onNewPropertySetHookTemplate'>
]

{ #category : #'api - styled text' }
GtTextualCoderViewModelPromised >> onPreviousStyledTextUnset: aPreviousStyledText [
	"Is sent after a previous value of the styledText is de-assigned"
	<propertyUnsetHook: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onPreviousPropertyUnsetHookTemplate'>
]

{ #category : #'private - event handling' }
GtTextualCoderViewModelPromised >> onSourceCodeChanged: anSourceCodeChangedAnnouncement [
	"source code changed, meaning that the styled text is no longer correct"
	self unsetStyledText.
	
	addOnPromise := nil.
	self ensureAddOns.

	self announce: (GtTextualCoderViewModelTextChanged new
		text: self coderModel currentSourceText;
		updateStrategy: anSourceCodeChangedAnnouncement updateStrategy)
]

{ #category : #'api - text' }
GtTextualCoderViewModelPromised >> removeAllCoderTextAttributes: aCollectionOfGtTextualCoderTextAttributes [
	aCollectionOfGtTextualCoderTextAttributes do: [ :eachCoderTextAttribute |
		self removeCoderTextAttributes: eachCoderTextAttribute ]
]

{ #category : #'api - refactorings' }
GtTextualCoderViewModelPromised >> removeAttribute: anAttribute [
	| attributes |
	attributes := self extraTextAttributes select: [ :each | each textAttributes includes: anAttribute ].
	self removeAllCoderTextAttributes: attributes
]

{ #category : #'api - text' }
GtTextualCoderViewModelPromised >> removeCoderTextAttributes: aGtTextualCoderTextAttributes [
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
GtTextualCoderViewModelPromised >> select: aFromCursorIndex to: aToCursorIndex [
	self selection: (self selection copy select: aFromCursorIndex to: aToCursorIndex)
]

{ #category : #'api - selection' }
GtTextualCoderViewModelPromised >> selectNone [
	self selection: BlCompositeSelection new
]

{ #category : #'api - selection' }
GtTextualCoderViewModelPromised >> selection [
	<return: #BlCompositeSelection>

	^ selection
]

{ #category : #'api - selection' }
GtTextualCoderViewModelPromised >> selection: aBlCompositeSelection [
	self
		selection: aBlCompositeSelection
		from: self
]

{ #category : #'api - selection' }
GtTextualCoderViewModelPromised >> selection: aBlCompositeSelection from: aSourceObject [
	selection = aBlCompositeSelection
		ifTrue: [ ^ self ].
	
	selection := aBlCompositeSelection copy.
	self notifySelectionChanged: selection from: aSourceObject
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModelPromised >> shortcuts [
	"Return a collection of current editor shortcuts that are computed based on the coder add-ons and extra view-model add-ons.
	Do not modify the returned collection as it will be recomputed when ast or add-ons change; instead use #addShortcut:"
	<return: #Collection of: #BlBasicShortcut>
	
	^ shortcuts
]

{ #category : #'api - shortcuts' }
GtTextualCoderViewModelPromised >> shortcuts: aCollectionOfShortcuts [
	shortcuts = aCollectionOfShortcuts
		ifTrue: [ ^ self ].
	
	shortcuts := aCollectionOfShortcuts.
	self announce: GtTextualCoderViewModelShortcutsChanged new
]

{ #category : #'api - add-ons' }
GtTextualCoderViewModelPromised >> shouldAddOnsBeUpdated [
	"Return true if addons should be updated, false otherwise. When a Coder Model is attached to the corresponding Element
	that element should check if addons need to be updated and if it is the case start the update with the help of ${method:GtCoderModel>>#updateAddOnsFrom:}$"
	<return: #Boolean>

	^ addOnPromise
		ifNil: [ true ]
		ifNotNil: [ :theAddOns | theAddOns shouldBeUpdated ]
]

{ #category : #'api - text' }
GtTextualCoderViewModelPromised >> sourceText [
	<return: #BlText>

	^ self coderModel sourceText
]

{ #category : #'api - text' }
GtTextualCoderViewModelPromised >> sourceText: aNewSourceText from: aSourceObject	 synchronously: isSynchronous [
	self coderModel
		currentSourceText: aNewSourceText
		with: (GtCoderUpdateStrategy new
			source: aSourceObject;
			isSynchronous: isSynchronous)
]

{ #category : #'api - styled text' }
GtTextualCoderViewModelPromised >> styledText [
	<return: #Object>
	<propertyGetter: #styledText>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyGetterTemplate'>

	^ styledText
]

{ #category : #'api - styled text' }
GtTextualCoderViewModelPromised >> styledText: aNewStyledText [
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
GtTextualCoderViewModelPromised >> stylers [
	^ stylers
]

{ #category : #'api - stylers' }
GtTextualCoderViewModelPromised >> stylers: theStylers [
	stylers = theStylers
		ifTrue: [ ^ self ].

	stylers := theStylers.
	theStylers do: [ :eachStyler |
		(eachStyler respondsTo: #coderViewModel:)
			ifTrue: [ eachStyler coderViewModel: self ] ].
	
	"when stylers change we should reset the styled text, since there is no guarantee it will be a valid one"
	self unsetStyledText.
	self announce: GtTextualCoderViewModelStylersChanged new
]

{ #category : #'api - coder model' }
GtTextualCoderViewModelPromised >> subscribeToCoderModel [
	super subscribeToCoderModel.

	self coderModel weak
		when: GtCoderSourceCodeChanged
		send: #onSourceCodeChanged:
		to: self
]

{ #category : #'api - styled text' }
GtTextualCoderViewModelPromised >> unsetStyledText [
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
GtTextualCoderViewModelPromised >> unsubscribeFromCoderModel [
	super unsubscribeFromCoderModel.
	
	self coderModel unsubscribe: self
]
