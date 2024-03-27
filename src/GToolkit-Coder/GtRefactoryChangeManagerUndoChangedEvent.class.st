Class {
	#name : #GtRefactoryChangeManagerUndoChangedEvent,
	#superclass : #Announcement,
	#instVars : [
		'changeManager'
	],
	#category : #'GToolkit-Coder-Refactoring'
}

{ #category : #accessing }
GtRefactoryChangeManagerUndoChangedEvent >> changeManager [
	^ changeManager
]

{ #category : #accessing }
GtRefactoryChangeManagerUndoChangedEvent >> changeManager: anObject [
	changeManager := anObject
]
