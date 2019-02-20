Class {
	#name : #GtSearchPackagesGroupResult,
	#superclass : #GtSearchGroupResult,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #ui }
GtSearchPackagesGroupResult >> gtLiveFor: aView [
	<gtView>
	self refreshPackages.
	^ aView list 
		title: 'Packages';
		priority: 10;
		items: [ items ifNil: [ #() ] ]
]

{ #category : #enumerating }
GtSearchPackagesGroupResult >> refreshItems [
	self refreshPackages
]

{ #category : #enumerating }
GtSearchPackagesGroupResult >> refreshPackages [
	| packages |
	filtered
		ifTrue: [ ^ self ].
	packages := OrderedCollection new.
	filter ifNotNil: [ 
		scope packagesDo: [ :aClass | 
			(filter matches: aClass) ifTrue: [
				packages add: aClass ] ] ].
	packages
		sort: [ :a :b | a name < b name ].
	items := packages.
	filtered := true.
]
