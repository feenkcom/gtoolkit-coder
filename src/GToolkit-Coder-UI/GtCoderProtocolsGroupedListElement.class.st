"
#Navigation protocol list

Displays a list of instance and class side protocols as a grouped list with an ability to drag and drop method on a protocol to move or copy a method there.


"
Class {
	#name : #GtCoderProtocolsGroupedListElement,
	#superclass : #BrGroupedList,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#instVars : [
		'protocolGroups',
		'navigationModel',
		'protocolToRename',
		'renamingEditor'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'private - refactorings' }
GtCoderProtocolsGroupedListElement >> autoCategorizeProtocol: aPharoProtocol [
	| classifier allMethods|
	
	allMethods := aPharoProtocol methodSelectors collect: [ :selector|
		aPharoProtocol protocolClass >> selector ].
	
	classifier := MethodClassifier new.
	classifier classifyAll: allMethods
]

{ #category : #'private - instance creation' }
GtCoderProtocolsGroupedListElement >> bindProtocol: item toElement: element [
	| itemText |
	
	itemText := item name asRopedText , ' ' asRopedText
			, (item allMethods size asRopedText
					foreground: self theme button disabledTextColor).

	element userData at: #protocol put: item.
	^ element text: itemText
]

{ #category : #'private - instance creation' }
GtCoderProtocolsGroupedListElement >> createProtocolDropHandler [
	^ BlDropHandler new
		acceptDomainObjectsSuchThat: [ :anObject | anObject isCompiledMethod ];
		whenDroppedDo: [ :anItemsDroppedEvent | self onDropCompiledMethodsOnProtocol: anItemsDroppedEvent ];
		whenDragEnteredDo: [ :anItemsDraggedOverEvent | 
			anItemsDraggedOverEvent currentTarget
				effect: (BlOverlayAboveEffect new paint: (Color gray alpha: 0.2)) ];
		whenDragLeftDo: [ :anItemsLeftEvent | anItemsLeftEvent currentTarget effect: BlNullEffect new ]
]

{ #category : #'private - instance creation' }
GtCoderProtocolsGroupedListElement >> createProtocolGroups [
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
GtCoderProtocolsGroupedListElement >> createProtocolLabelElement [
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
GtCoderProtocolsGroupedListElement >> createProtocolListContextMenuItemsFor: aPharoProtocol [
	^ Array
		streamContents: [ :aStream | 
			aPharoProtocol name = Protocol unclassified
				ifTrue: [
					aStream
						nextPut: (self createLabel: 'Auto-categorize methods' description: '')
								-> [ :elem | self autoCategorizeProtocol: aPharoProtocol ] ].
								
			aPharoProtocol canBeRenamed
				ifTrue: [ aStream
						nextPut: (self createLabel: 'Rename ' description: aPharoProtocol name)
								-> [ :elem | self requestRenameProtocol: aPharoProtocol ] ].
			
			aPharoProtocol canBeRemoved
				ifTrue: [ aStream
						nextPut: (self createLabel: 'Remove ' description: aPharoProtocol name)
								-> [ :elem | self removeProtocol: aPharoProtocol in: elem ] ].
		
		]
]

{ #category : #'private - instance creation' }
GtCoderProtocolsGroupedListElement >> createRenameProtocolForm: aPharoProtocol [
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
GtCoderProtocolsGroupedListElement >> deselectProtocol [
	self deselectAll
]

{ #category : #'private - selection' }
GtCoderProtocolsGroupedListElement >> detectProtocolIndex: aGtPharoProtocol inGroups: aCollectionOfArrayOfProtocols [
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
GtCoderProtocolsGroupedListElement >> initialize [
	super initialize.

	self
		padding: (BlInsets left: 5 right: 10);
		matchParent;
		headerElementStencil: [ GtCoderProtocolsGroupHeaderElement new ];
		headerDataBinder: [ :header :each |
			header
				protocolsGroupName: each domainObject
				targetClass: self navigationModel selectedClass ].

	self when: BrSelectionChanged do: [ self privateEndRenameProtocol ].

	protocolGroups := self createProtocolGroups.
	self groups: protocolGroups
]

{ #category : #accessing }
GtCoderProtocolsGroupedListElement >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtCoderProtocolsGroupedListElement >> navigationModel: anObject [
	navigationModel := anObject
]

{ #category : #'private - refactorings' }
GtCoderProtocolsGroupedListElement >> onDropCompiledMethodsOnProtocol: anItemsDroppedEvent [
	| aProtocol aProtocolClass aModel compositeChange |
	aProtocol := anItemsDroppedEvent currentTarget userData at: #protocol.
	aProtocolClass := aProtocol protocolClass.

	aModel := RBNamespace new.

	anItemsDroppedEvent items
		do: [ :eachDragItem | 
			| aTargetProtocolClass eachCompiledMethod |
			eachCompiledMethod := eachDragItem domainObject.
			aTargetProtocolClass := aProtocolClass.

			eachCompiledMethod methodClass = aTargetProtocolClass
				ifTrue: [
					aProtocol name = Protocol unclassified
						ifTrue: [
							"To circumvent Pharo's behavior we first
							remove a method and then add it as unclassified back"
							aModel
								removeMethod: eachCompiledMethod selector
								from: eachCompiledMethod methodClass.

							aModel
								compile: eachCompiledMethod sourceCode
								in: aTargetProtocolClass
								classified: aProtocol name ]
						ifFalse: [
							"Pharo doesn't allow to change method's protocol
							to `as yet unclassified` if that method's was
							already classified"
							aModel
								selector: eachCompiledMethod selector
								in: aTargetProtocolClass
								classified: aProtocol name ] ]
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
GtCoderProtocolsGroupedListElement >> privateEndRenameProtocol [
	"Removes protocol editing UI"

	protocolToRename := nil.
	renamingEditor := nil.
	self dispatchEvent: (BrItemsProviderItemsChangedEvent new
		viewModel: self viewModel;
		isSynchronous: true)
]

{ #category : #'private - refactorings' }
GtCoderProtocolsGroupedListElement >> privateRenameProtocol: aPharoProtocol from: aProtocolEditor [
	"Performs a rename protocol action and updates UI removing a protocol editor"
	| aNewName |

	aNewName := aProtocolEditor text asString trimmed.
	
	self navigationModel
		renameProtocol: aPharoProtocol
		to: aNewName.

	self privateEndRenameProtocol
]

{ #category : #'private - refactorings' }
GtCoderProtocolsGroupedListElement >> removeProtocol: aGtPharoProtocol in: elem [
	| refactoring |
	refactoring := RBRemoveProtocolChange
			removeProtocolNamed: aGtPharoProtocol name
			in: aGtPharoProtocol protocolClass.
	refactoring execute
]

{ #category : #'private - refactorings' }
GtCoderProtocolsGroupedListElement >> requestRenameProtocol: aGtPharoProtocol [
	"An entrance point to the rename protocol action.
	Presents a UI to rename a given protocol"

	protocolToRename := aGtPharoProtocol.
	renamingEditor := nil.
	self dispatchEvent: ((BrItemsProviderItemsChangedEvent new
			viewModel: self viewModel;
			isSynchronous: true))
]

{ #category : #'api - list' }
GtCoderProtocolsGroupedListElement >> selectProtocol: aGtPharoProtocol [
	| selectionIndex |

	selectionIndex := self
		detectProtocolIndex: aGtPharoProtocol
		inGroups: (protocolGroups collect: [ :eachGroup | eachGroup itemsProvider currentItems ]).

	selectionIndex > 0
		ifTrue: [ self selectOne: selectionIndex ]
		ifFalse: [ self deselectAll ]
]

{ #category : #'api - list' }
GtCoderProtocolsGroupedListElement >> selectedProtocol [
	<return: #GtPharoProtocol or: nil>
	| theIndices anIndex |
	
	theIndices := self selectedIndices ifEmpty: [ ^nil].
	anIndex := theIndices first.
	(anIndex between: 1 and: self viewModel entityCount)
		ifFalse: [ ^ nil ].
	^ (self viewModel entityAt: anIndex) value object
]

{ #category : #'api - list' }
GtCoderProtocolsGroupedListElement >> updateProtocolListWith: theGtPharoProtocols [
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
