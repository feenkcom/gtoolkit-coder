Class {
	#name : #GtCoderToolViewModelCoderStackChanged,
	#superclass : #Announcement,
	#instVars : [
		'coderViewModel'
	],
	#category : #'GToolkit-Coder-UI-! Core - View Models'
}

{ #category : #accessing }
GtCoderToolViewModelCoderStackChanged >> coderViewModel [
	^ coderViewModel
]

{ #category : #accessing }
GtCoderToolViewModelCoderStackChanged >> coderViewModel: anObject [
	coderViewModel := anObject
]
