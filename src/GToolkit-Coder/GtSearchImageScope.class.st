Class {
	#name : #GtSearchImageScope,
	#superclass : #GtSearchCodeScope,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #enumerating }
GtSearchImageScope >> classesDo: aBlock [
	self flag: 'how to handle traits?'.
	Smalltalk allClassesAndTraitsDo: [ :each | 
		aBlock value: each ]
]
