"
I show a simple list of classes sorting alphabetically


"
Class {
	#name : #GtCoderNavigationClassesListElement,
	#superclass : #BrSimpleList,
	#traits : 'TGtCoderNavigationClassesHelper',
	#classTraits : 'TGtCoderNavigationClassesHelper classTrait',
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesListElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #'private - ui' }
GtCoderNavigationClassesListElement >> buildClassLabel: aClass [
	| aLook aText |
	aLook := (BrGlamorousLabelAptitude new fontSize: 12).
	aText := aClass name.

	(self isAbstractClass: aClass)
		ifTrue: [ aLook italic ].
	
	(self isDeprecatedClass: aClass)
		ifTrue: [ 
			aText := aText, ' (deprecated)'.
			Transcript show: aText; cr.
			aLook bold ].
	
	^ BrLabel new
		aptitude: aLook;
		text: aText.
]

{ #category : #'private - ui' }
GtCoderNavigationClassesListElement >> buildClassRow: aClass index: aRowIndex list: aListElement [
	^ BrWidgetContainer new
		layout: BlLinearLayout horizontal;
		aptitude:
			BrHorizontalPaneAptitude new
				+
					(BrStyleCommonAptitude new
						default:
								[ :aStyle | aStyle background: self theme item deselectedColor ];
						hovered:
								[ :aStyle | aStyle background: self theme item hoveredColor ];
						selected:
								[ :aStyle | aStyle background: self theme item selectedColor ];
						pressed:
								[ :aStyle | aStyle background: self theme item pressedColor ];
						focused: [ :aStyle | 
							aStyle
								border: (BlBorder paint: self theme item focusedBorderColor width: 1) ]);
		when: BlMouseDownEvent
			do: [ :anEvent | 
			anEvent consumed: true.
			aListElement selectOne: aRowIndex dueTo: anEvent.
			aListElement requestFocus ];
		hMatchParent;
		vFitContent;
		padding: (BlInsets left: 3);
		addChild: (self buildClassLabel: aClass)
]

{ #category : #initialization }
GtCoderNavigationClassesListElement >> initialize [
	super initialize.
	
	self stencil: [ :eachClass :eachIndex :aListElement | self buildClassRow: eachClass index: eachIndex list: aListElement ]
]

{ #category : #initialization }
GtCoderNavigationClassesListElement >> initializeWithClasses: aCollectionOfClasses [	
	self items: (aCollectionOfClasses sorted: [ :classA :classB | classA name < classB name ])
]
