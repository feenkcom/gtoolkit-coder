Class {
	#name : #GtPhlowSearchFilterToolElement,
	#superclass : #BrVerticalPane,
	#category : #'GToolkit-SearchFilters-PhlowTool'
}

{ #category : #'building - widgets' }
GtPhlowSearchFilterToolElement >> buildContentElement [
	^ BrFrame new
		matchParent
]

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

{ #category : #'accessing - elements' }
GtPhlowSearchFilterToolElement >> contentElement [
	^ self childNamed: #content
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
	
	self addChild: (self buildToolLabel
		padding: (BlInsets left: 5)) as: #toolLabel.
	self addChild: (self buildHeaderElement
		padding: (BlInsets left: 5)) as: #header.
	self addChild: (self buildContentElement
		padding: (BlInsets top: 5)) as: #content.
	self addChild: (self buildPlaygroundPageElement
		padding: (BlInsets top: 5)) as: #playgroundPage.
]

{ #category : #'accessing - elements' }
GtPhlowSearchFilterToolElement >> playgroundElement [
	^ self childNamed: #playgroundPage
]

{ #category : #accessing }
GtPhlowSearchFilterToolElement >> searchFilter: aSearchFilter [
	self updateForSearchFilter: aSearchFilter 
]

{ #category : #'accessing - elements' }
GtPhlowSearchFilterToolElement >> titleLabel [
	^ self headerElement childNamed: #titleLabel
]

{ #category : #updating }
GtPhlowSearchFilterToolElement >> updateContentForSearchFilter: aSearchFilter [ 
	| viewElement |
	viewElement := (aSearchFilter gtItemsFor: GtPhlowEmptyView new)
		asElementDo: [ :e | e ].
	self contentElement
		removeChildren;
		addChild: viewElement
]

{ #category : #updating }
GtPhlowSearchFilterToolElement >> updateForSearchFilter: aSearchFilter [ 
	self titleLabel 
		text: aSearchFilter gtDisplayString.
	self updateContentForSearchFilter: aSearchFilter.
	self playgroundElement objectHolder: (GtInspectorObject new 
		object: aSearchFilter)
]
