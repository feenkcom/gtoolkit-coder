Class {
	#name : #GtMethodCoderCategoryLook,
	#superclass : #BrLook,
	#instVars : [
		'methodsCoder'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtMethodCoderCategoryLook >> addMethodTags [
	self widget
		childNamed: #header
		ifFound: [ :header | 
			| editor |
			editor := self buildCategoryEditor.
			self attachToBottomRight: editor.
			header addChild: editor as: self categoryEditorName ]
		ifNone: [  ]
]

{ #category : #initialization }
GtMethodCoderCategoryLook >> attachToBottomRight: anElement [
	anElement
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ]
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
				up: [ :e | self addMethodTags ];
				down: [ :e | self removeMethodTags ];
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
GtMethodCoderCategoryLook >> removeMethodTags [
	self widget
		childNamed: self categoryEditorName
		ifFound: [ :toggle | toggle removeFromParent ]
		ifNone: [  ]
]
