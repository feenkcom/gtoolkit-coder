Class {
	#name : #GtFilterPrefixLabelElement,
	#superclass : #GtFilterLabelElement,
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #initialization }
GtFilterPrefixLabelElement >> initialize [
	super initialize.
	self padding: (BlInsets top: 0 right: 0 bottom: 0 left: 2).
	
	self addChild: labelElement.
	self addChild: settingsContainer as: #container
]

{ #category : #'private - updating' }
GtFilterPrefixLabelElement >> updateSettingsContainer [
	| someParameters someElements |
	super updateSettingsContainer.
	
	someParameters := self filterViewModel parameters.
	
	someParameters ifEmpty: [ ^ self ].
			
	someElements := someParameters collect: #asUserParametersElement.
	someElements do: [ :eachElement | 
		eachElement constraintsDo: [ :c | 
			c linear vertical alignCenter.
			c frame vertical alignCenter ] ].
	
	settingsContainer addChildren: someElements.
]
