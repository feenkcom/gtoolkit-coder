Class {
	#name : #GtPackagesCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'packagesCoder',
		'contentPane'
	],
	#category : #'GToolkit-Coder-UI-Coder - Packages'
}

{ #category : #'private - ui' }
GtPackagesCoderElement >> buildContentPane [
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout horizontal.
	contentPane padding: (BlInsets all: 5).
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ contentPane
]

{ #category : #'private - ui' }
GtPackagesCoderElement >> buildPackageList [
	^ BrSimpleList new
		itemStencil: [ GtPackageCardElement new ];
		itemDataBinder: [ :eachPackageCard :eachPackageCoder | eachPackageCard coder: eachPackageCoder ];
		items: (packagesCoder coders asSortedCollection: [:a :b | a name < b name ]);
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
		addChild:
			(BrLabel new
				margin: (BlInsets left: 10);
				look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 18);
				text: packagesCoder name).
	element
		addChild:
			(BrLabel new
				margin: (BlInsets left: 10);
				beSmallSize;
				look:
					(BrGlamorousLabelLook new glamorousRegularFont
						foreground: BrGlamorousColors defaultButtonTextColor);
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
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	
	self when: BlClickEvent do: [ self requestFocus ].
	self addChild: self buildContentPane.
]
