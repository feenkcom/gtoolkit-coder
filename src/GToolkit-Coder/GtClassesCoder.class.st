Class {
	#name : #GtClassesCoder,
	#superclass : #GtCoders,
	#category : #'GToolkit-Coder-Coders'
}

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
