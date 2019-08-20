Class {
	#name : #GtCoderClassUpdatedAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder'
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
