Class {
	#name : #GtCoder,
	#superclass : #Announcer,
	#instVars : [
		'searchFilter',
		'navigationModel',
		'classCoder'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #elements }
GtCoder >> asElement [
	| coderElement |
	coderElement := GtCoderElement new coderModel: self.
	^ coderElement asScrollableElement
]

{ #category : #initialize }
GtCoder >> class: aClass [
	classCoder := GtClassCoder forClass: aClass
]

{ #category : #accessing }
GtCoder >> classCoder [
	^ classCoder
]

{ #category : #initialize }
GtCoder >> initialize [
	super initialize.
	searchFilter := GtCoderClassSelector new
		coder: self.
]

{ #category : #accessing }
GtCoder >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtCoder >> navigationModel: aNavigationModel [
	navigationModel := aNavigationModel.
	navigationModel coderModel: self
]

{ #category : #accessing }
GtCoder >> searchFilter [
	^ searchFilter
]

{ #category : #updating }
GtCoder >> selectClass: aClass [
	classCoder := GtClassCoder forClass: aClass.
	self announce: (GtCoderClassSelectedAnnouncement forClass: aClass)
]

{ #category : #accessing }
GtCoder >> theClass [
	^ self classCoder 
		ifNil: [ nil ] 
		ifNotNil: [ :aClassCoder | aClassCoder theClass ]
]
