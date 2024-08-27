Class {
	#name : #GtFilterBooleanModelSwitchChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'switchedOn'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

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
