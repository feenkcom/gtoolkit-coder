Class {
	#name : #GtFilterItemsElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #initialization }
GtFilterItemsElement >> defaultLayout [
	^ BlFlowLayout horizontal
]

{ #category : #initialization }
GtFilterItemsElement >> initialize [
	super initialize.
	self hFitContentLimited.
	self vFitContent
]
