Class {
	#name : #GtMagritteCreateForm,
	#superclass : #BrFrame,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'description'
	],
	#category : #'GToolkit-Coder-UI-Forms'
}

{ #category : #'instance creation' }
GtMagritteCreateForm class >> forBaseline: aBaseline [
	^ self forDescription: (GtBaselineDescription forBaseline: aBaseline)
]

{ #category : #'instance creation' }
GtMagritteCreateForm class >> forDescription: aDescription [
	^ self new description: aDescription
]

{ #category : #'instance creation' }
GtMagritteCreateForm class >> forPackage: aPackage [
	^ self forDescription: (GtPackageDescription forPackage: aPackage)
]

{ #category : #converting }
GtMagritteCreateForm >> createForm [
	^ self description asGtMagritteViewModel asElement
]

{ #category : #accessing }
GtMagritteCreateForm >> description [

	^ description
]

{ #category : #accessing }
GtMagritteCreateForm >> description: anObject [
	description := anObject.

	self removeChildren.
	self addChild: self createForm
]

{ #category : #initialization }
GtMagritteCreateForm >> initialize [
	super initialize.
		
	self layout: BlFlowLayout vertical.
	self margin: (BlInsets all: 5).
	self
		constraintsDo: [ :c | 
			c horizontal exact: 400.
			c vertical fitContent ]
]
