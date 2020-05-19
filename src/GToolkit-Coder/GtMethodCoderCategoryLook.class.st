Class {
	#name : #GtMethodCoderCategoryLook,
	#superclass : #BrLook,
	#instVars : [
		'methodsCoder'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtMethodCoderCategoryLook >> addCategoryToggle [
	self widget
		childNamed: #header
		ifFound:
			[ :header | header addChild: self buildCategoryToggle as: self categoryToggleName ]
		ifNone: [  ]
]

{ #category : #initialization }
GtMethodCoderCategoryLook >> buildCategoryToggle [
	| categoryToggle |
	categoryToggle := BrToggle new
		margin: (BlInsets all: 0);
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ];
		activated: methodsCoder categoryFilterString = self category;
		label:
			((self category ifNil: [ '' ]) asRopedText
				attributes:
					{(BlFontSizeAttribute size: 12).
					(BlFontFamilyAttribute named: 'Source Sans Pro')});
		look: GtCategoryToggleLook;
		when: BrToggleActivatedEvent
			do: [ :anEvent | methodsCoder categoryFilterString: self category ];
		when: BrToggleDeactivatedEvent
			do: [ :anEvent | methodsCoder categoryFilterString: nil ].
	^ categoryToggle
]

{ #category : #accessing }
GtMethodCoderCategoryLook >> category [
	^ self widget coder category
]

{ #category : #initialization }
GtMethodCoderCategoryLook >> categoryToggleName [
	^ #categoryToggle
]

{ #category : #initialization }
GtMethodCoderCategoryLook >> initialize [
	super initialize.
	self
		addChange:
			(BrLookChange new
				up: [ :e | self addCategoryToggle ];
				down: [ :e | self removeCategoryToggle ];
				yourself)
]

{ #category : #accessing }
GtMethodCoderCategoryLook >> methodsCoder [
	^ methodsCoder
]

{ #category : #accessing }
GtMethodCoderCategoryLook >> methodsCoder: aMethodsCoder [
	methodsCoder := aMethodsCoder
]

{ #category : #initialization }
GtMethodCoderCategoryLook >> removeCategoryToggle [
	self widget
		childNamed: #categoryToggle
		ifFound: [ :toggle | toggle removeFromParent ]
		ifNone: [  ]
]
