Class {
	#name : #GtClassCoderSlotRemoved,
	#superclass : #GtClassCoderAnnouncement,
	#instVars : [
		'slot'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtClassCoderSlotRemoved >> slot [
	^ slot
]

{ #category : #accessing }
GtClassCoderSlotRemoved >> slot: anObject [
	slot := anObject
]
