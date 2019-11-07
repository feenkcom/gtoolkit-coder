Class {
	#name : #GtClassCardElement,
	#superclass : #BrCard,
	#instVars : [
		'classCoder',
		'breadcrumb'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtClassCardElement >> buildHeaderForClass: class [
	| element |
	element := BlElement new.
	element
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element margin: (BlInsets bottom: 3).
	element
		addChild:
			(BrLabel new
				look: BrGlamorousLabelLook new glamorousCodeFontAndSize;
				text: class name asRopedText bold;
				hFitContent;
				vFitContent).
	element addChild: self buildHierarchyBreadcrumb.
	^ element
]

{ #category : #'building ui' }
GtClassCardElement >> buildHierarchyBreadcrumb [
	| element |
	element := BrBreadcrumb new.
	element
		look:
			(BrGlamorousBreadcrumbLook new
				separator: [ BrLabel new
						look:
							(BrGlamorousLabelLook new thin
								foreground: BrGlamorousColors defaultButtonTextColor);
						text: '>';
						margin: (BlInsets left: 3 right: 3) ]).
	classCoder theClass
		allSuperclassesDo: [ :each | 
			element
				addItem:
					(BrLabel new
						look:
							(BrGlamorousLabelLook new thin
								foreground: BrGlamorousColors defaultButtonTextColor);
						text: each name) ].
	^ element asScrollableElement
]

{ #category : #accessing }
GtClassCardElement >> classCoder [
	^ classCoder
]

{ #category : #accessing }
GtClassCardElement >> classCoder: coder [
	| class |
	classCoder := coder.
	class := classCoder theClass.
	self
		title:
			((class methods size + class class methods size) printString
				, ' Methods') asRopedText.
	self description: class comment asRopedText.
	self picture: (self buildHeaderForClass: class)
]

{ #category : #'initialize-release' }
GtClassCardElement >> initialize [
	super initialize.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self
		look:
			BrIconLook
				+
					(BrDescriptionLook new
						foreground: Color gray;
						readonly) + (BrTextLabelLook new foreground: Color gray).
	self background: Color white.
	self padding: (BlInsets all: 10).
	self layout: BlLinearLayout vertical.
	self action: [ self phlow spawnObject: classCoder ]
]
