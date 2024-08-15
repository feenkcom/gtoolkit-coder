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
	| headerElement titleLabel |
	
	headerElement := BrHorizontalPane new
		vFitContent;
		hMatchParent.

	titleLabel := self buildTitleLabel.

	headerElement addChild: titleLabel as: #titleLabel.
	^ headerElement
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
GtPhlowSearchFilterToolElement >> buildViewsContainerElement [
	^ BrFrame new
		matchParent
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
	self padding: (BlInsets top: 5 left: 6 bottom: 0 right: 6).
	
	self initializeContent.
	self initializeTitleNotifier.
]

{ #category : #initialization }
GtPhlowSearchFilterToolElement >> initializeContent [
	self addChild: (self buildToolLabel
		padding: (BlInsets left: 5)) as: #toolLabel.
	self addChild: (self buildHeaderElement
		padding: (BlInsets left: 5)) as: #header.
		
	self addChild: (self buildViewsContainerElement
		padding: (BlInsets top: 5)) as: #viewsContainer.
	self addChild: (self buildPlaygroundPageElement
		padding: (BlInsets top: 5)) as: #playgroundPage.
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
	self titleLabel 
		text: self searchFilterDescription.
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

{ #category : #'accessing - elements' }
GtPhlowSearchFilterToolElement >> viewsContainerElement [
	^ self childNamed: #viewsContainer
]
