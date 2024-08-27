Class {
	#name : #GtFilterViewModelAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'viewModel'
	],
	#category : #'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #accessing }
GtFilterViewModelAnnouncement >> viewModel [
	^ viewModel
]

{ #category : #accessing }
GtFilterViewModelAnnouncement >> viewModel: anObject [
	viewModel := anObject
]
