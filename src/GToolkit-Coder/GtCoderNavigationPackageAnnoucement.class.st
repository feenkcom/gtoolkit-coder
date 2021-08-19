Class {
	#name : 'GtCoderNavigationPackageAnnoucement',
	#superclass : 'GtCoderNavigationSystemChangesAnnouncement',
	#instVars : [
		'package'
	],
	#category : 'GToolkit-Coder-Navigation - Events'
}

{ #category : 'accessing' }
GtCoderNavigationPackageAnnoucement class >> package: aRPackage [
	^ self new package: aRPackage
]

{ #category : 'accessing' }
GtCoderNavigationPackageAnnoucement >> package [
	^ package
]

{ #category : 'accessing' }
GtCoderNavigationPackageAnnoucement >> package: anObject [
	package := anObject
]
