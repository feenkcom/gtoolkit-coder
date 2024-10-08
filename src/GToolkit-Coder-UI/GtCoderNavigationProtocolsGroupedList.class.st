"
#Navigation protocol list

Displays a list of instance and class side protocols as a grouped list with an ability to drag and drop method on a protocol to move or copy a method there.
"
Class {
	#name : #GtCoderNavigationProtocolsGroupedList,
	#superclass : #BrGroupedList,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#instVars : [
		'protocolGroups',
		'navigationModel',
		'protocolToRename',
		'renamingEditor'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'private - refactorings' }
GtCoderNavigationProtocolsGroupedList >> addProtocolFrom: aProtocolEditor [
	self navigationModel
		selectedClassDo: [ :aClass | self addProtocolNamed: aProtocolEditor text asString trimmed in: aClass ].

	^ aProtocolEditor fireEvent: BrDropdownHideWish new
]

{ #category : #'private - refactorings' }
GtCoderNavigationProtocolsGroupedList >> addProtocolNamed: aProtocolName in: aClass [
	| refactoring |
	
	aProtocolName ifEmpty: [ ^ self ].
	
	refactoring := RBAddProtocolChange
		addProtocolNamed: aProtocolName
		in: aClass.
	
	refactoring execute
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> bindProtocol: item toElement: element [
	| itemText |
	
	itemText := item name asRopedText , ' ' asRopedText
			, (item methodSelectors size asRopedText
					foreground: self theme button disabledTextColor).

	element userData at: #protocol put: item.
	^ element text: itemText
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createAddProtocolButton [
	| aButtonStencil aPopUp |
	aButtonStencil := [
		BrButton new
			beTinySize;
			aptitude: (BrGlamorousButtonRectangularAptitude paddingScale: 0) + BrGlamorousButtonIconAptitude;
			icon: BrGlamorousVectorIcons add ] asStencil.

	aPopUp := BrGlamorousWithDropdownAptitude
			handle: aButtonStencil
			content: [ :aButton | self createNewProtocolForm ].

	^ aButtonStencil asElement
		addAptitude: (BrGlamorousButtonFlatExteriorAptitude new
			backgroundPaint: (Color gray alpha: 0.1));
		addAptitude: BrGlamorousButtonWithLabelTooltipAptitude;
		addAptitude: aPopUp;
		label: 'Add new protocol'
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createNewProtocolForm [
	| aContainer aProtocolEditor aDefaultText aProtocolCompleter anAcceptButton |
	aDefaultText := '' asRopedText
			attribute: (BrGhostTextAttribute
					for: ('new protocol name' asRopedText glamorousFormEditorCodeFontAndSize
							foreground: Color lightGray)).

	aContainer := BrHorizontalPane new
			padding: (BlInsets
					top: 6
					right: 2
					bottom: 6
					left: 2);
			cellSpacing: 6;
			alignCenterLeft;
			fitContent.

	aProtocolEditor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude new glamorousRegularSmallSize
					+ BrGlamorousInputFieldSpacingAptitude;
			beMode: BrTextEditorEditableSingleLineMode new;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
			vFitContent;
			hFitContent;
			constraintsDo: [ :c | c minWidth: 150 ];
			text: aDefaultText;
			requestFocus.

	aProtocolCompleter := GtCompletionController
			on: aProtocolEditor
			strategy: GtMethodProtocolCompletionStrategy new.

	aProtocolCompleter install.

	aProtocolEditor
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination escape;
				action: [ :anEvent | aProtocolEditor fireEvent: BrDropdownHideWish new ]).

	aProtocolEditor
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ :anEvent | self addProtocolFrom: aProtocolEditor ]).

	aContainer addChild: aProtocolEditor.

	anAcceptButton := BrButton new
			beSmallSize;
			aptitude: (BrGlamorousButtonRectangularAptitude paddingScale: 0.5)
					+ BrGlamorousButtonIconAptitude
					+ (BrGlamorousButtonFlatExteriorAptitude new
							backgroundPaint: (Color gray alpha: 0.1))
					+ BrGlamorousButtonWithLabelTooltipAptitude;
			icon: BrGlamorousVectorIcons accept;
			label: 'Add protocol';
			action: [ self addProtocolFrom: aProtocolEditor ].

	aContainer addChild: anAcceptButton.

	^ aContainer
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createProtocolDropHandler [
	^ BlDropHandler new
		acceptDomainObjectsSuchThat: [ :anObject | anObject isCompiledMethod ];
		whenDroppedDo: [ :anItemsDroppedEvent | self onDropCompiledMethodsOnProtocol: anItemsDroppedEvent ];
		whenDragEnteredDo: [ :anItemsDraggedOverEvent | 
			anItemsDraggedOverEvent currentTarget
				effect: (BlOverlayAboveEffect new paint: (Color gray alpha: 0.2)) ];
		whenDragLeftDo: [ :anItemsLeftEvent | anItemsLeftEvent currentTarget effect: BlNullEffect new ]
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createProtocolGroupHeader [
	^ BrHorizontalPane new
		alignCenterLeft;
		hMatchParent;
		vFitContent;
		addChild: (BrLabel new beSmallSize
				padding: (BlInsets top: 2 bottom: 2);
				aptitude: (BrGlamorousLabelAptitude new foreground: Color gray));
		addChild: self createAddProtocolButton;
		yourself
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createProtocolGroups [
	| virtualGroup instanceGroup classGroup |
	
	virtualGroup := BrGroup new
			domainObject: 'virtual';
			items: #();
			itemType: [ :aTypeFactory :eachPharoProtocol |
				eachPharoProtocol = protocolToRename
					ifTrue: [ #rename ]
					ifFalse: [ #display ] ];
			itemStencil: [ :anItemType |
				anItemType = #rename
					ifTrue: [
						BrFrame new
							id: #'coder--protocol-rename';
							hMatchParent;
							vFitContent ]
					ifFalse: [ self createProtocolLabelElement ] ];
			itemDataBinder: [ :element :item |
				element id asSymbol = #'coder--protocol-rename'
					ifTrue: [
						element removeChildren.
						renamingEditor ifNil: [ renamingEditor := self createRenameProtocolForm: item ].
						element addChild: renamingEditor ]
					ifFalse: [ self bindProtocol: item toElement: element ] ];
			shouldShowWithoutItems: false.
	
	instanceGroup := virtualGroup copy domainObject: 'instance side'.
	classGroup := virtualGroup copy domainObject: 'class side'.
	^ {
		virtualGroup.
		instanceGroup.
		classGroup }
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createProtocolLabelElement [
	"An element that represents a protocol within a list of protocols"
	<return: #BlElement>
	| aLabelAptitude |

	aLabelAptitude := BrGlamorousLabelAptitude new
			padding: (BlInsets
					top: 2
					bottom: 2
					left: 1
					right: 1);
			add: BrGlamorousListItemAptitude;
			add: (BrGlamorousWithContextMenuAptitude
					content: [ :aWidget | 
						GtCoderNavigationContextMenuContent new
							items: (self createProtocolListContextMenuItemsFor: (aWidget userData at: #protocol)) ]).

	^ BrLabel new
		hMatchParent;
		vFitContent;
		beSmallSize;
		beFocusable;
		aptitude: aLabelAptitude;
		addEventHandler: self createProtocolDropHandler
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createProtocolListContextMenuItemsFor: aPharoProtocol [
	^ Array
		streamContents: [ :aStream | 
			"aPharoProtocol canBeRemoved
				ifTrue: [ aStream
						nextPut: (self createLabel: 'Remove ' description: aPharoProtocol name)
								-> [ :elem | self removeProtocol: aPharoProtocol in: elem ] ]."

			aPharoProtocol canBeRenamed
				ifTrue: [ aStream
						nextPut: (self createLabel: 'Rename ' description: aPharoProtocol name)
								-> [ :elem | self requestRenameProtocol: aPharoProtocol ] ] ]
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createRenameProtocolForm: aPharoProtocol [
	| aContainer aProtocolEditor aDefaultText aProtocolCompleter anAcceptButton aCancelButton |

	aDefaultText := aPharoProtocol name asRopedText
			attribute: (BrGhostTextAttribute
					for: ('protocol name' asRopedText glamorousFormEditorCodeFontAndSize
							foreground: Color lightGray)).

	aContainer := BrHorizontalPane new
			alignCenterLeft;
			hMatchParent;
			vFitContent.

	aProtocolEditor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude new glamorousRegularSmallSize
					+ BrGlamorousInputFieldSpacingAptitude;
			beMode: BrTextEditorEditableSingleLineMode new;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
			padding: (BlInsets top: 2 left: 5 bottom: 2 right: 5);
			hMatchParent;
			vFitContent;
			text: aDefaultText;
			requestFocus.

	aProtocolEditor navigator moveToEnd apply.
	aProtocolEditor selecter all select.

	aProtocolCompleter := GtCompletionController
			on: aProtocolEditor
			strategy: GtMethodProtocolCompletionStrategy new.

	aProtocolCompleter install.

	aProtocolEditor
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination escape;
				action: [ :anEvent | self privateEndRenameProtocol ]).

	aProtocolEditor
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ :anEvent | self privateRenameProtocol: aPharoProtocol from: aProtocolEditor ]).

	aContainer addChild: aProtocolEditor.

	anAcceptButton := BrButton new
			beTinySize;
			margin: (BlInsets left: 5 right: 2);
			aptitude: (BrGlamorousButtonRectangularAptitude paddingScale: 0.5)
					+ BrGlamorousButtonIconAptitude
					+ (BrGlamorousButtonFlatExteriorAptitude new
							backgroundPaint: (Color gray alpha: 0.1))
					+ BrGlamorousButtonWithLabelTooltipAptitude;
			icon: BrGlamorousVectorIcons accept;
			label: 'Rename protocol';
			action: [ self privateRenameProtocol: aPharoProtocol from: aProtocolEditor ].

	aCancelButton := BrButton new
			beTinySize;
			margin: (BlInsets left: 2 right: 2);
			aptitude: (BrGlamorousButtonRectangularAptitude paddingScale: 0.5)
					+ BrGlamorousButtonIconAptitude
					+ (BrGlamorousButtonFlatExteriorAptitude new
							backgroundPaint: (Color gray alpha: 0.1))
					+ BrGlamorousButtonWithLabelTooltipAptitude;
			icon: BrGlamorousVectorIcons cancel;
			label: 'Cancel';
			action: [ self privateEndRenameProtocol ].

	aContainer addChild: anAcceptButton.
	aContainer addChild: aCancelButton.

	^ aContainer
]

{ #category : #'api - list' }
GtCoderNavigationProtocolsGroupedList >> deselectProtocol [
	self deselectAll
]

{ #category : #'private - selection' }
GtCoderNavigationProtocolsGroupedList >> detectProtocolIndex: aGtPharoProtocol inGroups: aCollectionOfArrayOfProtocols [
	| aSelectionIndex |
	
	aGtPharoProtocol ifNil: [ ^ 0 ].
	
	aSelectionIndex := 0.
	
	aCollectionOfArrayOfProtocols detect: [ :eachGroup |
		eachGroup
			ifEmpty: [ false ]
			ifNotEmpty: [
				| anIndexInGroup |
				"add 1 for the header"
				aSelectionIndex := aSelectionIndex + 1.
				anIndexInGroup := eachGroup
					detectIndex: [ :eachProtocol | eachProtocol = aGtPharoProtocol ]
					ifNone:  [ 0 ].
				
				anIndexInGroup > 0
					ifTrue: [
						aSelectionIndex := aSelectionIndex + anIndexInGroup.
						true ]
					ifFalse: [
						aSelectionIndex := aSelectionIndex + eachGroup size.
						false
					]
			].
	]
	ifNone: [ ^ 0 ].
	
	^ aSelectionIndex
]

{ #category : #initialization }
GtCoderNavigationProtocolsGroupedList >> initialize [
	super initialize.

	self
		padding: (BlInsets left: 5 right: 10);
		matchParent;
		headerElementStencil: [ self createProtocolGroupHeader ];
		headerDataBinder: [ :header :each | 
			each domainObject = 'virtual'
				ifTrue: [ header children second visibility: BlVisibility gone ]
				ifFalse: [ header children second visibility: BlVisibility visible ].
			header children first text: each domainObject asRopedText ].

	self when: BrSelectionChanged do: [ self privateEndRenameProtocol ].

	protocolGroups := self createProtocolGroups.
	self groups: protocolGroups
]

{ #category : #accessing }
GtCoderNavigationProtocolsGroupedList >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtCoderNavigationProtocolsGroupedList >> navigationModel: anObject [
	navigationModel := anObject
]

{ #category : #'private - refactorings' }
GtCoderNavigationProtocolsGroupedList >> onDropCompiledMethodsOnProtocol: anItemsDroppedEvent [
	| aProtocol aProtocolClass aModel compositeChange|
	
	aProtocol := anItemsDroppedEvent currentTarget userData at: #protocol.
	aProtocolClass := aProtocol protocolClass.
	
	aModel := RBNamespace new.
	
	anItemsDroppedEvent items do: [ :eachDragItem |
		| aTargetProtocolClass eachCompiledMethod |
		
		eachCompiledMethod := eachDragItem domainObject.
		aTargetProtocolClass := eachCompiledMethod isClassSide
			ifTrue: [ aProtocolClass classSide ]
			ifFalse: [ aProtocolClass instanceSide ].
		
		eachCompiledMethod methodClass = aTargetProtocolClass
			ifTrue: [
				aModel
					selector: eachCompiledMethod selector
					in: aTargetProtocolClass
					classified: aProtocol name ]
			ifFalse: [
				eachDragItem shouldCopy
					ifFalse: [
						aModel
							removeMethod: eachCompiledMethod selector
							from: eachCompiledMethod methodClass ].
				aModel
					compile: eachCompiledMethod sourceCode
					in: aTargetProtocolClass
					classified: aProtocol name ] ].
	
	compositeChange := aModel changes.
	compositeChange execute
]

{ #category : #'private - refactorings' }
GtCoderNavigationProtocolsGroupedList >> privateEndRenameProtocol [
	"Removes protocol editing UI"

	protocolToRename := nil.
	renamingEditor := nil.
	self dispatchEvent: (BrItemsProviderItemsChangedEvent new
		viewModel: self viewModel;
		isSynchronous: true)
]

{ #category : #'private - refactorings' }
GtCoderNavigationProtocolsGroupedList >> privateRenameProtocol: aPharoProtocol from: aProtocolEditor [
	"Performs a rename protocol action and updates UI removing a protocol editor"
	| aNewName |

	aNewName := aProtocolEditor text asString trimmed.
	
	self navigationModel
		renameProtocol: aPharoProtocol
		to: aNewName.

	self privateEndRenameProtocol
]

{ #category : #'private - refactorings' }
GtCoderNavigationProtocolsGroupedList >> removeProtocol: aGtPharoProtocol in: elem [
	| refactoring |
	refactoring := RBRemoveProtocolChange
			removeProtocolNamed: aGtPharoProtocol name
			in: aGtPharoProtocol protocolClass.
	^ self
		addPreviewButtonFor: refactoring
		to: elem
		cancelSelector: #updateProtocolList
]

{ #category : #'private - refactorings' }
GtCoderNavigationProtocolsGroupedList >> requestRenameProtocol: aGtPharoProtocol [
	"An entrance point to the rename protocol action.
	Presents a UI to rename a given protocol"

	protocolToRename := aGtPharoProtocol.
	renamingEditor := nil.
	self dispatchEvent: ((BrItemsProviderItemsChangedEvent new
			viewModel: self viewModel;
			isSynchronous: true))
]

{ #category : #'api - list' }
GtCoderNavigationProtocolsGroupedList >> selectProtocol: aGtPharoProtocol [
	| selectionIndex |

	selectionIndex := self
		detectProtocolIndex: aGtPharoProtocol
		inGroups: (protocolGroups collect: [ :eachGroup | eachGroup itemsProvider currentItems ]).

	selectionIndex > 0
		ifTrue: [ self selectOne: selectionIndex ]
		ifFalse: [ self deselectAll ]
]

{ #category : #'api - list' }
GtCoderNavigationProtocolsGroupedList >> selectedProtocol [
	<return: #GtPharoProtocol or: nil>
	| theIndices anIndex |
	
	theIndices := self selectedIndices ifEmpty: [ ^nil].
	anIndex := theIndices first.
	(anIndex between: 1 and: self viewModel entityCount)
		ifFalse: [ ^ nil ].
	^ (self viewModel entityAt: anIndex) value object
]

{ #category : #'api - list' }
GtCoderNavigationProtocolsGroupedList >> updateProtocolListWith: theGtPharoProtocols [
	| virtualStream instStream classStream virtualGtPharoProtocols instanceGtPharoProtocols classGtPharoProtocols groupItems |
	
	virtualGtPharoProtocols := theGtPharoProtocols
		select: [ :eachPharoProtocol | eachPharoProtocol isVirtualProtocol ].
	
	instanceGtPharoProtocols := theGtPharoProtocols
		select: [ :eachPharoProtocol | eachPharoProtocol isVirtualProtocol not and: [ eachPharoProtocol isClassSide not ] ].

	classGtPharoProtocols := theGtPharoProtocols
		select: [ :eachPharoProtocol | eachPharoProtocol isVirtualProtocol not and: [ eachPharoProtocol isClassSide ] ].
	
	virtualStream := virtualGtPharoProtocols
			asSortedCollection: [ :a :b | a name < b name ].
	
	instStream := instanceGtPharoProtocols
			asSortedCollection: [ :a :b | a name < b name ].

	classStream := classGtPharoProtocols
			asSortedCollection: [ :a :b | a name < b name ].

	groupItems := {
			virtualStream.
			instStream.
			classStream}.

	protocolGroups
		with: {
			virtualStream.
			instStream.
			classStream}
		do: [ :grp :str | grp items: str ].

	self groups: protocolGroups
]
