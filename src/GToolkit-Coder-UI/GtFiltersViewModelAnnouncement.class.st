Class {
	#name : #GtFiltersViewModelAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'viewModel'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFiltersViewModelAnnouncement >> viewModel [
	^ viewModel
]

{ #category : #accessing }
GtFiltersViewModelAnnouncement >> viewModel: anObject [
	viewModel := anObject
]
