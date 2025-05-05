Class {
	#name : #GtCoderNavigationPackagesListElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationPackagesListElementExamples >> fromAllPackages [
	<gtExample>
	<return: #GtCoderPackagesTreeElement>
	^ GtCoderPackagesTreeElement fromPackages: RPackageOrganizer default packages
]
