Extension { #name : #GtTextualCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addContextMenuItemFrom: shortcut group: menuGroup withId: menuId to: coderAddOns [
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
	self
		addContextMenuItemFrom: BrEditorShortcut cut
			withId: GtTextualCoderCutContextMenuItemId
			to: coderAddOns;
		addContextMenuItemFrom: BrEditorShortcut copy
			withId: GtTextualCoderCopyContextMenuItemId
			to: coderAddOns;
		addContextMenuItemFrom: BrEditorShortcut paste
			withId: GtTextualCoderPasteContextMenuItemId
			to: coderAddOns
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addExplicitContextMenu: aString block: aBlock to: coderAddOns [
	^ coderAddOns addExplicitContextMenu: aString block: aBlock
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> initializeAddOns: addOns viewModel: aCoderViewModel [
	| aStyler aWeakElement |
	super initializeAddOns: addOns viewModel: aCoderViewModel.
	
	GtTextualCoderSearchTextSettings isEnabledInCoder ifFalse: [ ^ self ].
	
	addOns addStyler: (aStyler := BrEditorSearchTextStyler new).

	addOns
		addMainAction: (GtCoderCustomAction new
				title: 'Search';
				stencil: [ BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons search;
					id: GtMethodCoderSaveActionId;
					label: 'Search';
					beTinySize;
					when: BrDropdownIsHidden
						do: [ :anEvent | 
							aStyler subtext: nil.
							aCoderViewModel announce: (GtTextualCoderViewModelReadyToRestyle new). ];
					addAptitude: (BrGlamorousWithExplicitDropdownAptitude new
						in: [ :theAptitude | 
							aCoderViewModel weak 
								when: GtSourceCoderViewModelSearchTextRequested 
									send: #show 
									to: theAptitude ];
						handle: [ BrButton new
							aptitude: BrGlamorousButtonWithIconAptitude 
								- BrGlamorousButtonExteriorAptitude
								- BrGlamorousButtonWithLabelTooltipAptitude2;
							icon: BrGlamorousVectorIcons search;
							beTinySize ] 
						content: [ :anExplicitMenu | 
							| anElement |
							anElement := BrSearchTextElement new
									styler: aStyler;
									editorDo: [ :anEditor | anEditor requestFocus ];
									hFitContentLimited;
									constraintsDo: [ :c | 
										c minWidth: 300.
										c frame horizontal alignCenter.
										c frame vertical alignCenter ];
									when: BrSearchTextPatternWish
										do: [ :anEvent | 
											aStyler subtext: anEvent text.
											aCoderViewModel announce: (GtTextualCoderViewModelReadyToRestyle new) ];
									when: BrSearchTextNextOccurenceWish
										do: [ :anEvent | 
											aStyler nextItem.
											aCoderViewModel announce: (GtTextualCoderViewModelReadyToRestyle new) ];
									when: BrSearchTextPreviousOccurenceWish
										do: [ :anEvent | 
											aStyler previousItem.
											aCoderViewModel announce: (GtTextualCoderViewModelReadyToRestyle new) ];
									when: BrSearchTextEndWish
										do: [ :anEvent |
											| aRange |
											aRange := aStyler currentRange.
											aStyler subtext: nil.
											aRange ifNotNil: [ 
												| aSelection |
												aSelection := BlCompositeSelection new select: aRange first - 1 to: aRange last.
												aCoderViewModel announce: (GtTextualCoderViewModelSelectionChanged new 
													shouldUpdateCursor: true;
													selection: aSelection; 
													source: aCoderViewModel) ].
											aCoderViewModel announce: (GtTextualCoderViewModelReadyToRestyle new).
											aCoderViewModel announce: (GtTextualCoderViewModelFocusChanged new 
												focused: true; 
												source: aCoderViewModel).
											anEvent currentTarget fireEvent: BrDropdownHideWish new ].
							aWeakElement := anElement asWeakReference.
							BrFrame new
								fitContentLimited;
								padding: (BlInsets all: 5);
								addChild: anElement ] ) ] ).

	aStyler
		visualizer: (GtTextualCoderSearchTextVisualizer new
				textualCoderViewModel: aCoderViewModel;
				action: [ :aContext | 
					aWeakElement
						ifNotNil: [ :aWeak | 
							(aWeak at: 1)
								ifNotNil: [ :anElement | 
									BlTaskAction
										enqueueElement: anElement
										action: [ anElement index: aContext selectedItem total: aContext itemsCount ] ] ] ]).
										
	
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns addShortcut: GtSourceCoderSearchTextShortcut new
]
