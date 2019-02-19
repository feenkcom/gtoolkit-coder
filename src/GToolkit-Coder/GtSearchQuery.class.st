Class {
	#name : #GtSearchQuery,
	#superclass : #Object,
	#instVars : [
		'scope'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #accessing }
GtSearchQuery class >> resultType [
	self subclassResponsibility
]

{ #category : #execution }
GtSearchQuery >> buildResult: aQueryResult [
	self subclassResponsibility 
]

{ #category : #execution }
GtSearchQuery >> execute [
	^ self resultType new
		buildingQuery: self
]

{ #category : #accessing }
GtSearchQuery >> resultType [
	^ self class resultType
]

{ #category : #accessing }
GtSearchQuery >> scope [
	^ scope
]

{ #category : #accessing }
GtSearchQuery >> scope: aSearchScope [
	scope := aSearchScope
]
