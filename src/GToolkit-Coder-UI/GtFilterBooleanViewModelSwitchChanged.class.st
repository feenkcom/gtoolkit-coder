Class {
	#name : #GtFilterBooleanViewModelSwitchChanged,
	#superclass : #GtFilterViewModelAnnouncement,
	#instVars : [
		'switchedOn'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #testing }
GtFilterBooleanViewModelSwitchChanged >> isOff [
	^ self switchedOn not
]

{ #category : #testing }
GtFilterBooleanViewModelSwitchChanged >> isOn [
	^ self switchedOn
]

{ #category : #'as yet unclassified' }
GtFilterBooleanViewModelSwitchChanged >> switchedOn [
	<return: #Boolean>
	^ switchedOn
]

{ #category : #'as yet unclassified' }
GtFilterBooleanViewModelSwitchChanged >> switchedOn: aBoolean [
	switchedOn := aBoolean
]
