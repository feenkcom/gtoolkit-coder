Class {
	#name : #GtFilterSettingsElement,
	#superclass : #BlElement,
	#traits : 'TGtWithFilterViewModel + TBrLayoutResizable',
	#classTraits : 'TGtWithFilterViewModel classTrait + TBrLayoutResizable classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #initialization }
GtFilterSettingsElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtFilterSettingsElement >> initialize [
	super initialize.
	self fitContent
]

{ #category : #'api - filter view model' }
GtFilterSettingsElement >> unsubscribeFromFilterViewModel [
	self filterViewModel unsubscribe: self
]
