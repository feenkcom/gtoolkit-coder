Class {
	#name : #GtFilterBooleanModelSwitchChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'switchedOn'
	],
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #testing }
GtFilterBooleanModelSwitchChanged >> changesFilteredResult [
	"Indicates whether it changes a result of filtered items, e.g., list of method coders."

	^ true
]

{ #category : #testing }
GtFilterBooleanModelSwitchChanged >> isOff [
	^ self switchedOn not
]

{ #category : #testing }
GtFilterBooleanModelSwitchChanged >> isOn [
	^ self switchedOn
]

{ #category : #accessing }
GtFilterBooleanModelSwitchChanged >> switchedOn [
	<return: #Boolean>
	^ switchedOn
]

{ #category : #accessing }
GtFilterBooleanModelSwitchChanged >> switchedOn: aBoolean [
	switchedOn := aBoolean
]
