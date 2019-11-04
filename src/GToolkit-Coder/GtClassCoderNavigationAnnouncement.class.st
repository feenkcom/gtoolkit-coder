Class {
	#name : #GtClassCoderNavigationAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'navigationTab'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtClassCoderNavigationAnnouncement >> navigationTab [
	^ navigationTab
]

{ #category : #accessing }
GtClassCoderNavigationAnnouncement >> navigationTab: aSymbol [
	navigationTab := aSymbol
]
