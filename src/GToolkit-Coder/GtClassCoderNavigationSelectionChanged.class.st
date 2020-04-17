Class {
	#name : #GtClassCoderNavigationSelectionChanged,
	#superclass : #Announcement,
	#instVars : [
		'selectedObject'
	],
	#category : #'GToolkit-Coder-Navigation'
}

{ #category : #accessing }
GtClassCoderNavigationSelectionChanged >> selectedObject [
	^ selectedObject
]

{ #category : #accessing }
GtClassCoderNavigationSelectionChanged >> selectedObject: anObject [
	selectedObject := anObject
]
