"
I am sent by the ${class:GtBehaviorCoder}$ when the current package changes (means class is not selected and we have to remove the content from the class coder)
"
Class {
	#name : #GtCoderPackageUpdatedAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'package'
	],
	#category : #'GToolkit-Coder-Announcements'
}

{ #category : #accessing }
GtCoderPackageUpdatedAnnouncement >> package [
	^ package
]

{ #category : #accessing }
GtCoderPackageUpdatedAnnouncement >> package: aRPackage [
	package := aRPackage
]
