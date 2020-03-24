Class {
	#name : #GtClassCoderSlotChanged,
	#superclass : #GtClassCoderAnnouncement,
	#instVars : [
		'oldSlot',
		'newSlot'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtClassCoderSlotChanged >> newSlot [
	^ newSlot
]

{ #category : #accessing }
GtClassCoderSlotChanged >> newSlot: anObject [
	newSlot := anObject
]

{ #category : #accessing }
GtClassCoderSlotChanged >> oldSlot [
	^ oldSlot
]

{ #category : #accessing }
GtClassCoderSlotChanged >> oldSlot: anObject [
	oldSlot := anObject
]
