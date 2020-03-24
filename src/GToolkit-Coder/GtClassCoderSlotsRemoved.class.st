Class {
	#name : #GtClassCoderSlotsRemoved,
	#superclass : #GtClassCoderAnnouncement,
	#instVars : [
		'slots'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtClassCoderSlotsRemoved >> slots [
	^ slots
]

{ #category : #accessing }
GtClassCoderSlotsRemoved >> slots: anObject [
	slots := anObject
]
