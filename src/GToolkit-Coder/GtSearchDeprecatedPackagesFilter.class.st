Class {
	#name : #GtSearchDeprecatedPackagesFilter,
	#superclass : #GtSearchPackagesFilter,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #testing }
GtSearchDeprecatedPackagesFilter >> includesPackage: aPackage [
	^ aPackage isDeprecated
]
