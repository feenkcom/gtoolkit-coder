Class {
	#name : #GtCoderDropdownStencil,
	#superclass : #BrStencil,
	#instVars : [
		'allItems',
		'initialItem'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderDropdownStencil >> allItems [
	^ allItems
]

{ #category : #accessing }
GtCoderDropdownStencil >> allItems: anObject [
	allItems := anObject
]

{ #category : #'api - instantiation' }
GtCoderDropdownStencil >> create [
	<return: #Object>
	| aDropdown |

	aDropdown := BrDropdown new.
	aDropdown
		layout: BlLinearLayout horizontal;
		relocate: 200@100;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		toggle: [ GtCoderDropdownToggleStencil new dropdown: aDropdown; item: self initialItem ];
		popup: [ GtCoderDropdownListStencil new items: self allItems ];
		look: (BrDropdownLook new outskirtsEmbellisher: [ :e | e look: BrDropdownOutskirtsLook new ]).

	^ aDropdown
]

{ #category : #accessing }
GtCoderDropdownStencil >> initialItem [
	^ initialItem
]

{ #category : #accessing }
GtCoderDropdownStencil >> initialItem: anObject [
	initialItem := anObject
]
