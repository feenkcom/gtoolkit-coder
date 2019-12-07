Class {
	#name : #GtPackageCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'packageCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtPackageCoderElement >> buildClassesAndTagsTabs [
	| tabGroup |
	tabGroup := BrTabGroup new.
	tabGroup look: BrGlamorousTabGroupLook new.
	tabGroup constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	tabGroup addTab: (BrTab new
			 look: BrGlamorousTabLook new;
			 label: 'Classes';
			 stencil: [ packageCoder classesCoder asElement ]).
	tabGroup addTab: (BrTab new
			 look: BrGlamorousTabLook new;
			 label: 'Tags';
			 stencil: [ self buildPackageTagsList ]).
	^ tabGroup
]

{ #category : #'building ui' }
GtPackageCoderElement >> buildContentPane [
	self removeChildren.
	self addChild: self buildPackageLabel.
	self addChild: self buildParentLink.
	self addChild: self buildClassesAndTagsTabs
]

{ #category : #'building ui' }
GtPackageCoderElement >> buildPackageLabel [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: packageCoder package name
]

{ #category : #'building ui' }
GtPackageCoderElement >> buildPackageTagsList [
	| element |
	element := BrSimpleList new.
	element stencil: [ :each | 
		each asCardElement
			constraintsDo: [ :c | 
				c horizontal matchParent.
				c vertical fitContent ];
			yourself ].
	element display:
		(packageCoder packageTagCoders asSortedCollection: [ :a :b | 
			 a name < b name ]).
	^ element
]

{ #category : #'building ui' }
GtPackageCoderElement >> buildParentLink [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout new beHorizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		addChild:
			(BrLabel new
				margin: (BlInsets left: 10);
				look: BrGlamorousLabelLook new glamorousRegularFont;
				text: 'In: ').
	element
		addChild:
			(BrButton new
				look:
					(BrGlamorousButtonExteriorLook new borderPaint: Color transparent)
						+ BrGlamorousLabelLook new glamorousRegularFont;
				label: 'Pharo';
				action: [ self
						allParentsDetect: [ :each | each isKindOf: GtPackagesCoderElement ]
						ifFound: [ :p | p updateSelection: GtPackagesCoder new ]
						ifNone: [ self phlow spawnObject: GtPackagesCoder new ] ]).
	^ element
]

{ #category : #initialization }
GtPackageCoderElement >> initialize [
	super initialize.
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #accessing }
GtPackageCoderElement >> packageCoder [
	^ packageCoder
]

{ #category : #accessing }
GtPackageCoderElement >> packageCoder: anObject [
	packageCoder := anObject.
	self buildContentPane
]
