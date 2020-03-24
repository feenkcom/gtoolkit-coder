Class {
	#name : #GtClassCoderSlotsChanged,
	#superclass : #GtClassCoderAnnouncement,
	#instVars : [
		'oldSlots',
		'newSlots'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtClassCoderSlotsChanged >> newSlots [
	^ newSlots
]

{ #category : #accessing }
GtClassCoderSlotsChanged >> newSlots: anObject [
	newSlots := anObject
]

{ #category : #accessing }
GtClassCoderSlotsChanged >> oldSlots [
	^ oldSlots
]

{ #category : #accessing }
GtClassCoderSlotsChanged >> oldSlots: anObject [
	oldSlots := anObject
]
