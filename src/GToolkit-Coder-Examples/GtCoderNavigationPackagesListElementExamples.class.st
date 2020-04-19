Class {
	#name : #GtCoderNavigationPackagesListElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationPackagesListElementExamples >> fromAllPackages [
	<gtExample>
	
	^ GtCoderNavigationPackagesListElement fromPackages: RPackageOrganizer default packages
]
