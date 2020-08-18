Class {
	#name : #GtFilterTaggerModel,
	#superclass : #BrTaggerModel,
	#instVars : [
		'defaultTagType',
		'descriptors'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #'api - tags' }
GtFilterTaggerModel >> createTagNamed: aTagName [
	^ self tagClass new
		name: aTagName;
		tagType: self defaultTagType;
		yourself
]

{ #category : #accessing }
GtFilterTaggerModel >> defaultTagType [
	^ defaultTagType
]

{ #category : #accessing }
GtFilterTaggerModel >> defaultTagType: aString [
	defaultTagType := aString
]

{ #category : #accessing }
GtFilterTaggerModel >> descriptors [
	^ descriptors
]

{ #category : #accessing }
GtFilterTaggerModel >> descriptors: aCollection [
	descriptors := aCollection
]

{ #category : #'api - tags' }
GtFilterTaggerModel >> tagClass [
	^ GtFilterTaggerTag
]

{ #category : #accessing }
GtFilterTaggerModel >> tagTypes [
	^ descriptors collect: [ :each | each name ]
]
