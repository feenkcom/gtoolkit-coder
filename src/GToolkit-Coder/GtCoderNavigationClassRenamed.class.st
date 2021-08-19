Class {
	#name : 'GtCoderNavigationClassRenamed',
	#superclass : 'GtCoderNavigationClassAnnoucement',
	#instVars : [
		'oldName',
		'newName'
	],
	#category : 'GToolkit-Coder-Navigation - Events'
}

{ #category : 'accessing' }
GtCoderNavigationClassRenamed >> newName [
	^ newName
]

{ #category : 'accessing' }
GtCoderNavigationClassRenamed >> newName: anObject [
	newName := anObject
]

{ #category : 'accessing' }
GtCoderNavigationClassRenamed >> oldName [
	^ oldName
]

{ #category : 'accessing' }
GtCoderNavigationClassRenamed >> oldName: anObject [
	oldName := anObject
]
