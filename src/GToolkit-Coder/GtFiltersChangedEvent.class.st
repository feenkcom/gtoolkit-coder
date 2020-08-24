Class {
	#name : #GtFiltersChangedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'filterElement'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #accessing }
GtFiltersChangedEvent >> filterElement [
	^ filterElement
]

{ #category : #accessing }
GtFiltersChangedEvent >> filterElement: anElement [
	filterElement := anElement
]
