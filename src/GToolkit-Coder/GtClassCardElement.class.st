Class {
	#name : #GtClassCardElement,
	#superclass : #GtCoderCardElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtClassCardElement >> buildContainer [
	| comment commentElement |
	super buildContainer.
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

{ #category : #'building ui' }
GtClassCardElement >> commentText [
	| comment |
	comment := coder theClass organization comment.
	comment size > 100 ifTrue: [ comment := (comment first: 100) , '...' ].
	^ comment asRopedText
]

{ #category : #'building ui' }
GtClassCardElement >> detailsLabel [
	| class |
	class := coder theClass.
	^ 'Super: '
	  , (class superclass ifNil: [ '' ] ifNotNil: [ :spr | spr name ])
]
