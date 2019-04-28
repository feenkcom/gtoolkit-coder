Class {
	#name : #GtCoderClassSelectedAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtCoderClassSelectedAnnouncement class >> forClass: aClass [
	^ self new
		classOrMetaClass: aClass;
		yourself
]

{ #category : #accessing }
GtCoderClassSelectedAnnouncement >> classOrMetaClass [
	^ class
]

{ #category : #accessing }
GtCoderClassSelectedAnnouncement >> classOrMetaClass: aClass [
	class := aClass
]
