Class {
	#name : #GtCoderNavigationPackageAnnouncement,
	#superclass : #GtCoderNavigationSystemChangesAnnouncement,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationPackageAnnouncement class >> package: aRPackage [
	^ self new package: aRPackage
]

{ #category : #accessing }
GtCoderNavigationPackageAnnouncement >> package [
	^ package
]

{ #category : #accessing }
GtCoderNavigationPackageAnnouncement >> package: anObject [
	package := anObject
]
