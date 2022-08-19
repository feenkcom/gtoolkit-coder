Class {
	#name : #GtCoderNavigationPackageTagAnnouncement,
	#superclass : #GtCoderNavigationSystemChangesAnnouncement,
	#instVars : [
		'package',
		'tag'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationPackageTagAnnouncement >> package [
	^ package
]

{ #category : #accessing }
GtCoderNavigationPackageTagAnnouncement >> package: anObject [
	package := anObject
]

{ #category : #accessing }
GtCoderNavigationPackageTagAnnouncement >> tag [
	^ tag
]

{ #category : #accessing }
GtCoderNavigationPackageTagAnnouncement >> tag: anObject [
	tag := anObject
]
