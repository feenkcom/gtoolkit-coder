Class {
	#name : #GtClassCoderPackagesTreeNavigation,
	#superclass : #GtClassCoderNavigationModel,
	#instVars : [
		'packagesFilterString'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #converting }
GtClassCoderPackagesTreeNavigation >> asElement [
	^ GtCoderNavigationPackagesTreeElement new
		navigationModel: self
]

{ #category : #accessing }
GtClassCoderPackagesTreeNavigation >> displayPosition [
	^ #left
]

{ #category : #accessing }
GtClassCoderPackagesTreeNavigation >> packagesFilterString [
	^ packagesFilterString
]

{ #category : #accessing }
GtClassCoderPackagesTreeNavigation >> packagesFilterString: aString [
	packagesFilterString := aString
]
