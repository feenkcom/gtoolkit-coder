Class {
	#name : #GtPackageTagCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'packageTagCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildClassesList [
	^ packageTagCoder classesCoder asElement
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildContentPane [
	self removeChildren.
	self addChild: self buildPackageTagLabel.
	self addChild: self buildParentLink.
	self addChild: self buildClassesList
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildPackageTagLabel [
	^ BrLabel new
		  margin: (BlInsets left: 10);
		  look:
			  (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 18);
		  text: packageTagCoder name
]

{ #category : #'build ui' }
GtPackageTagCoderElement >> buildParentLink [
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
				label: packageTagCoder package name;
				action: [
					| anEvent |

					anEvent := (GtCoderToReplace new coder: packageTagCoder packageCoder).
					self fireEvent: anEvent.

					anEvent isConsumed
						ifFalse: [ self phlow spawnObject: anEvent coder ] ]).
	^ element
]

{ #category : #initialization }
GtPackageTagCoderElement >> initialize [
	super initialize.
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #accessing }
GtPackageTagCoderElement >> packageTagCoder [
	^ packageTagCoder
]

{ #category : #accessing }
GtPackageTagCoderElement >> packageTagCoder: anObject [
	packageTagCoder := anObject.
	self buildContentPane
]
