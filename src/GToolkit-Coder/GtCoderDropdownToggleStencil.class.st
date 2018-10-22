Class {
	#name : #GtCoderDropdownToggleStencil,
	#superclass : #BrStencil,
	#instVars : [
		'item',
		'dropdown'
	],
	#category : #'GToolkit-Coder-UI - Stencils'
}

{ #category : #'api - instantiation' }
GtCoderDropdownToggleStencil >> create [
	<return: #Object>

	^ BrButton new
		look: BrGlamorousLabelLook + BrGlamorousButtonIconLook + BrLayoutLook linearHorizontal fitContent;
		padding: (BlInsets top: 6 right: 8 bottom: 6 left: 15);
		label: self item asString;
		action: [ self dropdown toggle ];
		icon: (BlElement new
			size: 8@8;
			geometry:
			(BlPolygon
				vertices:
					{(0 @ 0).
					(8 @ 0).
					((8 / 2) rounded @ 8)});
			background: Color lightGray;
			margin: (BlInsets left: 12 right: 10);
			constraintsDo: [ :c | c linear vertical alignCenter ])
]

{ #category : #accessing }
GtCoderDropdownToggleStencil >> dropdown [
	^ dropdown
]

{ #category : #accessing }
GtCoderDropdownToggleStencil >> dropdown: anObject [
	dropdown := anObject
]

{ #category : #accessing }
GtCoderDropdownToggleStencil >> item [
	^ item
]

{ #category : #accessing }
GtCoderDropdownToggleStencil >> item: anObject [
	item := anObject
]
