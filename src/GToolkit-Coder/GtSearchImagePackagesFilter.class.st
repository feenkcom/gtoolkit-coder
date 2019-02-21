Class {
	#name : #GtSearchImagePackagesFilter,
	#superclass : #GtSearchPackagesFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #comparing }
GtSearchImagePackagesFilter >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ true
]

{ #category : #accessing }
GtSearchImagePackagesFilter >> defaultFilterScope [
	^ self
]

{ #category : #testing }
GtSearchImagePackagesFilter >> includesPackage: aPackage [
	^ RPackage organizer includesPackage: aPackage 
]

{ #category : #enumerating }
GtSearchImagePackagesFilter >> itemsDo: aBlock [
	^ self packagesDo: aBlock
]

{ #category : #enumerating }
GtSearchImagePackagesFilter >> packagesDo: aBlock [
	RPackageOrganizer default packages do: aBlock
]
