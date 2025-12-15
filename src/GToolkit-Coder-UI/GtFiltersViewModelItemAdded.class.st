Class {
	#name : #GtFiltersViewModelItemAdded,
	#superclass : #GtFiltersViewModelAnnouncement,
	#instVars : [
		'item'
	],
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFiltersViewModelItemAdded >> item [
	^ item
]

{ #category : #accessing }
GtFiltersViewModelItemAdded >> item: anObject [
	item := anObject
]
