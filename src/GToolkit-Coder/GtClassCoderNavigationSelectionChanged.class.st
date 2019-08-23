Class {
	#name : #GtClassCoderNavigationSelectionChanged,
	#superclass : #Announcement,
	#instVars : [
		'selectedObject'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtClassCoderNavigationSelectionChanged >> selectedObject [
	^ selectedObject
]

{ #category : #accessing }
GtClassCoderNavigationSelectionChanged >> selectedObject: anObject [
	selectedObject := anObject
]
