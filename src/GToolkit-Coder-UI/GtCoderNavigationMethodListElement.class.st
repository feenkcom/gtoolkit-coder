Class {
	#name : #GtCoderNavigationMethodListElement,
	#superclass : #BrSimpleList,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #accessing }
GtCoderNavigationMethodListElement >> buildSelectorLabel: aMethod [ 
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude; 
		beSmallSize;
		text: aMethod selector
]

{ #category : #accessing }
GtCoderNavigationMethodListElement >> buildSelectorRow: aMethod index: aRowIndex list: aListElement [ 
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
		addChild: (self buildSelectorLabel: aMethod)
]

{ #category : #accessing }
GtCoderNavigationMethodListElement >> initialize [
	super initialize.
	self stencil: [ :eachMethod :eachIndex :aListElement | self buildSelectorRow: eachMethod index: eachIndex list: aListElement ]
]

{ #category : #accessing }
GtCoderNavigationMethodListElement >> initializeWithMethods: aCollection [
	| names |
	names := aCollection asSet
			sorted: [ :a :b | a methodClass name <= b methodClass name and: [ a selector < b selector ] ].
	self items: names
]
