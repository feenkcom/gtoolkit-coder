Class {
	#name : #GtTextualCoderViewModelAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'textualCoderViewModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelAnnouncement >> textualCoderViewModel [
	^ textualCoderViewModel
]

{ #category : #accessing }
GtTextualCoderViewModelAnnouncement >> textualCoderViewModel: anObject [
	textualCoderViewModel := anObject
]
