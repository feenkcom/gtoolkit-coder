Class {
	#name : #GtCoderDropdownStencil,
	#superclass : #BrStencil,
	#instVars : [
		'allItems',
		'initialItem'
	],
	#category : #'GToolkit-Coder-UI - Stencils'
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
		relocate: 200 @ 100;
		look: BrGlamorousDropdownLook new;
		toggle: [ GtCoderDropdownToggleStencil new
				dropdown: aDropdown;
				item: self initialItem ];
		popup: [ GtCoderDropdownListStencil new items: self allItems ].
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
