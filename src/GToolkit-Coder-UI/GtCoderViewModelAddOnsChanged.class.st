Class {
	#name : #GtCoderViewModelAddOnsChanged,
	#superclass : #Announcement,
	#instVars : [
		'addOns'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #accessing }
GtCoderViewModelAddOnsChanged >> addOns [
	^ addOns
]

{ #category : #accessing }
GtCoderViewModelAddOnsChanged >> addOns: anObject [
	addOns := anObject
]
