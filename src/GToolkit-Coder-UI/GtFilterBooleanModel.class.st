Class {
	#name : #GtFilterBooleanModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'switchedOn'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterBooleanModel >> filterViewModelClass [
	^ GtFilterBooleanViewModel
]

{ #category : #'initialization ' }
GtFilterBooleanModel >> initialize [
	super initialize.
	switchedOn := false
]

{ #category : #testing }
GtFilterBooleanModel >> isSwitchedOff [
	^ self isSwitchedOn not
]

{ #category : #testing }
GtFilterBooleanModel >> isSwitchedOn [
	^ switchedOn
]

{ #category : #'private - notifying' }
GtFilterBooleanModel >> notifySwitchChanged [
	self
		announce: (GtFilterBooleanModelSwitchChanged new
				model: self;
				switchedOn: self isSwitchedOn)
]

{ #category : #accessing }
GtFilterBooleanModel >> selectedValue [
	"Return a filter value, e.g., selected item, input text."

	^ self switchedOn
]

{ #category : #accessing }
GtFilterBooleanModel >> switchedOn [
	<return: #Boolean>
	^ switchedOn
]

{ #category : #accessing }
GtFilterBooleanModel >> switchedOn: aBoolean [
	self switchedOn = aBoolean ifTrue: [ ^ self ].

	switchedOn := aBoolean.
	self notifySwitchChanged
]
