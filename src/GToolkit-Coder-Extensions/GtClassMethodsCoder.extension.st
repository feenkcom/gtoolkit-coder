Extension { #name : #GtClassMethodsCoder }

{ #category : #'*GToolkit-Coder-Extensions' }
GtClassMethodsCoder >> categoryFilter: aView [
	<gtFilterTypes>
	^ aView explicit
		title: 'Categories';
		priority: 10;
		stencil: [ | categories |
			categories := class organization categories asSet.
			categories addAll: class class organization categories.
			categories := categories asSortedCollection.
			GtCoderContextMenuContent new
				constraintsDo: [ :c | c horizontal matchParent ];
				items:
					(categories
						collect: [ :each | 
							GtCoderContextMenuAction new
								action:
										[ :element | self setFilters: {(GtSearchMethodCategoryFilter forCategory: each)} ];
								title: each ]);
				hMatchParent;
				vMatchParent ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtClassMethodsCoder >> classVariableFilter: aView [
	<gtFilterTypes>
	^ aView explicit
		title: 'Class Variables';
		priority: 30;
		stencil: [ | variables |
			variables := class allClassVarNames.
			GtCoderContextMenuContent new
				constraintsDo: [ :c | c horizontal matchParent ];
				items:
					(variables
						collect: [ :each | 
							GtCoderContextMenuAction new
								action: [ :element | 
									self
										setFilters:
											{(GtSearchClassVariableReferenceFilter
												forClass: self classOrMetaClass
												andVariable: each)} ];
								title: each ]);
				hMatchParent;
				vMatchParent ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtClassMethodsCoder >> examplesFilter: aView [
	<gtFilterTypes>
	^ aView explicit
		title: 'Examples';
		priority: 40;
		stencil: [ | states |
			states := GtFilterExampleState default allStates.
			GtCoderContextMenuContent new
				items: (states collect: [ :eachState | 
					GtCoderContextMenuAction new
						action: [ :element | 
							self setFilters: {
								((GtSearchExamplesFilter new
									resultState: eachState)
									coder: self)} ];
						title: (eachState labelWithAmountFor: self exampler) ]);
				hMatchParent;
				vMatchParent ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtClassMethodsCoder >> filterDropDown: anElement [
	^ BlElement new
		size: 430 @ 430;
		addChild:
			(GtPhlowCompositeView new
				views: self filterTypes;
				asElementDo: [ :aTabGroup | aTabGroup matchParent ])
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtClassMethodsCoder >> gtSpotterMethodsFor: aStep [
	<gtSearch>
	aStep listProcessor
		priority: 10;
		title: 'Methods';
		allCandidates: [ self coders ];
		itemName: [ :method | method selector ];
		previewElement: [ :coder | coder previewElement ];
		filter: GtFilterSubstring
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtClassMethodsCoder >> instanceVariableFilter: aView [
	<gtFilterTypes>
	^ aView explicit
		title: 'Instance Variables';
		priority: 20;
		stencil: [ | variables |
			variables := class allInstVarNames.
			GtCoderContextMenuContent new
				constraintsDo: [ :c | c horizontal matchParent ];
				items:
					(variables
						collect: [ :each | 
							GtCoderContextMenuAction new
								action: [ :element | 
									self
										setFilters:
											{(GtSearchInstanceVariableReferenceFilter
												forClass: self classOrMetaClass
												andVariable: each)} ];
								title: each ]);
				hMatchParent;
				vMatchParent ]
]
