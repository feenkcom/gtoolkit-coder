"
I am sent by the ${class:GtClassCoder}$ when the class changes, e.g. we edit a different class
"
Class {
	#name : #GtCoderClassUpdatedAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder-Announcements'
}

{ #category : #'instance creation' }
GtCoderClassUpdatedAnnouncement class >> forClass: aClass [
	^ self new
		classOrMetaClass: aClass;
		yourself
]

{ #category : #accessing }
GtCoderClassUpdatedAnnouncement >> classOrMetaClass [
	^ class
]

{ #category : #accessing }
GtCoderClassUpdatedAnnouncement >> classOrMetaClass: aClass [
	class := aClass
]
