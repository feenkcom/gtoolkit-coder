Class {
	#name : #GtMethodCoderCategoryLook,
	#superclass : #BrLook,
	#instVars : [
		'methodsCoder'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtMethodCoderCategoryLook >> addCategoryEditor [
	self widget
		childNamed: #header
		ifFound:
			[ :header | header addChild: self buildCategoryEditor as: self categoryEditorName ]
		ifNone: [  ]
]

{ #category : #initialization }
GtMethodCoderCategoryLook >> buildCategoryEditor [
	| editor |
	editor := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				glamorousCodeFont;
				defaultForeground: Color black;
				fontSize: 10);
		padding: (BlInsets all: 2);
		margin: (BlInsets all: 0);
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ];
		text: (self category ifNil: [ '' ]) asRopedText;
		when: BrEditorAcceptWish
			do:
				[ :aWish | self methodCoder renameProtocol: aWish text asString ].
	(GtCompletionController
		on: editor
		strategy: GtMethodProtocolCompletionStrategy new) install.
	^ editor
]

{ #category : #accessing }
GtMethodCoderCategoryLook >> category [
	^ self methodCoder category
]

{ #category : #initialization }
GtMethodCoderCategoryLook >> categoryEditorName [
	^ #categoryEditor
]

{ #category : #initialization }
GtMethodCoderCategoryLook >> initialize [
	super initialize.
	self
		addChange:
			(BrLookChange new
				up: [ :e | self addCategoryEditor ];
				down: [ :e | self removeCategoryEditor ];
				yourself)
]

{ #category : #accessing }
GtMethodCoderCategoryLook >> methodCoder [
	^ self widget coder
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
GtMethodCoderCategoryLook >> removeCategoryEditor [
	self widget
		childNamed: self categoryEditorName
		ifFound: [ :toggle | toggle removeFromParent ]
		ifNone: [  ]
]
