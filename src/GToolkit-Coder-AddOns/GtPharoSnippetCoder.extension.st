Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoSnippetCoder >> initializeAddOns [
	super initializeAddOns.
	addOns
		addMainAction: 'Evaluate' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aCoderUIModel :anEvent | 
			GtCoderCodeExecutor doIt
				coderUIModel: aCoderUIModel;
				event: anEvent;
				execute ]
		id: GtSourceCoderDoItActionId.
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | 
			GtCoderCodeExecutor doItAndGo
				coderUIModel: aCoderUIModel;
				event: anEvent;
				execute ]
		id: GtSourceCoderDoItAndGoActionId.
	addOns
		addMainAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :aCoderUIModel :anEvent | self debug ]
		id: GtSourceCoderDebugActionId.
	addOns
		addMainAction: 'Profile' translated
		icon: BrGlamorousVectorIcons performance
		action: [ :aCoderUIModel :anEvent | self profileWithMessageTally ]
		id: GtSourceCoderProfileActionId.
	addOns
		addStyler:
			(BrRBTextStyler new
				isForWorkspace: true;
				yourself);
		addStyler:
			(GtFixItStyler new
				sourceCoder: self;
				isForWorkspace: true);
		addStyler: GtCoderExpandableMethodStyler new.
	addOns addShortcut: GtSourceCoderInlineRenameShortcut new.
	addOns clearChanges.
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoSnippetCoder >> renameIn: editorElement [
	GtRenameAction pharoRenameSnippetLocalsOn: editorElement
]
