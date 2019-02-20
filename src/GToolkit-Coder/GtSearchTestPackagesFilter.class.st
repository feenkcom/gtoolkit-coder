Class {
	#name : #GtSearchTestPackagesFilter,
	#superclass : #GtSearchPackagesFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #testing }
GtSearchTestPackagesFilter >> includesPackage: aPackage [
	^ aPackage definedClasses anySatisfy: [ :aClass |
		aClass isTestCase ]
]
