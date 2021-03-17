Extension { #name : #GtClassMethodsCoder }

{ #category : #'*GToolkit-Coder-Extensions' }
GtClassMethodsCoder >> categoryFilter: aView [
	<gtFilterTypes>
	^ aView explicit
		title: 'Categories';
		priority: 10;
		stencil: [
			|  categories anElement |
			categories := class organization categories asSet.
			categories addAll: class class organization categories.
			categories := categories asSortedCollection.
			
			anElement := GtCoderFilterList new.
			anElement
				matchParent;
				items: categories 
				title: [ :aCategory | aCategory ]
				action: [ :aCategory | self 
					setFilters: { (GtSearchMethodCategoryFilter
						forCategory: aCategory) }
					source: anElement ] ].
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtClassMethodsCoder >> classVariableFilter: aView [
	<gtFilterTypes>
	^ aView explicit
		title: 'Class Variables';
		priority: 30;
		stencil: [
			| anElement |
			anElement := GtCoderFilterList new.
			anElement
				matchParent;
				items: class allClassVarNames 
				title: [ :aVariable | aVariable ]
				action: [ :aVariable | self 
					setFilters: { (GtSearchClassVariableReferenceFilter
						forClass: self classOrMetaClass
						andVariable: aVariable) }
					source: anElement ] ]
]

{ #category : #'*GToolkit-Coder-Extensions' }
GtClassMethodsCoder >> examplesFilter: aView [
	<gtFilterTypes>
	^ aView explicit
		title: 'Examples';
		priority: 40;
		stencil: [
			| anElement |
			anElement := GtCoderFilterList new.
			anElement
				matchParent;
				items: GtFilterExampleState default allStates
				title: [ :aState | aState labelWithAmountFor: self exampler ]
				action: [ :aState | self 
					setFilters: { (GtSearchExamplesFilter new
						resultState: aState)
						coder: self }
					source: anElement ] ].
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
		stencil: [
			| anElement |
			anElement := GtCoderFilterList new.
			anElement
				matchParent;
				items: class allInstVarNames
				title: [ :aVariable | aVariable ]
				action: [ :aVariable | self 
					setFilters: { GtSearchInstanceVariableReferenceFilter
						forClass: self classOrMetaClass
						andVariable: aVariable }
					source: anElement ] ]
]
