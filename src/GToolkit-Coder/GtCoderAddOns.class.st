Class {
	#name : #GtCoderAddOns,
	#superclass : #Object,
	#instVars : [
		'contextActions',
		'mainActions',
		'contextMenuActions',
		'shortcuts',
		'updateRequested',
		'previews'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderAddOns >> addAddOns: aGtCoderAddOns [
	self addShortcuts: aGtCoderAddOns shortcuts.
	self addMainActions: aGtCoderAddOns mainActions.
	self addContextActions: aGtCoderAddOns contextActions.
	self addContextMenuActions: aGtCoderAddOns contextMenuActions.
	self addPreviews: aGtCoderAddOns previews.
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
GtCoderAddOns >> addContextAction: aTitleString icon: anIcon action: aBlock id: aBlElementId allowPrimaryClick: aBoolean [
	self
		updateActionList: #contextActions
		withAction: (GtCoderAction new
				title: aTitleString;
				icon: anIcon;
				action: aBlock;
				id: aBlElementId;
				allowPrimaryClick: aBoolean)
		onlyNew: true
]

{ #category : #'api - context actions' }
GtCoderAddOns >> addContextActions: aCollectionOfContextActions [
	aCollectionOfContextActions do: [ :eachContextAction | self addContextAction: eachContextAction ]
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addContextDropDownWithPreviewAction: aString icon: anIcon action: actionBlock stencil: stencilBlock [
	self
		updateActionList: #contextActions
		withAction: (GtCoderDropDownWithPreviewAction new
			title: aString;
			icon: anIcon;
			changeAction: actionBlock;
			changeStencil: stencilBlock)
		onlyNew: true
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
GtCoderAddOns >> addContextMenuItem: aString action: aBlock id: aSymbol [
	^ self
		addContextMenuItem: aString
		hover: nil
		leave: nil
		action: aBlock
		id: aSymbol
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString action: aBlock id: aSymbol shortcutKey: shortcutString [
	^ self
		addContextMenuItem: aString
		hover: nil
		leave: nil
		action: aBlock
		id: aSymbol
		shortcutKey: shortcutString
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString action: aBlock shortcutKey: shortcut [
	^ self
		addContextMenuItem: aString
		hover: nil
		leave: nil
		action: aBlock
		shortcutKey: shortcut
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString group: menuGroup action: aBlock id: aSymbol [
	^ self
		addContextMenuItem: aString
		group: menuGroup
		hover: nil
		leave: nil
		action: aBlock
		id: aSymbol
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString group: menuGroup action: aBlock id: aSymbol shortcutKey: shortcutString [
	^ self
		addContextMenuItem: aString
		group: menuGroup
		hover: nil
		leave: nil
		action: aBlock
		id: aSymbol
		shortcutKey: shortcutString
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString group: menuGroup hover: hoverBlock leave: leaveBlock action: aBlock [
	<return: #GtCoderContextMenuAction>
	^ self
		addContextMenuItem: aString
		group: menuGroup
		hover: hoverBlock
		leave: leaveBlock
		action: aBlock
		id: nil
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString group: menuGroup hover: hoverBlock leave: leaveBlock action: aBlock id: aSymbol [
	| newAction |
	newAction := GtCoderContextMenuAction new
		title: aString;
		group: menuGroup;
		action: aBlock;
		hoverAction: hoverBlock;
		leaveAction: leaveBlock;
		id: aSymbol.
	self addContextMenuAction: newAction.
	^ newAction
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString group: menuGroup hover: hoverBlock leave: leaveBlock action: aBlock id: aSymbol shortcutKey: shortcutString [
	| newAction |
	newAction := GtCoderContextMenuAction new
		title: aString;
		group: menuGroup;
		action: aBlock;
		hoverAction: hoverBlock;
		leaveAction: leaveBlock;
		id: aSymbol;
		shortcutKey: shortcutString.
	self addContextMenuAction: newAction.
	^ newAction
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString group: menuGroup hover: hoverBlock leave: leaveBlock action: aBlock shortcutKey: shortcutString [
	self
		addContextMenuItem: aString
		group: menuGroup
		hover: hoverBlock
		leave: leaveBlock
		action: aBlock
		id: nil
		shortcutKey: shortcutString
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString hover: hoverBlock leave: leaveBlock action: aBlock [
	<return: #GtCoderContextMenuAction>
	^ self
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
		id: aSymbol.
	self addContextMenuAction: newAction.
	^ newAction
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString hover: hoverBlock leave: leaveBlock action: aBlock id: aSymbol shortcutKey: shortcutString [
	| newAction |
	newAction := GtCoderContextMenuAction new
		title: aString;
		action: aBlock;
		hoverAction: hoverBlock;
		leaveAction: leaveBlock;
		id: aSymbol;
		shortcutKey: shortcutString.
	self addContextMenuAction: newAction.
	^ newAction
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addContextMenuItem: aString hover: hoverBlock leave: leaveBlock action: aBlock shortcutKey: shortcutString [
	self
		addContextMenuItem: aString
		hover: hoverBlock
		leave: leaveBlock
		action: aBlock
		id: nil
		shortcutKey: shortcutString
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addDropDownAction: aString icon: anIcon content: aBlock [
	| newAction |
	newAction := GtCoderDropDownMenuAction new
		title: aString;
		icon: anIcon;
		content: aBlock.
	mainActions add: newAction.
	^ newAction
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addDropDownAction: aString icon: anIcon items: aBlock [
	| newAction |
	newAction := GtCoderDropDownMenuAction new
		title: aString;
		icon: anIcon;
		items: aBlock.
	mainActions add: newAction.
	^ newAction
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addDropDownAction: aString icon: anIcon menu: aBlock [
	| newAction |
	newAction := GtCoderDropDownMenuAction new
		title: aString;
		icon: anIcon;
		menu: aBlock.
	mainActions add: newAction.
	^ newAction
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addDropDownAction: aString icon: anIcon stencil: aBlock [
	"Use #GtCoderAddOns>>#addDropDownAction:icon:content: instead."

	| newAction |
	newAction := GtCoderDropDownAction new
			title: aString;
			icon: anIcon;
			stencil: aBlock.
	mainActions add: newAction.
	^ newAction
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addDropDownWithPreviewAction: aString icon: anIcon action: actionBlock stencil: stencilBlock [
	| newAction |
	newAction := GtCoderDropDownWithPreviewAction new
		title: aString;
		icon: anIcon;
		changeAction: actionBlock;
		changeStencil: stencilBlock.
	mainActions add: newAction.
	^ newAction
]

{ #category : #'api - main actions' }
GtCoderAddOns >> addDropDownWithPreviewAction: aString icon: anIcon action: actionBlock stencil: stencilBlock id: anId [
	| newAction |
	newAction := GtCoderDropDownWithPreviewAction new
		title: aString;
		icon: anIcon;
		changeAction: actionBlock;
		changeStencil: stencilBlock;
		id: anId.
	mainActions add: newAction.
	^ newAction
]

{ #category : #'api - context menu' }
GtCoderAddOns >> addExplicitContextMenu: aString block: aBlock [
	| newAction |
	newAction := GtCoderExplicitContextMenuItemAction new
		title: aString;
		menuItem: aBlock.
	self addContextMenuAction: newAction.
	^ newAction
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

{ #category : #'api - previews' }
GtCoderAddOns >> addPreview: aCoderPreview [
	self previews add: aCoderPreview
		
]

{ #category : #'api - previews' }
GtCoderAddOns >> addPreview: aString stencil: aStencil [
	self addPreview: (GtCoderPreview new
		id: aString;
		title: aString;
		stencil: [ BrFrame new fitContent ];
		dataBinder: [ :anElement :aViewModel | anElement removeChildren; addChild: aStencil asStencil asElement ])
]

{ #category : #'api - previews' }
GtCoderAddOns >> addPreview: aString stencil: aStencil dataBinder: aCoderPreviewDataBinder [
	self addPreview: (GtCoderPreview new
		id: aString;
		title: aString;
		stencil: aStencil;
		dataBinder: aCoderPreviewDataBinder)
]

{ #category : #'api - previews' }
GtCoderAddOns >> addPreviews: aCollectionOfPreviews [

	aCollectionOfPreviews do: [ :eachPreview | 
		self addPreview: eachPreview ]
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
	<return: #Collection of: #GtCoderContextMenuAction>
	^ contextMenuActions
]

{ #category : #'initialize-release' }
GtCoderAddOns >> initialize [
	super initialize.
	contextActions := OrderedCollection new.
	mainActions := OrderedCollection new.
	contextMenuActions := OrderedCollection new.
	shortcuts := OrderedCollection new.
	previews := OrderedCollection new.
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
	shortcuts := shortcuts copy.
	previews := previews copy.
]

{ #category : #'api - previews' }
GtCoderAddOns >> previews [
	^ previews ifNil: [ previews := OrderedCollection new ]
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
