Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoSnippetCoder >> initializeAddOns [
	super initializeAddOns.
	addOns
		addMainAction: 'Evaluate' translated
		icon: BrGlamorousVectorIcons play
		action: [ :anEditorElement | self doItSelectionOrAllFrom: anEditorElement ].
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action:
			[ :anEditorElement | self doItAndGoSelectionOrAllFrom: anEditorElement ].
	addOns
		addMainAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :anEditorElement | self debugSelectionFrom: anEditorElement ].
	addOns
		addMainAction: 'Profile' translated
		icon: BrGlamorousVectorIcons performance
		action:
			[ :anEditorElement | self profileWithMessageTallyFrom: anEditorElement ].
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
	addOns clearChanges
]
