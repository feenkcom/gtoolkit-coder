Class {
	#name : #GtClassCoderPackagesAndHierarchyNavigation,
	#superclass : #GtClassCoderPackagesTreeNavigation,
	#category : #'GToolkit-Coder-Navigation'
}

{ #category : #converting }
GtClassCoderPackagesAndHierarchyNavigation >> asElement [
	^ GtCoderNavigationPackagesAndHierarchyElement new
		navigationModel: self
]
