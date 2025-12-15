Class {
	#name : #GtFilterSuffixLabelElement,
	#superclass : #GtFilterLabelElement,
	#category : 'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #'as yet unclassified' }
GtFilterSuffixLabelElement >> initialize [
	super initialize.
	self padding: (BlInsets top: 0 right: 2 bottom: 0 left: 0).
	
	self addChild: settingsContainer as: #container.
	self addChild: labelElement
]
