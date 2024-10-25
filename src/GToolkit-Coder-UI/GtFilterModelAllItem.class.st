Class {
	#name : #GtFilterModelAllItem,
	#superclass : #GtFilterModelItem,
	#instVars : [
		'label'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #factory }
GtFilterModelAllItem class >> default [
	^ self new
]

{ #category : #factory }
GtFilterModelAllItem class >> methodsLabel [
	^ self new label: 'All methods'
]

{ #category : #accessing }
GtFilterModelAllItem >> ifSome: aBlock ifNone: aNoneBlock [
	^ aNoneBlock value
]

{ #category : #initialization }
GtFilterModelAllItem >> initialize [
	super initialize.
	label := 'All'
]

{ #category : #accessing }
GtFilterModelAllItem >> label [
	^ 'All'
]

{ #category : #factory }
GtFilterModelAllItem >> label: aString [ 
]

{ #category : #convenience }
GtFilterModelAllItem >> withAll: aCollection [
	^ Array with: self withAll: aCollection
]
