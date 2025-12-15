Class {
	#name : #GtFiltersModelItemRemoved,
	#superclass : #GtFiltersModelAnnouncement,
	#instVars : [
		'item'
	],
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFiltersModelItemRemoved >> item [
	^ item
]

{ #category : #accessing }
GtFiltersModelItemRemoved >> item: anObject [
	item := anObject
]
