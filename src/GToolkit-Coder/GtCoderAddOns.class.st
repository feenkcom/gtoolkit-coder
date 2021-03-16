Class {
	#name : #GtCoderAddOns,
	#superclass : #Object,
	#instVars : [
		'contextActions',
		'mainActions',
		'contextMenuActions',
		'shortcuts',
		'updateRequested'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderAddOns >> addAddOns: aGtCoderAddOns [
	self addShortcuts: aGtCoderAddOns shortcuts.
	self addMainActions: aGtCoderAddOns mainActions.
	self addContextActions: aGtCoderAddOns contextActions.
	self addContextMenuActions: aGtCoderAddOns contextMenuActions
]

{ #category : #'api - context actions' }
GtCoderAddOns >> addContextAction: aGtCoderAction [
	self
		updateActionList: #contextActions
		withAction: aGtCoderAction
		onlyNew: true
]

{ #category : #'api - context actions' }
GtCoderAddOns >> addContextAction: aTitleString icon: anIcon action: aBlock [
	self
		addContextAction: aTitleString
		icon: anIcon
		action: aBlock
		id: nil
]

{ #category : #'api - context actions' }
GtCoderAddOns >> addContextAction: aTitleString icon: anIcon action: aBlock id: aBlElementId [
	self
		updateActionList: #contextActions
		withAction: (GtCoderAction new
			title: aTitleString;
			icon: anIcon;
			action: aBlock;
			id: aBlElementId)
		onlyNew: true
]

{ #category : #'api - context actions' }
GtCoderAddOns >> addContextActions: aCollectionOfContextActions [
	aCollectionOfContextActions do: [ :eachContextAction | self addContextAction: eachContextAction ]
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuAction: aContextMenuAction [
	contextMenuActions add: aContextMenuAction
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuActions: aCollectionOfContextMenuActions [
	aCollectionOfContextMenuActions do: [ :eachContextMenuAction | self addContextMenuAction: eachContextMenuAction ]
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString action: aBlock [
	^ self
		addContextMenuItem: aString
		hover: nil
		leave: nil
		action: aBlock
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString hover: hoverBlock leave: leaveBlock action: aBlock [
	self
		addContextMenuItem: aString
		hover: hoverBlock
		leave: leaveBlock
		action: aBlock
		id: nil
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString hover: hoverBlock leave: leaveBlock action: aBlock id: aSymbol [
	| newAction |
	newAction := GtCoderContextMenuAction new
		title: aString;
		action: aBlock;
		hoverAction: hoverBlock;
		leaveAction: leaveBlock;
		name: aSymbol.
	self addContextMenuAction: newAction
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addDropDownAction: aString icon: anIcon stencil: aBlock [
	| newAction |
	newAction := GtCoderDropDownAction new
		title: aString;
		icon: anIcon;
		action: aBlock.
	mainActions add: newAction
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addDropDownWithPreviewAction: aString icon: anIcon action: actionBlock stencil: stencilBlock [
	| newAction |
	newAction := GtCoderDropDownWithPreviewAction new
		title: aString;
		icon: anIcon;
		changeAction: actionBlock;
		changeStencil: stencilBlock.
	mainActions add: newAction
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addMainAction: aGtCoderAction [
	self
		updateActionList: #mainActions
		withAction: aGtCoderAction
		onlyNew: true
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addMainAction: aString icon: anIcon action: aBlock [
	self
		updateActionList: #mainActions
		title: aString
		icon: anIcon
		action: aBlock
		onlyNew: true
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addMainAction: aTitleString icon: anIcon action: aBlock id: aNameSymbol [
	self
		updateActionList: #mainActions
		withAction: (GtCoderAction new
			title: aTitleString;
			icon: anIcon;
			action: aBlock;
			id: aNameSymbol)
		onlyNew: true
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addMainActions: aCollectionOfMainActions [
	aCollectionOfMainActions do: [ :eachMainAction | self addMainAction: eachMainAction ]
]

{ #category : #private }
GtCoderAddOns >> addOrUpdateShortcut: aBlShortcut to: aCollection [
	1 to: aCollection size do: [ :i | 
		(aCollection at: i) combination = aBlShortcut combination
			ifTrue: [ ^ aCollection at: i put: aBlShortcut ] ].
	aCollection add: aBlShortcut
]

{ #category : #'api - shortcuts' }
GtCoderAddOns >> addShortcut: aBlShortcut [
	self addOrUpdateShortcut: aBlShortcut to: shortcuts
]

{ #category : #'api - shortcuts' }
GtCoderAddOns >> addShortcuts: aCollectionOfShortcuts [
	aCollectionOfShortcuts do: [ :eachShortcut | self addShortcut: eachShortcut ]
]

{ #category : #'api - context actions' }
GtCoderAddOns >> contextActions [
	^ contextActions
]

{ #category : #'api - context menu' }
GtCoderAddOns >> contextMenuActions [
	^ contextMenuActions
]

{ #category : #changes }
GtCoderAddOns >> differenceWith: aGtCoderAddOns [
	^ Array streamContents: [ :aStream | self differenceWith: aGtCoderAddOns on: aStream ]
]

{ #category : #changes }
GtCoderAddOns >> differenceWith: aGtCoderAddOns on: aStream [
	self
		assert: [ self class = aGtCoderAddOns class ]
		description: [ 'Coder AddOns type must be identical to compute the difference' ].
		
	self mainActions = aGtCoderAddOns mainActions
		ifFalse: [ aStream nextPut: GtCoderAddOnsMainActionsDifference new ].
		
	self contextActions = aGtCoderAddOns contextActions
		ifFalse: [ aStream nextPut: GtCoderAddOnsContextActionsDifference new ].
		
	self contextMenuActions = aGtCoderAddOns contextMenuActions
		ifFalse: [ aStream nextPut: GtCoderAddOnsContextMenuDifference new ].
		
	self shortcuts = aGtCoderAddOns shortcuts
		ifFalse: [ aStream nextPut: GtCoderAddOnsShortcutsDifference new ].
]

{ #category : #'gt-extensions' }
GtCoderAddOns >> gtViewContextActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Context actions' translated;
		priority: 25;
		items: [ self contextActions ];
		column: 'Title'
			item: [ :anAction | anAction title ]
			text: [ :title | title ifNil: [ '' ] ];
		column: 'Action' item: [ :anAction | anAction action ]
]

{ #category : #'gt-extensions' }
GtCoderAddOns >> gtViewKeybindingsFor: aView [
	<gtView>
	self shortcuts ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Shortcuts' translated;
		priority: 10;
		items: [ self shortcuts asArray ];
		column: 'Name' item: [ :each | each name ifNil: [ each gtDisplayString ] ];
		column: 'Combination' item: [ :each | each combination gtDisplayString ]
]

{ #category : #'gt-extensions' }
GtCoderAddOns >> gtViewMainActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Main actions' translated;
		priority: 20;
		items: [ self mainActions ];
		column: 'Title'
			item: [ :anAction | anAction title ]
			text: [ :title | title ifNil: [ '' ] ];
		column: 'Action' 
			item: [ :anAction | anAction action ]
			weight: 3
]

{ #category : #'initialize-release' }
GtCoderAddOns >> initialize [
	super initialize.
	contextActions := OrderedCollection new.
	mainActions := OrderedCollection new.
	contextMenuActions := OrderedCollection new.
	shortcuts := OrderedCollection new.
	updateRequested := true
]

{ #category : #'api - main actions' }
GtCoderAddOns >> mainActions [
	^ mainActions
]

{ #category : #changes }
GtCoderAddOns >> markAsUpdated [
	updateRequested := false
]

{ #category : #copying }
GtCoderAddOns >> postCopy [
	super postCopy.
	contextActions := contextActions copy.
	mainActions := mainActions copy.
	contextMenuActions := contextMenuActions copy.
	shortcuts := shortcuts copy
]

{ #category : #changes }
GtCoderAddOns >> requestUpdate [
	"Mark coder addons as potentially needed to be updated"
	
	updateRequested := true
]

{ #category : #'api - shortcuts' }
GtCoderAddOns >> shortcuts [
	^ shortcuts
]

{ #category : #testing }
GtCoderAddOns >> shouldBeUpdated [
	"Return true if addons should be updated, false otherwise"
	<return: #Boolean>

	^ updateRequested
]

{ #category : #private }
GtCoderAddOns >> updateActionList: listSymbol title: aString icon: anIcon action: aBlock onlyNew: aBoolean [
	self
		updateActionList: listSymbol
		withAction: (GtCoderAction new
			title: aString;
			icon: anIcon;
			action: aBlock)
		onlyNew: aBoolean
]

{ #category : #private }
GtCoderAddOns >> updateActionList: listSymbol withAction: aGtCoderAction onlyNew: aBoolean [
	| index actions |

	actions := self perform: listSymbol.
	index := (1 to: actions size)
		detect: [ :i | (actions at: i) title = aGtCoderAction title ]
		ifNone: [ 0 ].

	(aBoolean and: [ index > 0 ])
		ifTrue: [ ^ self ].

	index = 0
		ifTrue: [ actions add: aGtCoderAction ]
		ifFalse: [ actions at: index put: aGtCoderAction ]
]
