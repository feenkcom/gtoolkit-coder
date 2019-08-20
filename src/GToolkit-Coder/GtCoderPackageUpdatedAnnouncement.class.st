Class {
	#name : #GtCoderPackageUpdatedAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtCoderPackageUpdatedAnnouncement >> package [
	^ package
]

{ #category : #accessing }
GtCoderPackageUpdatedAnnouncement >> package: aRPackage [
	package := aRPackage
]
