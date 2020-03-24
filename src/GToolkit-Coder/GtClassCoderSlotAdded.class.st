Class {
	#name : #GtClassCoderSlotAdded,
	#superclass : #GtClassCoderAnnouncement,
	#instVars : [
		'slot'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtClassCoderSlotAdded >> slot [
	^ slot
]

{ #category : #accessing }
GtClassCoderSlotAdded >> slot: anObject [
	slot := anObject
]
