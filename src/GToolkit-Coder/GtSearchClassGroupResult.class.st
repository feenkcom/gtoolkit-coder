Class {
	#name : #GtSearchClassGroupResult,
	#superclass : #GtSearchGroupResult,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #ui }
GtSearchClassGroupResult >> gtLiveFor: aView [
	<gtView>
	self refreshClasses.
	^ aView list 
		title: 'Classes';
		priority: 10;
		items: [ items ifNil: [ #() ] ]
]

{ #category : #enumerating }
GtSearchClassGroupResult >> refreshClasses [
	| classes |
	filtered
		ifTrue: [ ^ self ].
	classes := OrderedCollection new.
	filter ifNotNil: [ 
		scope classesDo: [ :aClass | 
			(filter matches: aClass) ifTrue: [
				classes add: aClass ] ] ].
	classes
		sort: [ :a :b | a name < b name ].
	items := classes.
	filtered := true.
]

{ #category : #enumerating }
GtSearchClassGroupResult >> refreshItems [
	self refreshClasses
]
