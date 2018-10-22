Class {
	#name : #GtCoderDropdownListStencil,
	#superclass : #BrStencil,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Coder-UI - Stencils'
}

{ #category : #'api - instantiation' }
GtCoderDropdownListStencil >> create [
	<return: #Object>

	^ BrSimpleList new
		lookDo: [ :aLook | 
			aLook listElement
				constraintsDo: [ :c | 
					c vertical fitContent.
					c horizontal matchParent.
					c maxHeight: 200 ] ];
		background: Color white;
		border: (BlBorder paint: Color lightGray width: 1);
		padding: (BlInsets all: 2);
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ];
		display: self items;
		stencil: [ :each :anIndex | 
			BlTextElement new
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				text: (each displayString asRopedText thin monospace fontSize: 12) ]
]

{ #category : #accessing }
GtCoderDropdownListStencil >> items [
	^ items
]

{ #category : #accessing }
GtCoderDropdownListStencil >> items: anObject [
	items := anObject
]
