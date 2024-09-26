Class {
	#name : #GtFilterTextViewModelInputFilterChanged,
	#superclass : #GtFilterViewModelAnnouncement,
	#instVars : [
		'inputFilter'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterTextViewModelInputFilterChanged >> inputFilter [
	^ inputFilter
]

{ #category : #accessing }
GtFilterTextViewModelInputFilterChanged >> inputFilter: anObject [
	inputFilter := anObject
]
