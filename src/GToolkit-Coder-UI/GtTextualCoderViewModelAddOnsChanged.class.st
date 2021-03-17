Class {
	#name : #GtTextualCoderViewModelAddOnsChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'addOns'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #accessing }
GtTextualCoderViewModelAddOnsChanged >> addOns [
	^ addOns
]

{ #category : #accessing }
GtTextualCoderViewModelAddOnsChanged >> addOns: anObject [
	addOns := anObject
]
