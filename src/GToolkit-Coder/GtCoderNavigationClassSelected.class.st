Class {
	#name : #GtCoderNavigationClassSelected,
	#superclass : #GtCoderNavigationSelectionAnnouncement,
	#instVars : [
		'theClass',
		'package',
		'tag',
		'viewReset'
	],
	#category : #'GToolkit-Coder-Navigation - Events'
}

{ #category : #accessing }
GtCoderNavigationClassSelected >> initialize [
	super initialize.
	viewReset := false
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> package [
	^ package
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> package: anObject [
	package := anObject
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

{ #category : #'as yet unclassified' }
GtCoderNavigationClassSelected >> viewReset [
	^ viewReset
]

{ #category : #accessing }
GtCoderNavigationClassSelected >> viewReset: aBoolean [ 
	viewReset := aBoolean
]
