Class {
	#name : #GtClassCardElement,
	#superclass : #BlElement,
	#instVars : [
		'classCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtClassCardElement >> buildContainer [
	| class comment commentElement |
	self removeChildren.
	self addChild: (BlShrinkingTextElement new
			 text: classCoder name asRopedText bold;
			 constraintsDo: [ :c | 
				 c vertical fitContent.
				 c horizontal matchParent ]).
	class := classCoder theClass.
	self addChild: (BlShrinkingTextElement new
			 text: (('Super: '
				   ,
					   (class superclass ifNil: [ '' ] ifNotNil: [ :spr | spr name ]))
					  asRopedText glamorousRegularFont thin foreground:
						  BrGlamorousColors defaultButtonTextColor);
			 constraintsDo: [ :c | 
				 c vertical fitContent.
				 c horizontal matchParent ]).
	comment := self commentText.
	comment glamorousRegularFont thin foreground:
		BrGlamorousColors defaultButtonTextColor.
	comment isEmpty ifTrue: [ ^ self ].
	commentElement := BrEditorElement new.
	commentElement editor: (BrTextEditor new text: comment readonly).
	commentElement padding: (BlInsets left: 1).
	commentElement constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical fitContent ].
	commentElement when: BlClickEvent do: [ :event | 
		self selectCoder.
		event consumed: true ].
	self addChild: commentElement
]

{ #category : #accessing }
GtClassCardElement >> classCoder [
	^ classCoder
]

{ #category : #accessing }
GtClassCardElement >> classCoder: coder [
	classCoder := coder.
	self buildContainer
]

{ #category : #'building ui' }
GtClassCardElement >> commentText [
	| comment |
	comment := classCoder theClass organization classComment.
	comment size > 100 ifTrue: [ comment := (comment first: 100) , '...' ].
	^ comment asRopedText
]

{ #category : #'initialize-release' }
GtClassCardElement >> initialize [
	super initialize.
	self viewModel: (BrInteractiveModel new
			addStates: {
				BrActivationModel new.
				BrPressModel new.
				BrHoverModel new.
			}).
	self look: (BrGlamorousButtonExteriorLook new borderPaint: Color transparent).
	self layout: (BlLinearLayout vertical cellSpacing: 2).
	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	self margin: (BlInsets
			 top: 5
			 left: 10
			 bottom: 5
			 right: 10).
	self padding: (BlInsets all: 5).
	self when: BlClickEvent do: [ :event | self selectCoder ]
]

{ #category : #private }
GtClassCardElement >> selectCoder [
	self
		allParentsDetect: [ :each | each isKindOf: GtPackagesCoderElement ]
		ifFound: [ :element | element updateSelection: classCoder ]
		ifNone: [ self phlow spawnObject: classCoder ]
]
