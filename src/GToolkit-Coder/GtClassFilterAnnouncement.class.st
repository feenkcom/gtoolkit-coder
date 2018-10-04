Class {
	#name : #GtClassFilterAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtClassFilterAnnouncement class >> forClass: aClass [
	^ self new
		classOrMetaClass: aClass;
		yourself
]

{ #category : #accessing }
GtClassFilterAnnouncement >> classOrMetaClass [
	^ class
]

{ #category : #accessing }
GtClassFilterAnnouncement >> classOrMetaClass: aClass [
	class := aClass
]
