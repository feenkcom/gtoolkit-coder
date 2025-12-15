Class {
	#name : #GtFilterModelLabelChanged,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'label'
	],
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterModelLabelChanged >> label [
	^ label
]

{ #category : #accessing }
GtFilterModelLabelChanged >> label: anObject [
	label := anObject
]

{ #category : #accessing }
GtFilterModelLabelChanged >> name [
	^ label
]

{ #category : #accessing }
GtFilterModelLabelChanged >> name: aString [
	label := aString
]
