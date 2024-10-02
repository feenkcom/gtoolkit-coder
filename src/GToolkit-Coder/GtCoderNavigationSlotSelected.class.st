Class {
	#name : #GtCoderNavigationSlotSelected,
	#superclass : #GtCoderNavigationSelectionAnnouncement,
	#instVars : [
		'slot'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationSlotSelected >> slot [
	^ slot
]

{ #category : #accessing }
GtCoderNavigationSlotSelected >> slot: anObject [
	slot := anObject
]
