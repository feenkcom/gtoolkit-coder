Class {
	#name : #GtClassCoderSlotsAdded,
	#superclass : #GtClassCoderAnnouncement,
	#instVars : [
		'slots'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtClassCoderSlotsAdded >> slots [
	^ slots
]

{ #category : #accessing }
GtClassCoderSlotsAdded >> slots: anObject [
	slots := anObject
]
