Class {
	#name : #GtSearchClassGroupResult,
	#superclass : #GtSearchTypedGroupResult,
	#category : #'GToolkit-Coder-Filters'
}

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
