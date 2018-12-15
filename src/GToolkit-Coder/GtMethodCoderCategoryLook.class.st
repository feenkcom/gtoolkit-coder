Class {
	#name : #GtMethodCoderCategoryLook,
	#superclass : #BrLook,
	#instVars : [
		'methodsCoder'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #accessing }
GtMethodCoderCategoryLook >> category [
	^ self widget methodCoder category
]

{ #category : #initialization }
GtMethodCoderCategoryLook >> initializeLook [
	super initializeLook.
	self widget
		childNamed: #header
		ifFound: [ :header | 
			| categoryToggle |
			categoryToggle := BrToggle new
				margin: (BlInsets all: 0);
				constraintsDo: [ :c | 
					c frame horizontal alignRight.
					c frame vertical alignTop ];
				activated: methodsCoder categoryFilterString = self category;
				label: ((self category ifNil: [ '' ]) asRopedText attributes: {(BlFontSizeAttribute size: 12)});
				look: GtCategoryToggleLook;
				when: BrToggleActivatedEvent do: [ :anEvent | methodsCoder categoryFilterString: self category ];
				when: BrToggleDeactivatedEvent do: [ :anEvent | methodsCoder categoryFilterString: nil ].
			header addChild: categoryToggle ]
		ifNone: [  ]
]

{ #category : #accessing }
GtMethodCoderCategoryLook >> methodsCoder [
	^ methodsCoder
]

{ #category : #accessing }
GtMethodCoderCategoryLook >> methodsCoder: aMethodsCoder [
	methodsCoder := aMethodsCoder
]
