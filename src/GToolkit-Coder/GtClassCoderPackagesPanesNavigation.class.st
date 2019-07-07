Class {
	#name : #GtClassCoderPackagesPanesNavigation,
	#superclass : #GtClassCoderNavigationModel,
	#category : #'GToolkit-Coder'
}

{ #category : #converting }
GtClassCoderPackagesPanesNavigation >> asElement [
	^ GtCoderNavigationPackagesPanesElement new
		navigationModel: self
]

{ #category : #accessing }
GtClassCoderPackagesPanesNavigation >> displayPosition [
	^ #top
]
