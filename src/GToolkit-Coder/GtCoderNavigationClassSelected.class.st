Class {
	#name : #GtCoderNavigationClassSelected,
	#superclass : #GtCoderNavigationAnnouncement,
	#instVars : [
		'theClass'
	],
	#category : #'GToolkit-Coder-Navigation'
}

{ #category : #accessing }
GtCoderNavigationClassSelected >> theClass [
	<return: #Class>

	^ theClass
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> theClass: anObject [
	theClass := anObject
]
