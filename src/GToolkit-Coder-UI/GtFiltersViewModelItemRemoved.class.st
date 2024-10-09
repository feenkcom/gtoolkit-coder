Class {
	#name : #GtFiltersViewModelItemRemoved,
	#superclass : #GtFiltersViewModelAnnouncement,
	#instVars : [
		'item'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFiltersViewModelItemRemoved >> item [
	^ item
]

{ #category : #accessing }
GtFiltersViewModelItemRemoved >> item: anObject [
	item := anObject
]
