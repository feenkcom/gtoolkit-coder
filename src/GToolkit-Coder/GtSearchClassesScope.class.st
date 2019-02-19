Class {
	#name : #GtSearchClassesScope,
	#superclass : #GtSearchCodeScope,
	#instVars : [
		'classes'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #environments }
GtSearchClassesScope class >> forClasses: aCollectionOfClasses [
	^ self new
		classes: aCollectionOfClasses
]

{ #category : #accessing }
GtSearchClassesScope >> classes: aCollectionOfClasses [
	classes := aCollectionOfClasses
]

{ #category : #enumerating }
GtSearchClassesScope >> classesDo: aBlock [
	classes do: aBlock 
]
