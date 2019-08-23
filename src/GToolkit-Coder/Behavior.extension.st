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
						addItem:
							(BrEditor new
								look: BrGlamorousCodeEditorLook new;
								geometry: (BlRectangle cornerRadius: 4);
								border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
								hExact: 100;
								vMatchParent;
								padding: (BlInsets all: 3);
								in: [ :e | 
									classCoder methodsCoder implementorsFilterString
										ifNotNil: [ :g | e text: g asString asRopedText ].
									e editor
										when: BrTextEditorInsertedEvent
											do: [ classCoder methodsCoder implementorsFilterString: e text asString ];
										when: BrTextEditorDeletedEvent
											do: [ classCoder methodsCoder implementorsFilterString: e text asString ] ];
								yourself);
						addItem:
							(BrButton new
								look: BrGlamorousButtonWithIconLook;
								icon: BrGlamorousIcons add asElement;
								action: [ classCoder methodsCoder addNewCoder ];
								yourself);
						yourself ])
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
