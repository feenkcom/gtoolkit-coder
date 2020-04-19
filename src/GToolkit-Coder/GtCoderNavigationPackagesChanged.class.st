Class {
	#name : #GtCoderNavigationPackagesChanged,
	#superclass : #GtCoderNavigationAnnouncement,
	#instVars : [
		'packages'
	],
	#category : #'GToolkit-Coder-Navigation'
}

{ #category : #accessing }
GtCoderNavigationPackagesChanged >> packages [
	<return: #Collection of: #RPackage>

	^ packages
]

{ #category : #accessing }
GtCoderNavigationPackagesChanged >> packages: anObject [
	packages := anObject
]
