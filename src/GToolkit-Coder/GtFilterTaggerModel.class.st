Class {
	#name : #GtFilterTaggerModel,
	#superclass : #BrTaggerModel,
	#instVars : [
		'defaultTagType',
		'tagTypes'
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

{ #category : #'api - tags' }
GtFilterTaggerModel >> tagClass [
	^ GtFilterTaggerTag
]

{ #category : #accessing }
GtFilterTaggerModel >> tagTypes [
	^ tagTypes
]

{ #category : #accessing }
GtFilterTaggerModel >> tagTypes: aCollection [
	tagTypes := aCollection
]
