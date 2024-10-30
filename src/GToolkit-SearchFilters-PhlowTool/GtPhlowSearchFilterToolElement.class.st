Class {
	#name : #GtPhlowSearchFilterToolElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'titleNotifier',
		'searchFilter'
	],
	#category : #'GToolkit-SearchFilters-PhlowTool'
}

{ #category : #'building - widgets' }
GtPhlowSearchFilterToolElement >> buildHeaderElement [
	^ BrVerticalPane new 
		padding: (BlInsets left: 5);
		vFitContent;
		hMatchParent
]

{ #category : #'building - widgets' }
GtPhlowSearchFilterToolElement >> buildPlaygroundPageElement [
	| playgroundElement |
	playgroundElement := (GtInspector environment 
		at: GtInspector embeddedPlaygroundName) new.

	playgroundElement collapse.
	^ playgroundElement
]

{ #category : #'building - widgets' }
GtPhlowSearchFilterToolElement >> buildTitleContainer [
	^ BrHorizontalPane new 
		vFitContent;
		hMatchParent
]

{ #category : #'building - widgets' }
GtPhlowSearchFilterToolElement >> buildTitleLabel [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new 
			bold;
			fontSize: 18);
		text: ''
]

{ #category : #'building - widgets' }
GtPhlowSearchFilterToolElement >> buildToolLabel [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize
			foreground: Color gray;
			fontSize: 12);
		text: 'Search Filter'.
]

{ #category : #'building - widgets' }
GtPhlowSearchFilterToolElement >> buildToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		fitContent;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignTop ]
]

{ #category : #'building - widgets' }
GtPhlowSearchFilterToolElement >> buildViewsContainerElement [
	^ BrFrame new
		matchParent
]

{ #category : #accessing }
GtPhlowSearchFilterToolElement >> collectToolActions [ 
	^ GtPhlowActionsCollector new
		pragmaName: #gtToolAction;
		fromObject: searchFilter;
		collect
]

{ #category : #accessing }
GtPhlowSearchFilterToolElement >> collectToolViews [ 
	^ GtPhlowViewsCollector new
		pragmaName: #gtToolView;
		fromObject: searchFilter;
		collect
]

{ #category : #'accessing - elements' }
GtPhlowSearchFilterToolElement >> headerElement [
	^ self childNamed: #header
]

{ #category : #initialization }
GtPhlowSearchFilterToolElement >> initialize [
	super initialize.
	
	self matchParent.
	self padding: (BlInsets top: 5 left: 5 bottom: 0 right: 5).
	
	self initializeContent.
	self initializeTitleNotifier.
	
	self phlow 
		accessTool: (GtPhlowToolClassType forClass: GtSearchFilter) 
		viewModel: #searchFilter 
		object: #searchFilter
]

{ #category : #initialization }
GtPhlowSearchFilterToolElement >> initializeContent [
	self initializeHeaderElement.
		
	self addChild: self buildViewsContainerElement as: #viewsContainer.
	self addChild: self buildPlaygroundPageElement as: #playgroundPage.
]

{ #category : #initialization }
GtPhlowSearchFilterToolElement >> initializeHeaderElement [
	| headerElement titleContainer |
	
	headerElement := self buildHeaderElement.
	
	titleContainer := self buildTitleContainer.
	titleContainer addChild: self buildTitleLabel as: #titleLabel.
	titleContainer addChild: self buildToolbar as: #headerToolbar.

	headerElement addChild: self buildToolLabel as: #toolLabel.
	headerElement addChild: titleContainer as: #titleContainer.
	
	self addChild: headerElement as: #header.
]

{ #category : #accessing }
GtPhlowSearchFilterToolElement >> initializeTitleNotifier [
	titleNotifier := GtPhlowTitleIconAndLabelNotifier new
		longLabel: [ self searchFilterDescription ];
		icon: BrGlamorousVectorIcons search.
	self addEventHandler: titleNotifier.
]

{ #category : #'accessing - elements' }
GtPhlowSearchFilterToolElement >> playgroundElement [
	^ self childNamed: #playgroundPage
]

{ #category : #accessing }
GtPhlowSearchFilterToolElement >> searchFilter [
	<return: #GtSearchFilter>
	^ searchFilter
]

{ #category : #accessing }
GtPhlowSearchFilterToolElement >> searchFilter: aSearchFilter [
	searchFilter := aSearchFilter.
	
	self updateContent.
]

{ #category : #accessing }
GtPhlowSearchFilterToolElement >> searchFilterDescription [
	^ searchFilter 
		ifNil: [ 'Search Filter' ] 
		ifNotNil: [ :aSearchFilter | 
			'Filter: ', aSearchFilter gtDisplayString ]
]

{ #category : #'accessing - elements' }
GtPhlowSearchFilterToolElement >> titleLabel [
	^ self headerElement childNamed: #titleLabel
]

{ #category : #accessing }
GtPhlowSearchFilterToolElement >> titleNotifier [
	^ titleNotifier
]

{ #category : #'accessing - elements' }
GtPhlowSearchFilterToolElement >> toolbarElement [
	^ self headerElement childNamed: #headerToolbar
]

{ #category : #updating }
GtPhlowSearchFilterToolElement >> updateContainedViews [
	| tabGroup compositeView |
			
	compositeView := GtPhlowCompositeView new
		views:self collectToolViews.
	
	"This particular views do not update"
	"compositeView views do: [ :aView |
	 	aView autoUpdates definitions removeAll ]."
	
	tabGroup := compositeView asElementDo: [ :e | e ].
		
	self viewsContainerElement
		removeChildren;
		addChild: tabGroup
]

{ #category : #updating }
GtPhlowSearchFilterToolElement >> updateContent [
	self updateHeader.
	self updateContainedViews.
	self updatePlayground.
]

{ #category : #updating }
GtPhlowSearchFilterToolElement >> updateHeader [
	self updateTitle.
	self updateToolbarActions.
]

{ #category : #updating }
GtPhlowSearchFilterToolElement >> updatePlayground [
	self playgroundElement 
		objectHolder: (GtInspectorObject new 
			object: searchFilter)
]

{ #category : #updating }
GtPhlowSearchFilterToolElement >> updateTabLabel [
	self titleNotifier notify
]

{ #category : #updating }
GtPhlowSearchFilterToolElement >> updateTitle [
	self titleLabel 
		text: self searchFilterDescription.
]

{ #category : #updating }
GtPhlowSearchFilterToolElement >> updateToolbarActions [
	| toolbarElement|
	toolbarElement := self toolbarElement.
	toolbarElement removeAllItems.
	
	self collectToolActions do: [ :aPhlowAction | 
		aPhlowAction asElement: [ :actionElement | 
			toolbarElement 
				addItem: actionElement ]
				withHostElement: self ] 
]

{ #category : #'accessing - elements' }
GtPhlowSearchFilterToolElement >> viewsContainerElement [
	^ self childNamed: #viewsContainer
]
