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
	| aLabel aLabelAptitude |
	aLabel := BrLabel new.

	aLabelAptitude := BrGlamorousLabelAptitude new
			padding: (BlInsets
					top: 2
					bottom: 2
					left: 1
					right: 1);
			add: BrGlamorousListItemAptitude;
			add: (BrGlamorousWithExplicitContextMenuAptitude
					itemsWithAnchorActions: [ (self createProtocolListContextMenuItemsFor: (aLabel userData at: #protocol)) ]).

	^ aLabel
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
	^ GtCoderProtocolsGroupRenameEditor new
		itemToRename: aPharoProtocol;
		renameAction: [ :anItemToRename :aNewName |
			self navigationModel
				renameProtocol: anItemToRename
				to: aNewName ];
		endRenameAction: [ self privateEndRenameProtocol ]
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

	self when: BrSelectionChanged do: [
		self privateEndRenameProtocol.
		self onProtocolListSelectionChanged ].

	protocolGroups := self createProtocolGroups.
	self groups: protocolGroups
]

{ #category : #accessing }
GtCoderProtocolsGroupedListElement >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtCoderProtocolsGroupedListElement >> navigationModel: anObject [
	navigationModel == anObject
		ifTrue: [ ^ self ].

	self unsubscribeFromNavigationModel.
	navigationModel := anObject.
	self subscribeToNavigationModel.
	
	self updateProtocolsList
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

{ #category : #'event handling' }
GtCoderProtocolsGroupedListElement >> onProtocolDeselected: anAnnouncement [
	self deselectProtocol
]

{ #category : #'event handling' }
GtCoderProtocolsGroupedListElement >> onProtocolListSelectionChanged [
	| aSelectedItem |
	aSelectedItem := self selectedProtocol.
	aSelectedItem ifNil: [ ^ self ].
	
	self navigationModel
		ifNotNil: [ :aModel | aModel selectProtocol: aSelectedItem source: self ]
]

{ #category : #'event handling' }
GtCoderProtocolsGroupedListElement >> onProtocolSelected: anAnnouncement [
	self selectProtocol: anAnnouncement protocol
]

{ #category : #'event handling' }
GtCoderProtocolsGroupedListElement >> onProtocolsToShowChanged: anAnnouncement [
	self updateProtocolsList
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

{ #category : #'private - subscriptions' }
GtCoderProtocolsGroupedListElement >> subscribeToNavigationModel [
	| subscriptions |

	subscriptions := {
		GtCoderNavigationProtocolsToShowChanged -> #onProtocolsToShowChanged:.
		GtCoderNavigationProtocolSelected -> #onProtocolSelected:.
		GtCoderNavigationProtocolDeselected -> #onProtocolDeselected:.
	}.

	subscriptions
		do: [ :sub | 
			navigationModel weak
				when: sub key
				send: sub value
				to: self ]
]

{ #category : #subscriptions }
GtCoderProtocolsGroupedListElement >> unsubscribeFromNavigationModel [
	navigationModel ifNotNil: [ :aModel | aModel unsubscribe: self ]
]

{ #category : #'private - updating' }
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

{ #category : #'private - updating' }
GtCoderProtocolsGroupedListElement >> updateProtocolsList [
	self updateProtocolListWith: self navigationModel protocolsToShow.

	self navigationModel selectedProtocol
		ifNil: [ self deselectProtocol ]
		ifNotNil: [ :aProtocol | self selectProtocol: aProtocol ]
]
