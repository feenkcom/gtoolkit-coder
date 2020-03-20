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
												icon: BrGlamorousIcons search asElement;
												yourself);
										content:
											(GtSpotterElement new
												spotterModel: model;
												size: 600 @ 400;
												yourself);
										yourself);
								background: BrGlamorousColors secondaryHeaderBackgroundColor;
								yourself ]);
		icon: BrGlamorousIcons search asElement;
		label: 'Search';
		yourself
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowse [
	| aCoder aSpace coder |
	coder := GtPackagesCoder new.
	aCoder := GtInspector withToolOn: coder.
	aSpace := BlSpace new.
	aSpace title: 'Coder'.
	aSpace extent: 1200 @ 600.
	aSpace addChild: aCoder.
	aSpace withHalos.
	aSpace show.
	coder withClass: self
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFrom: anElement [
	| aCoder aSpace coder |
	coder := GtPackagesCoder new.
	aCoder := GtInspector withToolOn: coder.
	aSpace := BlSpace new.
	aSpace title: 'Coder'.
	aSpace extent: 1200 @ 600.
	aSpace addChild: aCoder.
	aSpace withHalos.
	anElement showSpace: aSpace.
	coder withClass: self
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderCommentsFor: aView [
	<gtClassView>
	^ aView explicit
		title: 'Comments';
		priority: 30;
		stencil: [ (GtClassCommentsCoder forClass: self) asElement ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCoderDefinitionsFor: aView [
	<gtClassView>
	^ aView explicit
		title: 'Definitions';
		priority: 30;
		stencil: [ (GtClassDefinitionsCoder forClass: self) asElement ]
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
		actionButtonIcon: BrGlamorousIcons add asElement
			action: [ methodsCoder addNewCoder ];
		actionStencil: [ self buildSpotterButtonFor: methodsCoder ];
		stencil: [ methodsCoder asElement ]
]
