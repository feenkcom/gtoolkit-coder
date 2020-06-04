Class {
	#name : #GtCoderNavigationTagSelected,
	#superclass : #GtCoderNavigationSelectionAnnouncement,
	#instVars : [
		'package',
		'tag'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationTagSelected >> package [
	^ package
]

{ #category : #accessing }
GtCoderNavigationTagSelected >> package: anObject [
	package := anObject
]

{ #category : #accessing }
GtCoderNavigationTagSelected >> tag [
	<return: #RPackageTag>

	^ tag
]

{ #category : #accessing }
GtCoderNavigationTagSelected >> tag: anObject [
	tag := anObject
]
