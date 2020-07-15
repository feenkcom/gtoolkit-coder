Class {
	#name : #GtCoderNavigationPackageTagSelected,
	#superclass : #GtCoderNavigationSelectionAnnouncement,
	#instVars : [
		'package',
		'tag'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationPackageTagSelected >> package [
	^ package
]

{ #category : #accessing }
GtCoderNavigationPackageTagSelected >> package: anObject [
	package := anObject
]

{ #category : #accessing }
GtCoderNavigationPackageTagSelected >> tag [
	<return: #RPackageTag>

	^ tag
]

{ #category : #accessing }
GtCoderNavigationPackageTagSelected >> tag: anObject [
	tag := anObject
]
