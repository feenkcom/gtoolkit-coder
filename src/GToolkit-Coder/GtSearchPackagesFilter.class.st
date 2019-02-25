Class {
	#name : #GtSearchPackagesFilter,
	#superclass : #GtSearchTypedEntitiesFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #accessing }
GtSearchPackagesFilter class >> resultType [
	^ GtSearchPackageGroupResult 
]

{ #category : #accessing }
GtSearchPackagesFilter >> defaultFilterScope [
	^ GtSearchImagePackagesFilter new
]

{ #category : #testing }
GtSearchPackagesFilter >> includesPackage: aPackage [
	self subclassResponsibility
]

{ #category : #testing }
GtSearchPackagesFilter >> matches: anObject [
	^ anObject class = RPackage and: [ 
		self includesPackage: anObject ]
]
