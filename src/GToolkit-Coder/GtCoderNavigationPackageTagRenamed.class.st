Class {
	#name : #GtCoderNavigationPackageTagRenamed,
	#superclass : #GtCoderNavigationPackageAnnouncement,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationPackageTagRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtCoderNavigationPackageTagRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtCoderNavigationPackageTagRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtCoderNavigationPackageTagRenamed >> oldName: anObject [
	oldName := anObject
]
