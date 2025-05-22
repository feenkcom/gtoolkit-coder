Class {
	#name : #GtCoderNavigationClassSelected,
	#superclass : #GtCoderNavigationSelectionAnnouncement,
	#instVars : [
		'theClass',
		'package',
		'tag',
		'selectedClasses'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationClassSelected >> package [
	^ package
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> package: anObject [
	package := anObject
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> selectedClasses [
	^ selectedClasses
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> selectedClasses: anObject [
	selectedClasses := anObject
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> tag [
	^ tag
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> tag: anObject [
	tag := anObject
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> theClass [
	<return: #Class>

	^ theClass
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> theClass: anObject [
	theClass := anObject
]
