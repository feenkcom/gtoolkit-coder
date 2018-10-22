Class {
	#name : #GtCoderReferencesFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'object',
		'specialSelectorIndex'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtCoderReferencesFilter class >> literal: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : #testing }
GtCoderReferencesFilter >> includeMethod: aCompiledMethod [
	^ aCompiledMethod hasSelector: object specialSelectorIndex: specialSelectorIndex
]

{ #category : #accessing }
GtCoderReferencesFilter >> object [
	^ object
]

{ #category : #accessing }
GtCoderReferencesFilter >> object: anObject [
	object := anObject.
	specialSelectorIndex := Smalltalk specialSelectorIndexOrNil: anObject
]
