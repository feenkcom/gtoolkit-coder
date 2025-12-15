Class {
	#name : #GtFiltersModelItemAdded,
	#superclass : #GtFiltersModelAnnouncement,
	#instVars : [
		'item'
	],
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFiltersModelItemAdded >> item [
	^ item
]

{ #category : #accessing }
GtFiltersModelItemAdded >> item: anObject [
	item := anObject
]
