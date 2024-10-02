Class {
	#name : #GtFilterModelAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #testing }
GtFilterModelAnnouncement >> changesFilteredResult [
	"Indicates whether it changes a result of filtered items, e.g., list of method coders."

	^ false
]

{ #category : #accessing }
GtFilterModelAnnouncement >> model [
	^ model
]

{ #category : #accessing }
GtFilterModelAnnouncement >> model: anObject [
	model := anObject
]
