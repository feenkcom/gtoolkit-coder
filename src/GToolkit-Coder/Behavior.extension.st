Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> buildCommentsTabIn: tabGroup for: classCoder [
	<gtClassView: 30>
	tabGroup
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Comments';
				stencil: [ classCoder commentsCoder asElement ])
]

{ #category : #'*GToolkit-Coder' }
Behavior >> buildDefinitionsTabIn: tabGroup for: classCoder [
	<gtClassView: 20>
	tabGroup
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Definitions';
				stencil: [ classCoder definitionsCoder asElement ])
]

{ #category : #'*GToolkit-Coder' }
Behavior >> buildMethodsTabIn: tabGroup for: classCoder [
	<gtClassView: 10>
	tabGroup
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Methods';
				stencil: [ classCoder methodsCoder asElement ];
				toolbarStencil: [ BrToolbar new
						look: BrGlamorousToolbarLook new;
						addItem: (self buildSpotterButtonFor: classCoder);
						addItem:
							(BrButton new
								look: BrGlamorousButtonWithIconLook;
								icon: BrGlamorousIcons add asElement;
								action: [ classCoder methodsCoder addNewCoder ];
								yourself);
						yourself ])
]

{ #category : #'*GToolkit-Coder' }
Behavior >> buildSpotterButtonFor: classCoder [
	| look |
	^ BrButton new
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						stencil: [ | model |
							model := GtSpotter new initializeWith: classCoder methodsCoder.
							model announcer
								when: GtSpotterActOn
								do: [ :anEvent | 
									classCoder methodsCoder selectAndScrollTo: anEvent element.
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
												label: 'Playground History';
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
	| aCoder aSpace |

	aCoder := GtInspector createOnPlayBook: (GtClassCoder forClass: self).
	aSpace := BlSpace new.
	aSpace title: 'Coder'.
	aSpace extent: 1200@600.
	aSpace addChild: aCoder.
	aSpace withHalos.
	aSpace show
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFrom: anElement [
	| aCoder aSpace |

	aCoder := GtInspector createOnPlayBook: (GtClassCoder forClass: self).
	aSpace := BlSpace new.
	aSpace title: 'Coder'.
	aSpace extent: 1200@600.
	aSpace addChild: aCoder.
	aSpace withHalos.
	
	anElement showSpace: aSpace
]
