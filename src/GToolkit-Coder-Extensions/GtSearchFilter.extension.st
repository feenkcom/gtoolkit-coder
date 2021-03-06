Extension { #name : #GtSearchFilter }

{ #category : #'*GToolkit-Coder-Extensions' }
GtSearchFilter class >> gtHierarchyFor: aView [
	<gtView>
	<gtClassView>
	^ aView mondrian
		title: 'Hierarchy';
		priority: 10;
		painting: [ :m | 
			m nodes 
				stencil: [ :eachClass | 
					| anExpander text |
					text := (eachClass = GtSearchFilter 
								ifTrue: ['Filter']
								ifFalse: [ 
									(eachClass name gtRemovePrefix: 'GtSearch') 
										gtRemoveSuffix: 'Filter' ])
									asRopedText 
									glamorousRegularFont;
									fontSize: 18.
					anExpander := BrExpander new.
					anExpander vFitContent; hExact: 300.
					anExpander aptitude: GtCoderExpanderAptitude new.
					anExpander header: [ BlTextElement new 
						padding: (BlInsets left: 5 right: 5);
						text: text ].
					anExpander content: [ 
						| container methods |
						container := BlElement new
							layout: BlLinearLayout vertical;
							constraintsDo: [ :c | c vertical fitContent. c horizontal fitContent].
						container addChild: (BlTextElement new 
							padding: (BlInsets left: 5 right: 5);
							text: text).
						methods := eachClass = GtSearchFilter 
							ifTrue: [ (GtSearchFilter methods select: #isOverridden) ]
							ifFalse: [ eachClass methods select: [:method | 
								method gtIsOverridingUpTo: GtSearchFilter ] ].
						methods do: [:aMethod | 
							container addChild: ((GtPharoMethodCoder forMethod: aMethod) asElement)].
						container ].
					anExpander margin: (BlInsets all: 10).
						 ];
				with: self withAllSubclasses.
			m edges 
				stencil: [ :each |
					BlLineElement new 
						zIndex: -1;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 1);
						fromHead: (BlArrowheadTriangle new scale: 4; background: Color white;
						border: (BlBorder paint: (Color gray alpha: 0.5) width: 1))];
				fromRightCenter;
				toLeftCenter;
				connectFrom: #superclass.
			m layout explicit: (GtGraphHorizontalTreeLayout new layered horizontalGap: 20; verticalGap: 10).
			]
]
