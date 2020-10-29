Class {
	#name : #GtClassMethodsCoder,
	#superclass : #GtFilteredMethodsCoder,
	#instVars : [
		'class',
		'object',
		'filteredClasses'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtClassMethodsCoder class >> forClass: aBehavior [
	^ self new
		forClass: aBehavior;
		yourself
]

{ #category : #'instance creation' }
GtClassMethodsCoder class >> forObject: anObject [
	^ self new
		forObject: anObject;
		yourself
]

{ #category : #actions }
GtClassMethodsCoder >> addMethodsForClass: aClass [
	(filteredClasses includes: aClass)
		ifTrue: [ ^ self ].
	filteredClasses add: aClass.
	self updateMethods.
	self updateCoders
]

{ #category : #actions }
GtClassMethodsCoder >> addNewCoder [
	| aCoder |
	aCoder := GtMethodCoder newMethod.
	aCoder classOrMetaClass: self newMethodClass.
	aCoder object: self object.
	aCoder category: #accessing.
	aCoder coders: self.
	self addFirstCoder: aCoder.
]

{ #category : #elements }
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

{ #category : #accessing }
GtClassMethodsCoder >> classOrMetaClass [
	^ class
]

{ #category : #elements }
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

{ #category : #private }
GtClassMethodsCoder >> classesFilter [
	| filter |
	filter := nil.
	filteredClasses
		do: [ :each | 
			| classFilter |
			classFilter := GtSearchMethodsInInstanceAndClassSideFilter forClass: each.
			filter := filter isNil
				ifTrue: [ classFilter ]
				ifFalse: [ filter | classFilter ] ].
	^ filter
]

{ #category : #private }
GtClassMethodsCoder >> combinedFilter [
	| combined |
	combined := super combinedFilter.
	^ self classesFilter
		ifNil: [ combined ]
		ifNotNil:
			[ :filter | combined ifNil: [ filter ] ifNotNil: [ filter & combined ] ]
]

{ #category : #accessing }
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

{ #category : #elements }
GtClassMethodsCoder >> filterDropDown: anElement [
	^ BlElement new
		size: 430 @ 430;
		addChild:
			(GtPhlowCompositeView new
				views: self filterTypes;
				asElementDo: [ :aTabGroup | aTabGroup matchParent ])
]

{ #category : #elements }
GtClassMethodsCoder >> filterTypes [
	^ GtPhlowViewsCollector new
		fromObject: self;
		pragmaName: #gtFilterTypes;
		collect
]

{ #category : #testing }
GtClassMethodsCoder >> filteredClass: aBehavior [
	^ filteredClasses includes: aBehavior
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> forClass: aBehavior [
	class := aBehavior.
	filteredClasses := Set with: aBehavior.
	self forItems: (GtSearchMethodGroupResult 
		forFilter: (GtSearchMethodsInInstanceAndClassSideFilter forClass: class))
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> forObject: anObject [
	object := anObject.
	self forClass: anObject class
]

{ #category : #printing }
GtClassMethodsCoder >> gtDisplayString [
	^ class name , ' methods'
]

{ #category : #spotter }
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

{ #category : #testing }
GtClassMethodsCoder >> hasFilter [
	^ filteredClasses notEmpty
]

{ #category : #'initialize-release' }
GtClassMethodsCoder >> initialize [
	super initialize.
	filteredClasses := Set new
]

{ #category : #elements }
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

{ #category : #testing }
GtClassMethodsCoder >> isForClass [
	^ true
]

{ #category : #private }
GtClassMethodsCoder >> newCoderFor: aMethod [
	^ (super newCoderFor: aMethod)
		withoutHeader object: object
]

{ #category : #private }
GtClassMethodsCoder >> newMethodClass [
	| methodClass |
	methodClass := filteredClasses anyOne.
	filteredClasses
		do: [ :each | 
			(methodClass includesBehavior: each)
				ifFalse: [ methodClass := each ] ].
	^ methodClass
]

{ #category : #accessing }
GtClassMethodsCoder >> object [
	^ object
]

{ #category : #actions }
GtClassMethodsCoder >> removeMethodsForClass: aClass [
	(filteredClasses includes: aClass)
		ifFalse: [ ^ self ].
	filteredClasses remove: aClass.
	self updateMethods.
	coders
		removeAllSuchThat: [ :each | 
			(each classOrMetaClass = aClass
				or: [ each classOrMetaClass = aClass classSide ])
				and: [ each isModified not ] ].
	self
		announce:
			(GtCodersCodersChanged new
				coders: self;
				yourself)
]

{ #category : #private }
GtClassMethodsCoder >> shouldSort: a before: b [
	a selector isNil
		ifTrue: [ ^ b selector notNil or: [ a classOrMetaClass allSuperclasses size >= b classOrMetaClass allSuperclasses size ] ].
	b selector isNil
		ifTrue: [ ^ false ].
	a selector < b selector
		ifTrue: [ ^ true ].
	a selector > b selector
		ifTrue: [ ^ false ].
	^ a classOrMetaClass allSuperclasses size >= b classOrMetaClass allSuperclasses size
]
