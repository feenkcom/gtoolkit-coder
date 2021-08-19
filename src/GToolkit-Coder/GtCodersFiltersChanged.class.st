Class {
	#name : 'GtCodersFiltersChanged',
	#superclass : 'GtCodersAnnouncement',
	#instVars : [
		'filters'
	],
	#category : 'GToolkit-Coder-Event'
}

{ #category : 'accessing' }
GtCodersFiltersChanged >> filters [
	^ filters
]

{ #category : 'accessing' }
GtCodersFiltersChanged >> filters: anObject [
	filters := anObject
]

{ #category : 'accessing' }
GtCodersFiltersChanged >> gtFiltesFor: aView [
	<gtView>
	self filters ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Filters';
		items: [ self filters ]
]
