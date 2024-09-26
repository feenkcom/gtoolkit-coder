Class {
	#name : #GtFilterViewModelLabelChanged,
	#superclass : #GtFilterViewModelAnnouncement,
	#instVars : [
		'label'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterViewModelLabelChanged >> label [
	^ label
]

{ #category : #accessing }
GtFilterViewModelLabelChanged >> label: anObject [
	label := anObject
]
