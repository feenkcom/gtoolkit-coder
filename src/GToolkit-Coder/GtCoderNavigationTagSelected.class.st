Class {
	#name : #GtCoderNavigationTagSelected,
	#superclass : #GtCoderNavigationAnnouncement,
	#instVars : [
		'tag'
	],
	#category : #'GToolkit-Coder-Navigation'
}

{ #category : #accessing }
GtCoderNavigationTagSelected >> tag [
	<return: #RPackageTag>

	^ tag
]

{ #category : #accessing }
GtCoderNavigationTagSelected >> tag: anObject [
	tag := anObject
]
