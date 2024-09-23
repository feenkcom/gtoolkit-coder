Class {
	#name : #GtFilterTextModelInputFilterChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'inputFilter'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterTextModelInputFilterChanged >> inputFilter [
	^ inputFilter
]

{ #category : #accessing }
GtFilterTextModelInputFilterChanged >> inputFilter: anObject [
	inputFilter := anObject
]
