Extension { #name : #GtTextualCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addContextMenuItemFrom: shortcut group: menuGroup withId: menuId to: coderAddOns [
	<return: #GtCoderContextMenuAction>
	^ coderAddOns
		addContextMenuItem: shortcut name
		group: menuGroup
		action: [ :aCoderViewModel :anEditorElement | 
			shortcut
				performOnEditor: anEditorElement editor
				element: anEditorElement
				dueTo: nil ]
		id: menuId
		shortcutKey: shortcut combinationForPlatform gtDisplayString
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addContextMenuItemFrom: shortcut withId: menuId to: coderAddOns [
	<return: #GtCoderContextMenuAction>
	^ coderAddOns
		addContextMenuItem: shortcut name
		action: [ :aCoderViewModel :anEditorElement | 
			shortcut
				performOnEditor: anEditorElement editor
				element: anEditorElement
				dueTo: nil ]
		id: menuId
		shortcutKey: shortcut combinationForPlatform gtDisplayString
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addContextMenuItemWithNoShortcutFrom: shortcut group: menuGroup withId: menuId to: coderAddOns [
	<return: #GtCoderContextMenuAction>
	^ coderAddOns
		addContextMenuItem: shortcut name
		group: menuGroup
		action: [ :aCoderViewModel :anEditorElement | 
			shortcut
				performOnEditor: anEditorElement editor
				element: anEditorElement
				dueTo: nil ]
		id: menuId
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addContextMenuItemWithNoShortcutFrom: shortcut withId: menuId to: coderAddOns [
	^ coderAddOns
		addContextMenuItem: shortcut name
		action: [ :aCoderViewModel :anEditorElement | 
			shortcut
				performOnEditor: anEditorElement editor
				element: anEditorElement
				dueTo: nil ]
		id: menuId
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addCopyCutPasteContextMenuAddOnsAst: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns: 1000>
	<gtCoderContextMenuAddOns>
	(self
		addContextMenuItemFrom: BrEditorShortcut cut
		withId: GtTextualCoderCutContextMenuItemId
		to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 1000 ].
	(self
		addContextMenuItemFrom: BrEditorShortcut copy
		withId: GtTextualCoderCopyContextMenuItemId
		to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 1000 ].
	(self
		addContextMenuItemFrom: BrEditorShortcut paste
		withId: GtTextualCoderPasteContextMenuItemId
		to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 1000 ]
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addExplicitContextMenu: aString block: aBlock to: coderAddOns [
	<return: #GtCoderExplicitContextMenuItemAction>
	^ coderAddOns addExplicitContextMenu: aString block: aBlock
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> initializeSearchTextAddOns: addOns viewModel: aCoderViewModel [
	GtTextualCoderSearchTextSettings isEnabledInCoder ifFalse: [ ^ self ].

	addOns
		addMainAction: (GtCoderCustomAction new
				title: 'Search';
				stencil: [ BrButton new
						aptitude: BrGlamorousButtonWithIconAptitude;
						icon: BrGlamorousVectorIcons search;
						id: GtCoderSearchActionId;
						label: 'Search';
						beTinySize;
						when: BrDropdownIsHidden
							do: [ :anEvent | aCoderViewModel announce: GtSourceCoderViewModelSearchTextCancelRequested new ];
						addAptitude: (BrGlamorousWithExplicitDropdownAptitude new
								in: [ :theAptitude | 
									aCoderViewModel weak
										when: GtSourceCoderViewModelSearchTextRequested
										send: #show
										to: theAptitude ];
								withVisibleWidgetBoundsRelocator;
								withContainerPermanentVisibilityUpdater;
								menuContainerDo: [ :aContainer | 
									aContainer layout
										areaBuilders: {BlSteppedLayoutAreaBuilder dropdownBottomRight.
												BlSteppedLayoutAreaBuilder dropdownBottomLeft.
												BlSteppedLayoutAreaBuilder allToBottom.
												BlSteppedLayoutAreaBuilder allToRight.
												BlSteppedLayoutAreaBuilder allToLeft.
												BlSteppedLayoutAreaBuilder dropdownUpRight.
												BlSteppedLayoutAreaBuilder dropdownUpLeft.
												BlSteppedLayoutAreaBuilder allToUp} ];
								handle: [ BrButton new
											aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude
													- BrGlamorousButtonWithLabelTooltipAptitude2;
											icon: BrGlamorousVectorIcons search;
											beTinySize ]
									content: [ :anExplicitMenu | 
										| anElement |
										anElement := GtTextualCoderSearchTextElement new
												textualCoderViewModel: aCoderViewModel;
												editorDo: [ :anEditor | anEditor requestFocus ];
												hFitContentLimited;
												constraintsDo: [ :c | 
													c minWidth: 300.
													c frame horizontal alignCenter.
													c frame vertical alignCenter ].
										BrFrame new
											fitContentLimited;
											padding: (BlInsets all: 5);
											addChild: anElement ]) ])
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns addShortcut: GtSourceCoderSearchTextShortcut new
]
