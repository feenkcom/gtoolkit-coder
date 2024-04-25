Class {
	#name : #GtSourceCoderViewModelAboutToOpenDebuggerAnnouncement,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'process',
		'exception'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtSourceCoderViewModelAboutToOpenDebuggerAnnouncement >> exception [
	^ exception
]

{ #category : #accessing }
GtSourceCoderViewModelAboutToOpenDebuggerAnnouncement >> exception: anObject [
	exception := anObject
]

{ #category : #accessing }
GtSourceCoderViewModelAboutToOpenDebuggerAnnouncement >> process [
	^ process
]

{ #category : #accessing }
GtSourceCoderViewModelAboutToOpenDebuggerAnnouncement >> process: anObject [
	process := anObject
]
