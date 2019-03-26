Class {
	#name : #GtCoderPackagesPanesNavigation,
	#superclass : #GtCoderNavigationModel,
	#category : #'GToolkit-Coder'
}

{ #category : #converting }
GtCoderPackagesPanesNavigation >> asElement [
	^ GtCoderNavigationPackagesPanesElement new
		navigationModel: self
]

{ #category : #accessing }
GtCoderPackagesPanesNavigation >> displayPosition [
	^ #top
]
