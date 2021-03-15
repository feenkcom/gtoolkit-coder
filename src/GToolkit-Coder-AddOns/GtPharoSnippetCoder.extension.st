Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoSnippetCoder >> initializeAddOns: addOns [
	super initializeAddOns: addOns.
	"addOns
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
			(GtFixItStyler new isForWorkspace: true);
		addStyler: GtCoderExpandablePharoMethodStyler new.
	addOns addShortcut: GtSourceCoderInlineRenameShortcut new"
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoSnippetCoder >> renameIn: editorElement [
	GtRenameAction pharoRenameSnippetLocalsOn: editorElement
]
