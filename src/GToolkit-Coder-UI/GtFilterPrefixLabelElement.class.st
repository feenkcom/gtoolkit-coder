Class {
	#name : #GtFilterPrefixLabelElement,
	#superclass : #GtFilterLabelElement,
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #'as yet unclassified' }
GtFilterPrefixLabelElement >> initialize [
	super initialize.
	self padding: (BlInsets top: 0 right: 0 bottom: 0 left: 2).
	
	self addChild: labelElement.
	self addChild: settingsContainer as: #container
]
