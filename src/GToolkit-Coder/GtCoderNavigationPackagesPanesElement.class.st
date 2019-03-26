Class {
	#name : #GtCoderNavigationPackagesPanesElement,
	#superclass : #BlElement,
	#instVars : [
		'navigationModel',
		'packagesContainer',
		'classesContainer',
		'protocolsContainer'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'ui building' }
GtCoderNavigationPackagesPanesElement >> buildContainerElement [
	^ BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color gray);
		margin: (BlInsets all: 5);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ]
]

{ #category : #'ui building' }
GtCoderNavigationPackagesPanesElement >> buildContent [ 
	| packagesList |
	packagesList := BrSimpleList new.
	packagesList
		display: (RPackageOrganizer default packages sort: [ :a :b | a name < b name ]);
		stencil: [ :aPackage :index |
			BlTextElement new
				text: aPackage name asRopedText;
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				when: BlClickEvent do: [ :anEvent  |
					anEvent consumed: true.
					packagesList selectOne: index ] ].
	
	packagesList when: BrSelectionChanged do: [ :anEvent |
		anEvent selectedDo: [ :anInterval | 
			| package |
			package := packagesList viewModel itemAt: anInterval first.
			self updateClassesPaneForPackage: package ] ].
	packagesContainer addChild: packagesList.
]

{ #category : #accessing }
GtCoderNavigationPackagesPanesElement >> classesList [
	^ classesContainer children first
]

{ #category : #initialization }
GtCoderNavigationPackagesPanesElement >> initialize [ 	
	super initialize.
	self
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	packagesContainer := self buildContainerElement.
	classesContainer := self buildContainerElement.
	protocolsContainer := self buildContainerElement.

	self addChildren: {packagesContainer . classesContainer . protocolsContainer}
]

{ #category : #accessing }
GtCoderNavigationPackagesPanesElement >> navigationModel: aNavigationModel [
	navigationModel := aNavigationModel.
	self buildContent.
	navigationModel theClass ifNotNil: [ :aClass |
		self selectPackage: aClass package.
		self selectClass: aClass.
		"self selectAllProtocol." ].
]

{ #category : #accessing }
GtCoderNavigationPackagesPanesElement >> packagesList [
	^ packagesContainer children first
]

{ #category : #accessing }
GtCoderNavigationPackagesPanesElement >> protocolNamesForClass: aClass [
	| protocolNames |
	protocolNames := aClass instanceSide organization protocols collect: #name.
	protocolNames := protocolNames, (aClass classSide organization protocols collect: #name).
	^ protocolNames asSet sorted: [ :a :b | a < b ]
]

{ #category : #actions }
GtCoderNavigationPackagesPanesElement >> selectClass: aClass [
	| selectionIndex |
	selectionIndex := self classesList viewModel items indexOf: aClass.
	selectionIndex > 0 ifTrue: [
		self classesList selectOne: selectionIndex ]
	
]

{ #category : #actions }
GtCoderNavigationPackagesPanesElement >> selectPackage: aPackage [
	| selectionIndex |
	selectionIndex := self packagesList viewModel items indexOf: aPackage.
	selectionIndex > 0 ifTrue: [
		self packagesList selectOne: selectionIndex ]
	
]

{ #category : #'ui building' }
GtCoderNavigationPackagesPanesElement >> updateCategoriesPaneForClass: aClass [
	| protocolsList |
	protocolsContainer removeChildren.
	protocolsList := BrSimpleList new.
	protocolsList
		display: (self protocolNamesForClass: aClass);
		stencil: [ :protocolName :index |
			BlTextElement new
				text: protocolName asRopedText;
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				when: BlClickEvent do: [ :anEvent  |
					anEvent consumed: true.
					protocolsList selectOne: index ] ].
	
	protocolsList when: BrSelectionChanged do: [ :anEvent |
		anEvent selectedDo: [ :anInterval | 
			| protocolName |
			protocolName := protocolsList viewModel itemAt: anInterval first.
			navigationModel selectInCoderCategory: protocolName ] ].
	protocolsContainer addChild: protocolsList.
]

{ #category : #'ui building' }
GtCoderNavigationPackagesPanesElement >> updateClassesPaneForPackage: aPackage [
	| classesList |
	classesContainer removeChildren.
	classesList := BrSimpleList new.
	classesList
		display: (aPackage definedClasses sorted: [ :a :b | a name < b name ]);
		stencil: [ :aClass :index |
			BlTextElement new
				text: aClass name asRopedText;
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				when: BlClickEvent do: [ :anEvent  |
					anEvent consumed: true.
					classesList selectOne: index ] ].
	
	classesList when: BrSelectionChanged do: [ :anEvent |
		anEvent selectedDo: [ :anInterval | 
			| selectedClass |
			selectedClass := classesList viewModel itemAt: anInterval first.
			self updateCategoriesPaneForClass: selectedClass.
			navigationModel selectInCoderClass: selectedClass ] ].
	classesContainer addChild: classesList.
]
