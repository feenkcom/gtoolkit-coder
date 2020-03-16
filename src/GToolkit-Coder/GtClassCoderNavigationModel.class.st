Class {
	#name : #GtClassCoderNavigationModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'classCoder',
		'announcer',
		'selectedObject'
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
	selectedObject := classToSelect.
	classToSelect ~= self theClass
		ifTrue: [ classCoder forClass: classToSelect ]
]

{ #category : #actions }
GtClassCoderNavigationModel >> selectInCoderPackage: aPackage [
	selectedObject := aPackage.
	classCoder updateForPackage: aPackage
]

{ #category : #accessing }
GtClassCoderNavigationModel >> selectedObject [
	^ selectedObject
]

{ #category : #accessing }
GtClassCoderNavigationModel >> theClass [
	^ classCoder theClass
]

{ #category : #'as yet unclassified' }
GtClassCoderNavigationModel >> updateSelectionWith: aClassOrPackage [
	"Notify the navigation model to visually update the selected class, 
	when the selected class changed in coder, for example as a result of a search".
	selectedObject := aClassOrPackage.
	self announcer announce: (GtClassCoderNavigationSelectionChanged new
		selectedObject: selectedObject)
]
