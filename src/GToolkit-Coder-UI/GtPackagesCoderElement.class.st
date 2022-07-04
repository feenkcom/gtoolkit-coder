Class {
	#name : #GtPackagesCoderElement,
	#superclass : #BlElement,
	#traits : 'TGtWithCoderToolbar',
	#classTraits : 'TGtWithCoderToolbar classTrait',
	#instVars : [
		'packagesCoder',
		'contentPane'
	],
	#category : #'GToolkit-Coder-UI-Coder - Packages'
}

{ #category : #'private - ui' }
GtPackagesCoderElement >> buildContentPane [
	| container |
	container := BlElement new
			layout: BlLinearLayout vertical;
			addChild: self makeLabel;
			constraintsDo: [ :c | 
				c horizontal matchParent.
				c vertical matchParent ].

	contentPane := BlElement new.
	contentPane layout: BlLinearLayout horizontal.
	contentPane padding: (BlInsets top: 0 left: 5 bottom: 5 right: 5).
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].

	^ container addChild: contentPane
]

{ #category : #'private - ui' }
GtPackagesCoderElement >> buildPackageList [
	^ BrSimpleList new
		itemStencil: [ GtPackageCardElement new ];
		itemDataBinder:
				[ :eachPackageCard :eachPackageCoder | eachPackageCard coder: eachPackageCoder ];
		items:
			(packagesCoder coders
				asSortedCollection: [ :a :b | a packageName < b packageName ]);
		addEventFilterOn: BlClickEvent do: [ :anEvent | self requestFocus ]
]

{ #category : #'private - ui' }
GtPackagesCoderElement >> buildPackagesElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element padding: (BlInsets all: 5).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	element
		addChild: (BrHorizontalPane new
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				addChild: (BrLabel new
						margin: (BlInsets left: 10);
						aptitude: (BrGlamorousLabelAptitude new bold glamorousRegularFont fontSize: 18);
						text: packagesCoder name);
				addChild: self toolbarElement).
	element
		addChild: (BrLabel new
				margin: (BlInsets left: 10);
				beSmallSize;
				aptitude: (BrGlamorousLabelAptitude new glamorousRegularFont
						foreground: self theme button defaultTextColor);
				text: packagesCoder coders size printString , ' Packages').
	element addChild: self buildPackageList.
	^ element
]

{ #category : #'initialize-release' }
GtPackagesCoderElement >> coders: aPackagesCoder [
  | coderElement |

  packagesCoder := aPackagesCoder.

	coderElement := self buildPackagesElement.

	contentPane
		removeChildNamed: #coder;
		addChild: coderElement as: #coder.
]

{ #category : #'initialize-release' }
GtPackagesCoderElement >> codersUIModel: aPackagesCoder [
  | coderElement |

  packagesCoder := aPackagesCoder coder.

	coderElement := self buildPackagesElement.

	contentPane
		removeChildNamed: #coder;
		addChild: coderElement as: #coder.
]

{ #category : #'initialize-release' }
GtPackagesCoderElement >> initialize [
	super initialize.
	self initializeToolbarElement.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	
	self when: BlClickEvent do: [ self requestFocus ].
	self addChild: self buildContentPane.
]

{ #category : #'private - ui' }
GtPackagesCoderElement >> makeLabel [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize
				foreground: Color gray;
				fontSize: 12);
		text: 'Packages';
		padding: (BlInsets top: 5 left: 20)
]
