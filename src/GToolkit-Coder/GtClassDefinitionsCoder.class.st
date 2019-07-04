Class {
	#name : #GtClassDefinitionsCoder,
	#superclass : #GtCoders,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtClassDefinitionsCoder class >> forClass: aClass [
	^ self new
		forClass: aClass;
		yourself
]

{ #category : #'instance creation' }
GtClassDefinitionsCoder >> forClass: aBehavior [
	self flag: 'FIXME should listen class definition change'.
	class := aBehavior.
	items ifEmpty: [ items := {class} ].
	items := items
		flatCollect: [ :e | 
			{(self newCoderFor: e instanceSide).
			(self newCoderFor: e classSide)} ]
]

{ #category : #'instance creation' }
GtClassDefinitionsCoder >> newCoderFor: aBehavior [
	^ GtClassDefinitionCoder forClass: aBehavior
]
