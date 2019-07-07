Class {
	#name : #GtClassCoderPackagesTreeNavigation,
	#superclass : #GtClassCoderNavigationModel,
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
