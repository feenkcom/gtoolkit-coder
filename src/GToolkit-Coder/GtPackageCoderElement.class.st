Class {
	#name : #GtPackageCoderElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'packageCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'private - ui' }
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

{ #category : #'private - ui' }
GtPackageCoderElement >> buildContentPane [
	self addChildren: {
		self buildPackageLabel.
		self buildParentLink.
		self buildClassesAndTagsTabs }
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildPackageLabel [
	^ BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: packageCoder package name
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildPackageTagsList [
	^ BrSimpleList new
		stencil: [ :eachTag | 
			eachTag asCardElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				yourself ];
		items: (packageCoder packageTagCoders asSortedCollection: [ :a :b | a name < b name ])
]

{ #category : #'private - ui' }
GtPackageCoderElement >> buildParentLink [
	| aLinkContainer |

	aLinkContainer := BrHorizontalPane new
		hMatchParent;
		vFitContent.

	aLinkContainer addChild:
		(BrLabel new
			margin: (BlInsets left: 10);
			look: BrGlamorousLabelLook new glamorousRegularFont;
			text: 'In: ').

	aLinkContainer addChild:
		(BrButton new 
			look: (BrGlamorousButtonExteriorLook new borderPaint: Color transparent) + BrGlamorousLabelLook new glamorousRegularFont;
			label: 'Pharo';
			action: [
				| aCoderToReplace |
				aCoderToReplace := (GtCoderToReplace new coder: GtPackagesCoder new).
				self fireEvent: aCoderToReplace.
				aCoderToReplace isConsumed
					ifFalse: [ self phlow spawnObject: aCoderToReplace coder ] ]).

	^ aLinkContainer
]

{ #category : #initialization }
GtPackageCoderElement >> initialize [
	super initialize.

	self matchParent
]

{ #category : #accessing }
GtPackageCoderElement >> packageCoder [
	<return: #GtPackageCoder>

	^ packageCoder
]

{ #category : #accessing }
GtPackageCoderElement >> packageCoder: aGtPackageCoder [
	packageCoder := aGtPackageCoder.

	self buildContentPane
]
