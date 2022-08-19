Class {
	#name : #GtCoderNavigationClassAnnouncement,
	#superclass : #GtCoderNavigationSystemChangesAnnouncement,
	#instVars : [
		'package',
		'tag',
		'theClass'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationClassAnnouncement >> package [
	^ package
]

{ #category : #accessing }
GtCoderNavigationClassAnnouncement >> package: anObject [
	package := anObject
]

{ #category : #accessing }
GtCoderNavigationClassAnnouncement >> tag [
	^ tag
]

{ #category : #accessing }
GtCoderNavigationClassAnnouncement >> tag: anObject [
	tag := anObject
]

{ #category : #accessing }
GtCoderNavigationClassAnnouncement >> theClass [
	^ theClass
]

{ #category : #accessing }
GtCoderNavigationClassAnnouncement >> theClass: anObject [
	theClass := anObject
]
