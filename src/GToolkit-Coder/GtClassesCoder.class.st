Class {
	#name : #GtClassesCoder,
	#superclass : #GtCoders,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtClassesCoder >> coderForClass: aClass [
	^ self coders
		detect: [ :each | each theClass = aClass ]
		ifNone: [ | coder |
			items add: aClass.
			coder := self newCoderFor: aClass.
			coders add: coder.
			coder ]
]

{ #category : #elements }
GtClassesCoder >> elementClass [
	^ GtClassesElement
]

{ #category : #updating }
GtClassesCoder >> forPackage: aPackage [
	items := aPackage definedClasses.
	self updateCoders
]

{ #category : #private }
GtClassesCoder >> newCoderFor: aClass [
	| coder |
	coder := GtClassCoder forClass: aClass.
	^ coder
]
