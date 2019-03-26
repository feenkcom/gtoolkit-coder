Class {
	#name : #GtCoderPackagesTreeNavigation,
	#superclass : #GtCoderNavigationModel,
	#category : #'GToolkit-Coder'
}

{ #category : #converting }
GtCoderPackagesTreeNavigation >> asElement [
	^ GtCoderNavigationPackagesTreeElement new
		navigationModel: self
]

{ #category : #accessing }
GtCoderPackagesTreeNavigation >> displayPosition [
	^ #left
]
