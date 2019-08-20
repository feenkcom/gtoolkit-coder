Class {
	#name : #GtClassCoderNavigationModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'classCoder',
		'announcer'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtClassCoderNavigationModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtClassCoderNavigationModel >> classCoder [
	^ classCoder
]

{ #category : #accessing }
GtClassCoderNavigationModel >> classCoder: aClassCoder [
	classCoder := aClassCoder
]

{ #category : #accessing }
GtClassCoderNavigationModel >> displayPosition [
	self subclassResponsibility
]

{ #category : #actions }
GtClassCoderNavigationModel >> selectInCoderCategory: categoryToSelect [
	self flag: 'Remove combine the two class coders into one'.
	classCoder methodsCoder categoryFilterString: categoryToSelect
]

{ #category : #actions }
GtClassCoderNavigationModel >> selectInCoderClass: classToSelect [
	classToSelect ~= self theClass
		ifTrue: [ classCoder forClass: classToSelect ]
]

{ #category : #accessing }
GtClassCoderNavigationModel >> theClass [
	^ classCoder theClass
]
