Class {
	#name : #GtFiltersChangedEvent,
	#superclass : #BlEvent,
	#instVars : [
		'filterElement',
		'reason'
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

{ #category : #accessing }
GtFiltersChangedEvent >> reason [

	^ reason
]

{ #category : #accessing }
GtFiltersChangedEvent >> reason: anObject [

	reason := anObject
]
