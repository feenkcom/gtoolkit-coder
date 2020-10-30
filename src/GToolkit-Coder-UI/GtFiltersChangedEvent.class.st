Class {
	#name : #GtFiltersChangedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'filterElement'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #accessing }
GtFiltersChangedEvent >> filterElement [
	^ filterElement
]

{ #category : #accessing }
GtFiltersChangedEvent >> filterElement: anElement [
	filterElement := anElement
]
