Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> buildSpotterButtonFor: methodsCoder [
	| look |
	^ BrButton new
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						stencil: [ | model |
							model := GtSpotter new initializeWith: methodsCoder.
							model announcer
								when: GtSpotterActOn
								do: [ :anEvent | 
									methodsCoder selectAndScrollTo: anEvent element.
									anEvent actedUpon: true.
									look hide ].
							model announcer
								when: GtSpotterExitAnnouncement
								do: [ :e | look hide ].
							BlElement new
								look:
									(BrGlamorousDropdownLook new
										handle:
											(BrButton new
												look:
													BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
														- BrGlamorousButtonExteriorLook;
												icon: BrGlamorousVectorIcons search;
												yourself);
										content:
											(GtSpotterElement new
												spotterModel: model;
												size: 600 @ 400;
												yourself);
										yourself);
								background: BrGlamorousColors secondaryHeaderBackgroundColor;
								yourself ]);
		icon: BrGlamorousVectorIcons search;
		label: 'Search';
		yourself
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowse [
	BlSpace new
		title: 'Coder';
		extent: 1200 @ 600;
		addChild: (GtInspector withToolOn: (GtCoder forClass: self));
		withHalos;
		show.
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFrom: anElement [
	| aSpace |

	aSpace := BlSpace new
		title: 'Coder';
		extent: 1200 @ 600;
		addChild: (GtInspector withToolOn: (GtCoder forClass: self));
		withHalos.

	anElement showSpace: aSpace
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderCommentsFor: aView [
	<gtClassView>

	^ aView explicit
		title: 'Comment';
		priority: 30;
		stencil: [ (GtDocument forClass: self) asElement ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderMethodsFor: aView context: aDictionary [
	<gtClassView>
	| methodsCoder object |
	aDictionary
		at: #classCoder
		ifPresent: [ :coder | object := coder object ].
	methodsCoder := object notNil
		ifTrue: [ GtClassMethodsCoder forObject: object ]
		ifFalse: [ GtClassMethodsCoder forClass: self ].
	^ aView explicit
		title: 'Comments';
		priority: 10;
		title: 'Methods';
		actionButtonIcon: BrGlamorousVectorIcons add
			action: [ methodsCoder addNewCoder ];
		actionStencil: [ self buildSpotterButtonFor: methodsCoder ];
		stencil: [ methodsCoder asElement ]
]
