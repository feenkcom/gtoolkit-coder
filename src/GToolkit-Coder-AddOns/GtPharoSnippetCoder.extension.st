Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtPharoSnippetCoder >> initializeAddOns [
	super initializeAddOns.
	addOns
		addMainAction: 'Evaluate' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aCoderUIModel :anEvent | self doItAll ]
		id: GtSourceCoderDoItActionId.
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | 
			| aSelection aText |
			aSelection := aCoderUIModel selection.
			aText := aCoderUIModel text. 
			aSelection isNotEmpty
				ifTrue: [
					self doItAndGo: [ :aSourceText |
						aText characters = aSourceText characters
							ifTrue: [ 
								| aMonoSelection |
								aMonoSelection := 1 to: 0.
								aSelection do: [ :eachMonotoneSelection | 
									aMonoSelection := eachMonotoneSelection from + 1 to: eachMonotoneSelection to ].
								aMonoSelection ]
							ifFalse: [
								self flag: 'Handle modified text here'.
								1 to: 0 ] ] ] 
				ifFalse: [ self doItAndGoAll ] ]
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
	addOns clearChanges
]
