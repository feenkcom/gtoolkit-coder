Class {
	#name : #GtClassCoderPackagesAndHierarchyNavigation,
	#superclass : #GtClassCoderPackagesTreeNavigation,
	#category : #'GToolkit-Coder'
}

{ #category : #converting }
GtClassCoderPackagesAndHierarchyNavigation >> asElement [
	^ GtCoderNavigationPackagesAndHierarchyElement new
		navigationModel: self
]
