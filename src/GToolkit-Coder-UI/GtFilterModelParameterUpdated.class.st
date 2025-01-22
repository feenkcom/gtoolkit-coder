"
I am announced when a parameter is is changed, implying new {{gtClass:GtSearchFilter}} results.
"
Class {
	#name : #GtFilterModelParameterUpdated,
	#superclass : #GtFilterModelAnnouncement,
	#instVars : [
		'originalAnnouncement'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #testing }
GtFilterModelParameterUpdated >> changesFilteredResult [
	^ self originalAnnouncement changesFilteredResult
]

{ #category : #accessing }
GtFilterModelParameterUpdated >> originalAnnouncement [
	^ originalAnnouncement
]

{ #category : #accessing }
GtFilterModelParameterUpdated >> originalAnnouncement: anAnnouncement [
	originalAnnouncement := anAnnouncement
]

{ #category : #accessing }
GtFilterModelParameterUpdated >> parameterModel [
	self originalAnnouncement ifNotNil: #model
]
