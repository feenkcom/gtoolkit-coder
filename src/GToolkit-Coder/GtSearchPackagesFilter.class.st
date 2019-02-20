Class {
	#name : #GtSearchPackagesFilter,
	#superclass : #GtSearchFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #accessing }
GtSearchPackagesFilter >> highlighter [
	^ nil
]

{ #category : #testing }
GtSearchPackagesFilter >> includesPackage: aPackage [
	self subclassResponsibility
]

{ #category : #testing }
GtSearchPackagesFilter >> matches: anObject [
	^ self includesPackage: anObject
]

{ #category : #accessing }
GtSearchPackagesFilter >> resultType [
	^ GtSearchPackagesGroupResult 
]
