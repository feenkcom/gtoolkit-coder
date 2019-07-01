Class {
	#name : #GtClassMethodsCoderElement,
	#superclass : #GtFilteredMethodsCoderElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #ui }
GtClassMethodsCoderElement >> addButtonElement [
	| button |
	button := BrButton new.
	button
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons add asElement;
		margin:
			(BlInsets
				top: 7
				left: 10
				bottom: 0
				right: 0);
		action: [ methodsCoder addNewCoder ].
	^ button
]

{ #category : #'private - callbacks' }
GtClassMethodsCoderElement >> addClassToFilter: aBehavior [
	methodsCoder addMethodsForClass: aBehavior
]

{ #category : #ui }
GtClassMethodsCoderElement >> buildElement [
	super buildElement.
	self addChild: self headerElement at: 1
]

{ #category : #ui }
GtClassMethodsCoderElement >> headerElement [
	| element |
	element := BlElement new.
	element clipChildren: false.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets top: 10);
		addChild: self addButtonElement.
	^ element
]

{ #category : #'private - callbacks' }
GtClassMethodsCoderElement >> removeClassFromFilter: aBehavior ifEmpty: aBlock [
	methodsCoder removeMethodsForClass: aBehavior.
	methodsCoder hasFilter
		ifFalse: aBlock
]
