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
		'protocolGroups'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

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
GtCoderNavigationProtocolsGroupedList >> createProtocolElement [
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
		aptitude: aLabelAptitude;
		addEventHandler: self createProtocolDropHandler
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createProtocolGroups [
	| classGroup instanceGroup |
	instanceGroup := BrGroup new
			domainObject: 'instance side';
			stream: #() asAsyncStream;
			itemStencil: [ self createProtocolElement ];
			itemDataBinder: [ :element :item | self bindProtocol: item toElement: element ];
			shouldShowWithoutItems: false.
	classGroup := instanceGroup copy domainObject: 'class side'.
	^ {instanceGroup.
		classGroup}
]

{ #category : #'private - instance creation' }
GtCoderNavigationProtocolsGroupedList >> createProtocolListContextMenuItemsFor: item [
	^ {(self createLabel: 'Remove ' description: item name)
			-> [ :elem | self removeProtocol: item name in: elem ].
		(self createLabel: 'Rename ' description: item name)
			-> [ :elem | self renameProtocol: item name in: elem ]}
]

{ #category : #initialization }
GtCoderNavigationProtocolsGroupedList >> initialize [
	super initialize.
	
	self
		padding: (BlInsets left: 5 right: 10);
		matchParent;
		headerElementStencil: [ BrLabel new
				beSmallSize;
				aptitude: (BrGlamorousLabelAptitude new foreground: Color gray) ];
		headerDataBinder: [ :label :each | label text: each domainObject asRopedText ].
	
	protocolGroups := self createProtocolGroups.
	self groups: protocolGroups
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
GtCoderNavigationProtocolsGroupedList >> removeProtocol: protocolName in: elem [
	| refactoring |
	refactoring := RBRemoveProtocolChange
			removeProtocolNamed: protocolName
			in: self selectedClass.
	^ self
		addPreviewButtonFor: refactoring
		to: elem
		cancelSelector: #updateProtocolList
]

{ #category : #'private - refactorings' }
GtCoderNavigationProtocolsGroupedList >> renameProtocol: protocolName in: elem [
	| refactoring edit |
	edit := BrEditableLabel new.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;   "Force the font to match the label font"
				background: Color transparent);
		text: protocolName;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				refactoring := GtRBRenameProtocolRefactoring
						renameProtocol: protocolName
						in: self selectedClass
						to: aWish text asString.
				edit switchToLabel.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelSelector: #updateProtocolList ];
		switchToEditor.
	edit requestFocus.
	elem removeChildren.
	elem addChild: edit
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
GtCoderNavigationProtocolsGroupedList >> updateProtocolListWith: instanceGtPharoProtocols and: classGtPharoProtocols [
	| instStream classStream |
	self deselectAll.
	instStream := instanceGtPharoProtocols
			asSortedCollection: [ :a :b | a name < b name ].

	classStream := classGtPharoProtocols
			asSortedCollection: [ :a :b | a name < b name ].

	protocolGroups
		with: {instStream.
				classStream}
		do: [ :grp :str | grp items: str ].

	self groups: protocolGroups
]
