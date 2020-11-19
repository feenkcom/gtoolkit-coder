Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoSnippetCoder >> initializeAddOns [
	super initializeAddOns.
	addOns
		addMainAction: 'Evaluate' translated
		icon: BrGlamorousVectorIcons play
		action: [ :anEditorElement | self doItAll ].
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :anEditorElement | self doItAndGoAll ].
	addOns
		addMainAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :anEditorElement | self debug ].
	addOns
		addMainAction: 'Profile' translated
		icon: BrGlamorousVectorIcons performance
		action:
			[ :anEditorElement | self profileWithMessageTally ].
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
